import UIKit

var str = "Hello, playground"

var myInt = 0

extension Int {
    func plusOne() -> Int {
        return self + 1
    }
}

print("\(myInt.plusOne())")

// protocol oriented programming
extension BinaryInteger {
    func squared() -> Self {
        return self * self
    }
}

// BinaryInteger is the protocol assigned to Int8, int64, UInt64 etc... all integer types
