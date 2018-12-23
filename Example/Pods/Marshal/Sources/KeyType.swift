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


public protocol KeyType {
    var stringValue: String { get }
}

extension String: KeyType {
    public var stringValue: String {
        return self
    }
}
