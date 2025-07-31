
import Foundation
import Combine

/* combineLatest */
// Used to combine the latest values from two publishers and emit a new value whenever either publisher emits.
// Waits until both publishers have emitted at least one value. Then emits a tuple of their latest values every time either one emits.

let subjectA = PassthroughSubject<String, Never>()
let subjectB = PassthroughSubject<Int, Never>()

var cancellabel = Set<AnyCancellable>()

subjectA
    .combineLatest(subjectB)
    .sink(receiveValue: { print("\($0)") })
    .store(in: &cancellabel)

subjectA.send("A")
subjectA.send("B")
subjectB.send(0)
subjectB.send(1)
subjectA.send("C")

print(" ---- ")

// Use to synchronizing user input from multiple fields(username + password).
// Merging latest sensor data from multiple sources.
// Handling state updates from multiple asynchronous publishers.


let pub1 = PassthroughSubject<Int, Never>()
let pub2 = PassthroughSubject<Int, Never>()

pub1
    .combineLatest(pub2) { first, second in
        first * second
    }
    .sink(receiveValue: { print("\($0)") })
    .store(in: &cancellabel)

pub1.send(1)
pub1.send(3)
pub2.send(4)
pub1.send(6)
pub2.send(10)
