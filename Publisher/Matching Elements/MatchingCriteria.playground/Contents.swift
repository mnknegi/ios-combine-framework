
import Foundation
import Combine

/* Contains */
// Publishes a Boolean value upon receiving an element equal to the argument.

let numbers = [1, 2, 3, 4, 5]

var cancellable = Set<AnyCancellable>()

numbers.publisher
    .contains(4)
    .sink(receiveValue: { print("result: \($0)") })
    .store(in: &cancellable)

numbers.publisher
    .contains(6)
    .sink(receiveValue: { print("result: \($0)") })
    .store(in: &cancellable)

/* contains(where:) */
// Publishes a Boolean value upon receiving an element that satisfies the predicate closure.

numbers.publisher
    .contains { $0 > 4 }
    .sink(receiveValue: { print("result: \($0)") })
    .store(in: &cancellable)

/* tryContains(where:) */
// Publishes a Boolean value upon receiving an element that satisfies the throwing predicate closure.

struct IllegalValueError: Error { }

numbers.publisher
    .tryContains {
        if $0 % 2 != 0 {
            throw IllegalValueError()
        }
        return $0 < 10
    }
    .sink(receiveCompletion: { print("\($0)") },
          receiveValue: { print("\($0)") })
    .store(in: &cancellable)


/* allSatisfy */
// Publishes a Boolean value that indicates whether all received elements pass a given predicate.

let targetRange = (-1...1000)
let nums = [-1, 0, 10, 5]

nums.publisher
    .allSatisfy { targetRange.contains($0) }
    .sink(receiveValue: { print("result: \($0)") })
    .store(in: &cancellable)

/* tryAllSatisfy */
// Publishes a Boolean value that indicates whether all received elements pass a given error-throwing predicate.

let numArray = [-1, 0, 10, 0]

struct RangeError: Error { }

numArray.publisher
    .tryAllSatisfy {
        guard $0 != 0 else { throw RangeError() }
        return targetRange.contains($0)
    }
    .sink(receiveCompletion: { print("\($0)") },
          receiveValue: { print("\($0)") })
    .store(in: &cancellable)
