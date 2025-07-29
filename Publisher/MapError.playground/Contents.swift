
import Foundation
import Combine

// Converts any failure from the upstream publisher into a new error.

struct DivisionByZeroError: Error { }

struct MyGenericError: Error { var wrappedError: Error }

func myDivide(_ dividend: Double, _ divisor: Double) throws -> Double {
    guard divisor != 0 else { throw DivisionByZeroError() }
    return dividend / divisor
}

var cancellable = Set<AnyCancellable>()

let divisors: [Double] = [5, 4, 3, 2, 1, 0]
divisors.publisher
    .tryMap { try myDivide(1, $0) }
    .mapError { MyGenericError(wrappedError: $0) }
    .sink(receiveCompletion: { print("completion: \($0)") },
          receiveValue: { print("value: \($0)", terminator: " ") })
    .store(in: &cancellable)
