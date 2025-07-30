
import Foundation
import Combine

// Collect all received elements, and emits a single array when the upstream publisher finishes.

let numbers = (0...10)

var cancellable = Set<AnyCancellable>()

numbers.publisher
    .map { $0 * 2 }
    .collect()
    .sink(receiveValue: { print("\($0)") })
    .store(in: &cancellable)

print(" ---- ")

/* Collect(Int) */
// Collects up to the specified number of elements, and then emits a single array of the collection.

numbers.publisher
    .collect(5)
    .sink(receiveValue: { print("\($0)") })
    .store(in: &cancellable)

print(" ---- ")

/* Collect(_: Options:) */
// Collects elements by a given time-grouping strategy, and emits a single array of the collection.
// TimeGroupingStrategy = A strategy for collecting received elements.

//Timer.publish(every: 1, on: .main, in: .default)
//    .autoconnect()
//    .collect(.byTime(RunLoop.main, .seconds(5)))
//    .sink(receiveValue: { print("\($0)") })
//    .store(in: &cancellable)

let publisher = Timer.publish(every: 1.0, on: .main, in: .default)
    .autoconnect()
    .scan(0) { count, _ in
        count + 1
    }
    .eraseToAnyPublisher()

publisher
    .collect(.byTime(RunLoop.main, .seconds(3)))
    .sink(receiveValue: { print("\($0)") })
    .store(in: &cancellable)
