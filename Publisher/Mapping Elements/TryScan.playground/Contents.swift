
import Foundation
import Combine

// failable version of scan - it accumulates values over time just like scan, but allows the combining closure to throw an error.

struct DivisionByZeroError: Error { }

func myThrowingFunction(_ lastValue: Int, _ currentValue: Int) throws -> Int {
    guard currentValue != 0 else { throw DivisionByZeroError() }
    return (lastValue + currentValue) / currentValue
}

let numbers = [1, 2, 3, 4, 5, 0, 6, 7, 8, 9]
var cancellable = Set<AnyCancellable>()

numbers.publisher
    .tryScan(10) { try myThrowingFunction($0, $1) }
    .sink(receiveCompletion: { print("\($0)") },
          receiveValue: { print("\($0)", terminator: " ") } )
    .store(in: &cancellable)
