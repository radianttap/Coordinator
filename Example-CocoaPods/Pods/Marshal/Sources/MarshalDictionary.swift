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


// MARK: - Types

public typealias MarshalDictionary = [String: Any]


// MARK: - Dictionary Extensions

extension Dictionary: MarshaledObject {
    public func optionalAny(for key: KeyType) -> Any? {
        guard let aKey = key as? Key else { return nil }
        return self[aKey]
    }
}

extension NSDictionary: ValueType { }

extension NSDictionary: MarshaledObject {
    public func any(for key: KeyType) throws -> Any {
        guard let value: Any = self.value(forKeyPath: key.stringValue) else {
            throw MarshalError.keyNotFound(key: key)
        }
        if let _ = value as? NSNull {
            throw MarshalError.nullValue(key: key)
        }
        return value
    }
    
    public func optionalAny(for key: KeyType) -> Any? {
        return self[key]
    }
}
