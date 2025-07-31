
import Foundation
import Combine

// Combines elements from two publishers into pairs, emitting a new tuple only when both publishers have emitted a new value.
// Wait for one value from each publisher before emitting a pair.
// After emitting a pair, waits for the next value from both publishers.
// One value from each side is zipped together.

let subjectA = PassthroughSubject<String, Never>()
let subjectB = PassthroughSubject<Int, Never>()

var cancellable = Set<AnyCancellable>()

subjectA
    .zip(subjectB)
    .sink { valueA, valueB in
        print("Zipper: \(valueA), \(valueB)")
    }
    .store(in: &cancellable)

subjectA.send("A1")
subjectA.send("A2")
subjectB.send(1)
subjectA.send("A3")
subjectB.send(2)
subjectB.send(3)
subjectB.send(4)
subjectA.send("A4")
