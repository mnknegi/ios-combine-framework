
import Foundation
import Combine

// In Combine, a Subject is both:
// A publisher: It can send values to subscribers.
// A Subscriber: I can receive values from other publishers

/*
 Normally, publisher in combine only send data when subscribe to.
 A subject can send data anytime.

 It is useful when we want to manually inject a value in combine pipeline.
 */

/*
 Types of Subjects:
 1. Passthrough Subject: It do not save the last value and only use to broadcast the last value.
 2. CurrentValue Subject: Requires an initial value and stores the most recent value and send it to new subscriber immediately.
 */

let passthroughSubject = PassthroughSubject<String, Never>()

var cancellable = Set<AnyCancellable>()

passthroughSubject
    .sink(receiveValue: { print($0) })
    .store(in: &cancellable)

passthroughSubject.send("Hello")
passthroughSubject.send("World")

print(" ---- CurrentValueSubject ---- ")

let currentValueSubject = CurrentValueSubject<Int, Never>(5)

currentValueSubject
    .sink(receiveValue: { print("\($0)") })
    .store(in: &cancellable)

currentValueSubject.send(10)
currentValueSubject.send(15)


print(" ---- Subscribe to other publishers ---- ")

let subject = PassthroughSubject<Int, Never>()
[1, 2, 3].publisher.subscribe(subject)


subject
    .sink(receiveValue: { print("\($0)") })
    .store(in: &cancellable)
