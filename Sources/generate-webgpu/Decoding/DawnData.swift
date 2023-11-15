import Foundation


// MARK: Primitives

enum Category: String, Decodable {
    case native
    case typedef
    case `enum`
    case bitmask
    case structure
    case object
    case constant
    case function
    case functionPointer = "function pointer"
}

enum Length: Equatable {
    case fixed(Int)
    case string
    case member(String)
    
    static let single = Length.fixed(1)
}

extension Length: HasDefaultValue {
    init() {
        self = .single
    }
}

extension Length: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = try .fixed(container.decode(Int.self))
        } catch DecodingError.typeMismatch {
            let value = try container.decode(String.self)
            if value == "strlen" {
                self = .string
            } else {
                self = .member(value)
            }
        }
    }
}

enum Annotation: String, Decodable {
    case pointer = "const*"
    case mutablePointer = "*"
    case pointerToPointer = "const*const*"
}

enum Extensibility: String {
    case none
    case `in`
    case out
}

extension Extensibility: HasDefaultValue {
    init() {
        self = .none
    }
}

extension Extensibility: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            let value = try container.decode(String.self)
            if let extensibility = Extensibility(rawValue: value) {
                self = extensibility
                return
            }
        } catch DecodingError.typeMismatch {
            let value = try container.decode(Bool.self)
            if !value {
                self = .none
                return
            }
        }
        
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid value"))
    }
}


// MARK: Custom Decoders

@propertyWrapper
struct DefaultValueDecoder {
    // "default" values in dawn.json can be strings or ints
    var wrappedValue: String?
}

extension DefaultValueDecoder: DefaultFallbackProtocol {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self.wrappedValue = try container.decode(String.self)
        } catch DecodingError.typeMismatch {
            self.wrappedValue = try String(container.decode(Int.self))
        }
    }
}


// MARK: Secondary Data

struct EnumValueData: Taggable, Decodable {
    @DefaultFallback var tags: Set<String>
    var name: String
    var value: Int
}

struct RecordMemberData: Taggable, Decodable {
    @DefaultFallback var tags: Set<String>
    var name: String
    var type: String
    var annotation: Annotation?
    @DefaultFallback var length: Length
    @DefaultFallback var optional: Bool
    @DefaultValueDecoder var `default`: String?
}

typealias RecordData = [RecordMemberData]

struct MethodData: Taggable, Decodable {
    @DefaultFallback var tags: Set<String>
    var name: String
    var returns: String?
    @DefaultFallback var args: RecordData
}


// MARK: Type Data

protocol TypeData: Taggable {
    var category: Category { get }
    var tags: Set<String> { get }
}

struct NativeTypeData: TypeData, Decodable {
    var category: Category
    @DefaultFallback var tags: Set<String>
}

struct TypedefTypeData: TypeData, Decodable {
    var category: Category
    @DefaultFallback var tags: Set<String>
    var type: String
}

struct EnumTypeData: TypeData, Decodable {
    var category: Category
    @DefaultFallback var tags: Set<String>
    var values: [EnumValueData]
}

struct StructureTypeData: TypeData, Decodable {
    var category: Category
    @DefaultFallback var tags: Set<String>
    var members: RecordData
    @DefaultFallback var extensible: Extensibility
    @DefaultFallback var chained: Extensibility
}

struct ObjectTypeData: TypeData, Decodable {
    var category: Category
    @DefaultFallback var tags: Set<String>
    @DefaultFallback var methods: [MethodData]
}

struct ConstantTypeData: TypeData, Decodable {
    var category: Category
    @DefaultFallback var tags: Set<String>
    var type: String
    var value: String
}

struct FunctionTypeData: TypeData, Decodable {
    var category: Category
    @DefaultFallback var tags: Set<String>
    var returns: String?
    @DefaultFallback var args: RecordData
}


// MARK: Dawn Data

struct DawnData: Decodable {
    var types: [String: TypeData]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        var types: [String: TypeData] = [:]
        
        for key in container.allKeys {
            if key.starts(with: "_") { continue }

            let unresolved = try container.nestedContainer(keyedBy: String.self, forKey: key)
            let category = try unresolved.decode(Category.self, forKey: "category")
            
            switch category {
            case .native:
                types[key] = try container.decode(NativeTypeData.self, forKey: key)
            case .typedef:
                types[key] = try container.decode(TypedefTypeData.self, forKey: key)
            case .enum, .bitmask:
                types[key] = try container.decode(EnumTypeData.self, forKey: key)
            case .structure:
                types[key] = try container.decode(StructureTypeData.self, forKey: key)
            case .object:
                types[key] = try container.decode(ObjectTypeData.self, forKey: key)
            case .constant:
                types[key] = try container.decode(ConstantTypeData.self, forKey: key)
            case .function, .functionPointer:
                types[key] = try container.decode(FunctionTypeData.self, forKey: key)
            }
        }
        
        self.types = types
    }
    
    init(from data: Data) throws {
        let decoder = JSONDecoder()
        self = try decoder.decode(Self.self, from: data)
    }
}
