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


// MARK: - <| Operator

precedencegroup Decodative {
    associativity: left
}

infix operator <|

public func <| <A: ValueType>(dictionary: MarshaledObject, key: String) throws -> A {
    return try dictionary.value(for: key)
}
public func <| <A: ValueType>(dictionary: MarshaledObject, key: String) throws -> A? {
    return try dictionary.value(for: key)
}
public func <| <A: ValueType>(dictionary: MarshaledObject, key: String) throws -> [A] {
    return try dictionary.value(for: key)
}
public func <| <A: ValueType>(dictionary: MarshaledObject, key: String) throws -> [A]? {
    return try dictionary.value(for: key)
}
public func <| <A: RawRepresentable>(dictionary: MarshaledObject, key: String) throws -> A where A.RawValue: ValueType {
    return try dictionary.value(for: key)
}
public func <| <A: RawRepresentable>(dictionary: MarshaledObject, key: String) throws -> A? where A.RawValue: ValueType {
    return try dictionary.value(for: key)
}
public func <| <A: RawRepresentable>(dictionary: MarshaledObject, key: String) throws -> [A] where A.RawValue: ValueType {
    return try dictionary.value(for: key)
}
public func <| <A: RawRepresentable>(dictionary: MarshaledObject, key: String) throws -> [A]? where A.RawValue: ValueType {
    return try dictionary.value(for: key)
}
public func <| (dictionary: MarshaledObject, key: String) throws -> JSONObject {
    return try dictionary.value(for: key)
}
public func <| (dictionary: MarshaledObject, key: String) throws -> JSONObject? {
    return try dictionary.value(for: key)
}
public func <| (dictionary: MarshaledObject, key: String) throws -> [JSONObject] {
    return try dictionary.value(for: key)
}
public func <| (dictionary: MarshaledObject, key: String) throws -> [JSONObject]? {
    return try dictionary.value(for: key)
}
public func <| <A: ValueType>(dictionary: MarshaledObject, key: String) throws -> [String: A] {
    return try dictionary.value(for: key)
}
public func <| <A: ValueType>(dictionary: MarshaledObject, key: String) throws -> [String: A]? {
    return try dictionary.value(for: key)
}
