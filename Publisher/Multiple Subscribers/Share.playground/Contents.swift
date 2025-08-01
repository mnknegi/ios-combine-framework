
import Foundation
import Combine

// Share the output of an upstream publisher with multiple subscribers.

let pub = (1...3).publisher
    .delay(for: 1, scheduler: DispatchQueue.main)
    .map { _ in return Int.random(in: 1...100) }
    .print("Random")
    .share()

let cancellable1 = pub
    .sink(receiveValue: { print("Stream 1 received: \($0)") })

let cancellable2 = pub
    .sink(receiveValue: { print("Stream 2 received: \($0)") })

// Reuses upstream: both multicast and share.
// Requires .connect(): multicast yes and with share no.
// Subject injection: multicast(Yes custom subject) and share(use internal subject).
// Replay last value: multicast(only when using currentValueSubject) and share(No).
// Use case control: Fine-grained control with multicast, share - less control, good for quick use.
// Type: multicast(connectablePublisher) and share(regular Publisher).
