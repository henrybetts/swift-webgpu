class UserData<T> {
    let value: T
    let retained: Bool
    
    init(_ value: T, retained: Bool = false) {
        self.value = value
        self.retained = retained
    }
    
    func toOpaque() -> UnsafeMutableRawPointer {
        if self.retained {
            return Unmanaged.passRetained(self).toOpaque()
        } else {
            return Unmanaged.passUnretained(self).toOpaque()
        }
    }
    
    static func passRetained(_ value: T) -> UnsafeMutableRawPointer {
        return UserData(value, retained: true).toOpaque()
    }
    
    static func takeValue(_ ptr: UnsafeRawPointer) -> T {
        let unmanaged = Unmanaged<UserData<T>>.fromOpaque(ptr)
        let userData = unmanaged.takeUnretainedValue()
        if userData.retained {
            unmanaged.release()
        }
        return userData.value
    }
}
