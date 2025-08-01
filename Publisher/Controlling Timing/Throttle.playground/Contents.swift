
import Foundation
import Combine

// Limit the rate at which the values are emitted from an upstream publisher, by only allowing one value to pass through during each specific time interval.
// It has a boolean value latest that indicates whether to publish the most recent element. if false, the publisher emits the first element received during the interval. If true, then publisher emits the last value before the timeout.

var cancellable = Set<AnyCancellable>()

Timer.publish(every: 3.0, on: RunLoop.main, in: .default)
    .autoconnect()
    .print("\(Data().description)") // receive values in every 3 seconds from timer publisher.
    .throttle(for: 10.0, scheduler: RunLoop.main, latest: true)
    .sink(receiveCompletion: { print("completed: \($0)") },
          receiveValue: { print("Received Timestamp: \($0)") }) // receive latest value before throttle timer reaches its threshold.
    .store(in: &cancellable)
