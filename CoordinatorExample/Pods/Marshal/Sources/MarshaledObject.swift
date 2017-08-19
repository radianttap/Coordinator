//
//  M A R S H A L
//
//       ()
//       /\
//  ()--'  '--()
//    `.    .'
//     / .. \
//    ()'  '()
//
//


import Foundation


public protocol MarshaledObject {
    func any(for key: KeyType) throws -> Any
    func optionalAny(for key: KeyType) -> Any?
}

public extension MarshaledObject {
    public func any(for key: KeyType) throws -> Any {
        let pathComponents = key.stringValue.characters.split(separator: ".").map(String.init)
        var accumulator: Any = self
        
        for component in pathComponents {
            if let componentData = accumulator as? Self, let value = componentData.optionalAny(for: component) {
                accumulator = value
                continue
            }
            throw MarshalError.keyNotFound(key: key.stringValue)
        }
        
        if let _ = accumulator as? NSNull {
            throw MarshalError.nullValue(key: key.stringValue)
        }
        
        return accumulator
    }
    
    public func value<A: ValueType>(for key: KeyType) throws -> A {
        let any = try self.any(for: key)
        do {
            guard let result = try A.value(from: any) as? A else {
                throw MarshalError.typeMismatchWithKey(key: key.stringValue, expected: A.self, actual: type(of: any))
            }
            return result
        }
        catch let MarshalError.typeMismatch(expected: expected, actual: actual) {
            throw MarshalError.typeMismatchWithKey(key: key.stringValue, expected: expected, actual: actual)
        }
    }
    
    public func value<A: ValueType>(for key: KeyType) throws -> A? {
        do {
            return try self.value(for: key) as A
        }
        catch MarshalError.keyNotFound {
            return nil
        }
        catch MarshalError.nullValue {
            return nil
        }
    }
    
    public func value<A: ValueType>(for key: KeyType, discardingErrors: Bool = false) throws -> [A] {
        let any = try self.any(for: key)
        do {
            return try Array<A>.value(from: any, discardingErrors: discardingErrors)
        }
        catch let MarshalError.typeMismatch(expected: expected, actual: actual) {
            throw MarshalError.typeMismatchWithKey(key: key.stringValue, expected: expected, actual: actual)
        }
    }

    public func value<A: ValueType>(for key: KeyType) throws -> [A?] {
        let any = try self.any(for: key)
        do {
            return try Array<A>.value(from: any)
        }
        catch let MarshalError.typeMismatch(expected: expected, actual: actual) {
            throw MarshalError.typeMismatchWithKey(key: key.stringValue, expected: expected, actual: actual)
        }
    }

    public func value<A: ValueType>(for key: KeyType, discardingErrors: Bool = false) throws -> [A]? {
        do {
            return try self.value(for: key, discardingErrors: discardingErrors) as [A]
        }
        catch MarshalError.keyNotFound {
            return nil
        }
        catch MarshalError.nullValue {
            return nil
        }
    }
    
    public func value<A: ValueType>(for key: KeyType) throws -> [A?]? {
        do {
            return try self.value(for: key) as [A]
        }
        catch MarshalError.keyNotFound {
            return nil
        }
        catch MarshalError.nullValue {
            return nil
        }
    }

    public func value<A: ValueType>(for key: KeyType) throws -> [String: A] {
        let any = try self.any(for: key)
        do {
            return try [String: A].value(from: any)
        }
        catch let MarshalError.typeMismatch(expected: expected, actual: actual) {
            throw MarshalError.typeMismatchWithKey(key: key.stringValue, expected: expected, actual: actual)
        }
    }

    public func value<A: ValueType>(for key: KeyType) throws -> [String: A]? {
        do {
            let any = try self.any(for: key)
            return try [String: A].value(from: any)
        }
        catch MarshalError.keyNotFound {
            return nil
        }
        catch MarshalError.nullValue {
            return nil
        }
    }

    public func value(for key: KeyType) throws -> [MarshalDictionary] {
        let any = try self.any(for: key)
        guard let object = any as? [MarshalDictionary] else {
            throw MarshalError.typeMismatchWithKey(key: key.stringValue, expected: [MarshalDictionary].self, actual: type(of: any))
        }
        return object
    }
    
    public func value(for key: KeyType) throws -> [MarshalDictionary]? {
        do {
            return try value(for: key) as [MarshalDictionary]
        }
        catch MarshalError.keyNotFound {
            return nil
        }
        catch MarshalError.nullValue {
            return nil
        }
    }

    public func value(for key: KeyType) throws -> MarshalDictionary {
        let any = try self.any(for: key)
        guard let object = any as? MarshalDictionary else {
            throw MarshalError.typeMismatchWithKey(key: key.stringValue, expected: MarshalDictionary.self, actual: type(of: any))
        }
        return object
    }
    
    public func value(for key: KeyType) throws -> MarshalDictionary? {
        do {
            return try value(for: key) as MarshalDictionary
        }
        catch MarshalError.keyNotFound {
            return nil
        }
        catch MarshalError.nullValue {
            return nil
        }
    }

    public func value<A: ValueType>(for key: KeyType) throws -> Set<A> {
        let any = try self.any(for: key)
        do {
            return try Set<A>.value(from: any)
        }
        catch let MarshalError.typeMismatch(expected: expected, actual: actual) {
            throw MarshalError.typeMismatchWithKey(key: key.stringValue, expected: expected, actual: actual)
        }
    }
    
    public func value<A: ValueType>(for key: KeyType) throws -> Set<A>? {
        do {
            return try self.value(for: key) as Set<A>
        }
        catch MarshalError.keyNotFound {
            return nil
        }
        catch MarshalError.nullValue {
            return nil
        }
    }
    
    public func value<A: RawRepresentable>(for key: KeyType) throws -> A where A.RawValue: ValueType {
        let raw = try self.value(for: key) as A.RawValue
        guard let value = A(rawValue: raw) else {
            throw MarshalError.typeMismatchWithKey(key: key.stringValue, expected: A.self, actual: raw)
        }
        return value
    }
    
    public func value<A: RawRepresentable>(for key: KeyType) throws -> A? where A.RawValue: ValueType {
        do {
            return try self.value(for: key) as A
        }
        catch MarshalError.keyNotFound {
            return nil
        }
        catch MarshalError.nullValue {
            return nil
        }
    }
    
    public func value<A: RawRepresentable>(for key: KeyType) throws -> [A] where A.RawValue: ValueType {
        let rawArray = try self.value(for: key) as [A.RawValue]
        return try rawArray.map({ raw in
            guard let value = A(rawValue: raw) else {
                throw MarshalError.typeMismatchWithKey(key: key.stringValue, expected: A.self, actual: raw)
            }
            return value
        })
    }
    
    public func value<A: RawRepresentable>(for key: KeyType) throws -> [A]? where A.RawValue: ValueType {
        do {
            return try self.value(for: key) as [A]
        }
        catch MarshalError.keyNotFound {
            return nil
        }
        catch MarshalError.nullValue {
            return nil
        }
    }
    
    public func value<A: RawRepresentable>(for key: KeyType) throws -> Set<A> where A.RawValue: ValueType {
        let rawArray = try self.value(for: key) as [A.RawValue]
        let enumArray: [A] = try rawArray.map({ raw in
            guard let value = A(rawValue: raw) else {
                throw MarshalError.typeMismatchWithKey(key: key.stringValue, expected: A.self, actual: raw)
            }
            return value
        })
        return Set<A>(enumArray)
    }
    
    public func value<A: RawRepresentable>(for key: KeyType) throws -> Set<A>? where A.RawValue: ValueType {
        do {
            return try self.value(for: key) as Set<A>
        }
        catch MarshalError.keyNotFound {
            return nil
        }
        catch MarshalError.nullValue {
            return nil
        }
    }
}
