
import Foundation
import Combine

// Operator we use on a Publisher to store the emitted values before passing them downstream. It's helpful when your upstream publisher emits values faster than your downstream subscriber can handle.

let publisher = PassthroughSubject<Int, Never>()

publisher
    .buffer(size: 3, prefetch: .keepFull, whenFull: .dropOldest)
    .sink(receiveValue: { print("Received: \($0)") })

publisher.send(1)
publisher.send(2)
publisher.send(3)
publisher.send(4) // Drops 1 (oldest), keeps 2, 3, 4 in buffer
publisher.send(5) // Drops 2 (oldest), keeps 3, 4, 5
