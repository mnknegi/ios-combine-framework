
import Foundation
import Combine

// Used to automatically log all events passing through a pipeline in a readable format.
// It a convenience wrapper around the handleEvents for quick logging.

let publisher = [1, 2, 3].publisher
publisher
    .print("MyPublisher")
    .sink(receiveValue: { print("value received: \($0)") })
