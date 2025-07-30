
import Foundation
import Combine

// Combine all the elements of a sequence into a single value.

var  cancellable = Set<AnyCancellable>()

[1, 2, 3, 4, 5].publisher
    .reduce(0) { sum, value in sum + value }
    .sink(receiveValue: { print("\($0)") })
    .store(in: &cancellable)

print(" ---- ")

[2, 4, 6, 8, 10].publisher
    .reduce(0, +)
    .sink(receiveValue: { print("\($0)") })
    .store(in: &cancellable)


print("-- tryReduce --")

/* tryReduce */
// Combine all the elements of a sequence by applying error-throwing closure.

struct DivisionbyZeroError: Error { }
func myDivide(_ divident: Double, _ divisor: Double) throws -> Double {
    guard divisor != 0 else { throw DivisionbyZeroError() }
    return divident / divisor
}

var numbers = [5.0, 4.0, 3.0, 2.0, 1.0, 0.0]
numbers.publisher
    .tryReduce(0) { try myDivide($0, $1) }
    .catch({ _ in Just(Double.nan) })
    .sink(receiveValue: { print("\($0)") })
    .store(in: &cancellable)
