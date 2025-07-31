
import Foundation
import Combine

/* Merge */
// Merge the two publisher of the same output and failure type into a single stream - emitting all values from both publishers as they arrive.
// Values are interleaved: emit items from either publisher as they come.
// Does not wait for both to emit - unlike combineLatest or zip.

let subjectA = PassthroughSubject<String, Never>()
let subjectB = PassthroughSubject<String, Never>()

var cancellable = Set<AnyCancellable>()

subjectA
    .merge(with: subjectB)
//    .sink(receiveValue: { print("Received: \($0)") })
    .sink(receiveCompletion: { print("complete: \($0)") },
          receiveValue: { print("received: \($0)") })

subjectA.send("A1")
subjectB.send("B1")
subjectB.send("B2")
subjectA.send("A2")
subjectB.send("B3")

// It combines multiple data sources that produce the same type of output.
// Listen to events from multiple UI components or services.
// Merge network requests.
