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

public typealias JSONObject = MarshalDictionary


// MARK: - Parser

public struct JSONParser {
    
    fileprivate init() { }
    
    public static func JSONObjectWithData(_ data: Data) throws -> JSONObject {
        let object: Any = try JSONSerialization.jsonObject(with: data, options: [])
        guard let objectValue = object as? JSONObject else {
            throw MarshalError.typeMismatch(expected: JSONObject.self, actual: type(of: object))
        }
        return objectValue
    }
    
    public static func JSONArrayWithData(_ data: Data) throws -> [JSONObject] {
        let object: Any = try JSONSerialization.jsonObject(with: data, options: [])
        guard let array = object as? [JSONObject] else {
            throw MarshalError.typeMismatch(expected: [JSONObject].self, actual: type(of: object))
        }
        return array
    }
}


// MARK: - Collections

public protocol JSONCollectionType {
    func jsonData() throws -> Data
}

extension JSONCollectionType {
    public func jsonData() throws -> Data {
        let jsonCollection = self
        return try JSONSerialization.data(withJSONObject: jsonCollection, options: [])
    }
}

extension Dictionary : JSONCollectionType {}

extension Array : JSONCollectionType {}

extension Set : JSONCollectionType {}


// MARK: - Marshaling

public protocol JSONMarshaling {
    func jsonObject() -> JSONObject
}
