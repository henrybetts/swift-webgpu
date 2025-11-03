import Foundation

/// A reprensentation of the webgpu.yml / webgpu.json data model.
struct WebGPUData: Decodable {
    struct Enum: Decodable {
        var name: String

        struct Entry: Decodable {
            var name: String
            var value: Int?
        }

        @DefaultFallback var entries: [Entry?]
    }

    struct Bitflag: Decodable {
        var name: String
        @DefaultFallback var entries: [Entry]
        
        struct Entry: Decodable {
            var name: String
        }
    }

    enum Pointer: String, Decodable {
        case immutable
        case mutable
    }

    enum `Type`: Decodable, Equatable {        
        enum PrimitiveType: String {
            case bool
            case optionalString = "nullable_string"
            case string = "string_with_default_empty"
            case outString = "out_string"
            case uint16
            case uint32
            case uint64
            case usize
            case int16
            case int32
            case float32
            case optionalFloat32 = "nullable_float32"
            case float64
            case float64Super = "float64_supertype"
        }
        
        enum ComplexType: String {
            case typedef
            case `enum`
            case bitflag
            case `struct`
            case functionType = "function_type"
            case object
        }

        case void
        case primitive(PrimitiveType)
        case primitiveArray(PrimitiveType)
        case complex(ComplexType, String)
        case complexArray(ComplexType, String)
        case callback(String)

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            var typeString = try container.decode(String.self)
            
            if typeString == "c_void" {
                self = .void
                return
            }
            
            let isArray: Bool
            if typeString.hasPrefix("array<") && typeString.hasSuffix(">") {
                isArray = true
                typeString = String(typeString.dropFirst(6).dropLast(1))
            } else {
                isArray = false
            }

            if let primitiveType = PrimitiveType(rawValue: typeString) {
                self = isArray ? .primitiveArray(primitiveType) : .primitive(primitiveType)
                return
            }
            
            let components = typeString.split(separator: ".", maxSplits: 1)
            if components.count == 2 {
                if let complexType = ComplexType(rawValue: String(components[0])) {
                    let name = String(components[1])
                    self = isArray ? .complexArray(complexType, name) : .complex(complexType, name)
                    return
                }

                if components[0] == "callback" && !isArray {
                    self = .callback(String(components[1]))
                    return
                }
            }

            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "Unknown type: \(typeString)"))
        }
    }

    struct Parameter: Decodable {
        var name: String
        var type: Type
        var pointer: Pointer?
        @DefaultFallback var optional: Bool
        var `default`: DefaultValue?
        
        struct DefaultValue: Decodable {
            // a default value can be a string, number or bool, but we only really need the textual representation
            var stringValue: String
            
            init(from decoder: any Decoder) throws {
                let container = try decoder.singleValueContainer()
                
                do {
                    stringValue = try container.decode(String.self)
                    return
                } catch DecodingError.typeMismatch {}
                
                do {
                    stringValue = String(try container.decode(Int.self))
                    return
                } catch DecodingError.typeMismatch {}
                
                do {
                    stringValue = String(try container.decode(Double.self))
                    return
                } catch DecodingError.typeMismatch {}
                
                do {
                    stringValue = String(try container.decode(Bool.self))
                    return
                } catch DecodingError.typeMismatch {}
                
                throw DecodingError.typeMismatch(DefaultValue.self, .init(codingPath: decoder.codingPath, debugDescription: "Expected a String, Number or Bool type."))
            }
        }
    }

    struct Struct: Decodable {
        enum `Type`: String, Decodable {
            case extensible
            case extensibleCallbackArg = "extensible_callback_arg"
            case `extension`
            case standalone
        }

        var name: String
        var type: `Type`
        @DefaultFallback var members: [Parameter]
    }
    
    struct Callback: Decodable {
        enum Style: String, Decodable {
            case callbackMode = "callback_mode"
            case immediate
        }
        
        var name: String
        var style: Style
        @DefaultFallback var args: [Parameter]
    }

    struct Function: Decodable {
        struct Returns: Decodable {
            var type: Type
            @DefaultFallback var optional: Bool
            var pointer: Pointer?
        }

        var name: String
        var returns: Returns?
        var callback: String?
        @DefaultFallback var args: [Parameter]
    }

    struct Object: Decodable {
        var name: String
        @DefaultFallback var methods: [Function]
    }

    var enums: [Enum]
    var bitflags: [Bitflag]
    var structs: [Struct]
    var callbacks: [Callback]
    var functions: [Function]
    var objects: [Object]

    init(jsonData: Data) throws {
        let decoder = JSONDecoder()
        self = try decoder.decode(WebGPUData.self, from: jsonData)
    }
}
