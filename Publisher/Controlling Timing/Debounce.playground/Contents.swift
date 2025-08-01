
import Foundation
import Combine

// Publishes elements only after a specified time interval elapses between events.
// Note: with debounce the timer updates everytime when a new value is emitted.

let bounces: [(Int, TimeInterval)] = [
    (0, 0), // time interval between index 0 and 1 is 0.25. It will not be printed.
    (1, 0.25), // time interval between index 1 and 2 is 0.75. It will be printed.
    (2, 1), // time interval between index 2 and 3 is 0.25. It will not be printed.
    (3, 1.25), // time interval between index 3 and 4 is 0.25. It will not be printed.
    (4, 1.5), // time interval between index 4 and 5 is 0.5. It will be printed.
    (5, 2), // This is the last value, so it will be printed.
]

var cancellable = Set<AnyCancellable>()

let subject = PassthroughSubject<Int, Never>()
subject
    .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
    .sink { index in
        print("Received index: \(index)")
    }
    .store(in: &cancellable)

for bounce in bounces {
    DispatchQueue.main.asyncAfter(deadline: .now() + bounce.1) {
        subject.send(bounce.0)
    }
}


// " ---- Example 2 ---- "


let subject1 = PassthroughSubject<String, Never>()

subject1
    .debounce(for: .seconds(1.0), scheduler: DispatchQueue.main)
    .sink(receiveValue: { print("\($0)") })
    .store(in: &cancellable)

subject1.send("A") // The timer is in 0

DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
    subject1.send("B") // A is cancelled by B. The timer reaches 0.3 sec before cancelling A and then reset to 0.
}

DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
    subject1.send("C") // B is cancelled by C. The timer reaches 0.6 sec before cancelling B and then reset to 0.
}

DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
    subject1.send("D") // C is cancelled by D as the time difference is only 0.9 sec. D is the last value so it will be emitted.
}
