
import Foundation
import Combine

/* measureInterval */
// Measures the time between emitted elements and those intervals as output.
// Instead of emitting the original values from upstream, it emits the time intervals between emissions.

let subject = PassthroughSubject<String, Never>()
var cancellable = Set<AnyCancellable>()

subject
    .measureInterval(using: DispatchQueue.main)
    .sink { interval in
        print("interval: \(interval.timeInterval) seconds.")
    }
    .store(in: &cancellable)

subject.send("First")

DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
    subject.send("Second")
}

DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
    subject.send("Third")
}


print(" ---- Example 2 ---- ")

Timer.publish(every: 1, on: .main, in: .default)
    .autoconnect()
    .measureInterval(using: RunLoop.main)
    .sink(receiveValue: { print("\($0)", terminator: " ") })
    .store(in: &cancellable)
