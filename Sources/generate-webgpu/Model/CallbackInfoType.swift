class CallbackInfoType: Type {
    let members: Record
    
    init(name: String, data: CallbackInfoTypeData) {
        var membersData = data.members.filter { !$0.isUpstream }
        
        if let modeIndex = membersData.firstIndex(where: { $0.name == "mode" }) {
            membersData[modeIndex].default = "allow spontaneous"
        }
        
        members = Record(data: membersData, context: .structure)
        super.init(name: name, data: data)
    }
    
    override func link(model: Model) {
        members.link(model: model)
    }
    
    var modeMember: RecordMember? {
        return members.first { $0.name == "mode" }
    }
    
    var callbackMember: RecordMember {
        return members.first { $0.name == "callback" }!
    }
    
    var hasDefaultSwiftInitializer: Bool {
        return members.removingHidden.allSatisfy { $0.defaultSwiftValue != nil }
    }
}
