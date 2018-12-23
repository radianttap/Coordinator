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


public protocol UnmarshalingWithContext {
    associatedtype ContextType
    associatedtype ConvertibleType = Self
    
    static func value(from object: MarshaledObject, inContext context: ContextType) throws -> ConvertibleType
}

public protocol UnmarshalUpdatingWithContext {
    associatedtype ContextType
    mutating func update(object: MarshaledObject, inContext context: ContextType) throws
}

extension MarshaledObject {
    public func value<A: UnmarshalingWithContext>(for key: KeyType, inContext context: A.ContextType) throws -> A {
        let any = try self.any(for: key)
        guard let object = any as? MarshaledObject else {
            throw MarshalError.typeMismatch(expected: MarshaledObject.self, actual: type(of: any))
        }
        guard let value = try A.value(from: object, inContext: context) as? A else {
            throw MarshalError.typeMismatch(expected: A.self, actual: type(of: object))
        }
        return value
    }
    
    public func value<A: UnmarshalingWithContext>(for key: KeyType, inContext context: A.ContextType) throws -> A? {
        do {
            let a: A = try self.value(for: key, inContext: context)
            return a
        }
        catch MarshalError.keyNotFound {
            return nil
        }
        catch MarshalError.nullValue {
            return nil
        }
    }
    
    public func value<A: UnmarshalingWithContext>(for key: KeyType, inContext context: A.ContextType) throws -> [A] {
        let any = try self.any(for: key)
        guard let objectArray = any as? [AnyObject] else {
            throw MarshalError.typeMismatch(expected: Array<MarshaledObject>.self, actual: type(of: any))
        }
        return try objectArray.map { untypedObject in
            guard let object = untypedObject as? MarshaledObject else {
                throw MarshalError.typeMismatch(expected: MarshaledObject.self, actual: type(of: untypedObject))
            }
            guard let value = try A.value(from: object, inContext: context) as? A else {
                throw MarshalError.typeMismatch(expected: A.self, actual: type(of: object))
            }
            return value
        }
    }
    
    public func value<A: UnmarshalingWithContext>(for key: KeyType, inContext context: A.ContextType) throws -> [A]? {
        do {
            return try self.value(for: key, inContext: context) as [A]
        }
        catch MarshalError.keyNotFound {
            return nil
        }
        catch MarshalError.nullValue {
            return nil
        }
    }
}
