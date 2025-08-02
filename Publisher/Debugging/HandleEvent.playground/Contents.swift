
import Foundation
import Combine

// It is used to observe the events flowing through the combine pipeline without modifying the stream.
// It is mainly used for debugging, logging, analytics and side effects.

let publisher = [1, 2, 3].publisher
    .handleEvents(receiveSubscription: { _ in print("Subscribed") },
                  receiveOutput: { print("Output: \($0)") },
                  receiveCompletion: { print("Completion: \($0)") },
                  receiveCancel: { print("Cancel") },
                  receiveRequest: { print("Request: \($0)") })
    .sink(receiveValue: { print("received value: \($0)") })

// Since .breakpoint() won’t work in Playgrounds, .handleEvents is a better alternative for logging.
