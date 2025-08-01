
import Foundation
import Combine

// Used to share a single subscription to an upstream publisher among multiple subscribers.

let pub = ["First", "Second", "Third"].publisher
    .map { return ($0, Int.random(in: 0...100)) }
    .print("Random")
    .multicast { PassthroughSubject<(String, Int), Never>() }

let cancellable1 = pub
    .sink(receiveValue: { print("Stream 1 received: \($0)") })

let cancellable2 = pub
    .sink(receiveValue: { print("Stream 2 received: \($0)") })

pub.connect()


print(" ---- Example 2 ---- ")

let subject = PassthroughSubject<Int, Never>()
let publisher = (1...3).publisher
    .print("Upstream")
    .multicast(subject: subject)

let cancellable3 = publisher
    .sink(receiveValue: { print("Subscriber 1 received: \($0)") })

let cancellable4 = publisher
    .sink(receiveValue: { print("Subscriber 2 received: \($0)") })

publisher.connect()
