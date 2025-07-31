
import Foundation
import Combine

/* drop(untilOutputFrom:) */
// Ignores elements from the upstream publisher until it receives an element from a second publisher.

let upstream = PassthroughSubject<Int, Never>()
let second = PassthroughSubject<String, Never>()

var cancellable = Set<AnyCancellable>()

upstream
    .drop(untilOutputFrom: second)
    .sink(receiveValue: { print("\($0)") })
    .store(in: &cancellable)

upstream.send(1)
upstream.send(2)
second.send("A")
upstream.send(3)
upstream.send(4)

print(" ------ ")

/* dropFirst(_:) */
// Omits the first n values emitted by a publisher and then passes through the rest.
// default is 1.

let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
numbers.publisher
    .dropFirst(5)
    .sink(receiveValue: { print("\($0)") })
    .store(in: &cancellable)

print(" ------ ")

/* drop(while:) */
// Ignores(drops) values from the upstream publisher until the closure you provide returns false for the first time. After that it lets all values through, regardless of the condition.

numbers.publisher
    .drop(while: { $0 < 4 })
    .sink(receiveValue: { print("\($0)") })
    .store(in: &cancellable)

print(" ------ ")

/* tryDrop(while:) */
// Ignores(drops) values from the upstream publisher until an error-throwing closure you provide returns false for the first time. After that it lets all values through, regardless of the condition.
struct RangeError: Error { }
var nums = [1, 2, 3, 4, 5, 6, -1, 7, 8, 9, 10]
//var nums = [1, 2, 3, 4, 5, 6, 0, -1, 7, 8, 9, 10]
let range: CountableClosedRange<Int> = (1...100)
nums.publisher
    .tryDrop {
        guard $0 != 0 else { throw RangeError() }
        return range.contains($0)
    }
    .sink(receiveCompletion: { print("completion: \($0)")},
          receiveValue: { print("value: \($0)") })
    .store(in: &cancellable)
