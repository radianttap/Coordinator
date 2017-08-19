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

public protocol Marshaling {
    associatedtype MarshalType: MarshaledObject
    
    func marshaled() -> Self.MarshalType
}
