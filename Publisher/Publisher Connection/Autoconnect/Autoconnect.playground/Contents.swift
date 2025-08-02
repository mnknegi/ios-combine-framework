
import Foundation
import Combine

// It is not something which we can create directly. It is a type returned when we call .connect() on a ConnectablePublisher.

/*
 What is a connectable Publisher?

 A ConnectablePublisher is a publisher that doesn't start publishing values until you explicitly connect it by calling .connect().
 e.g. Timer.publish(...) return a Timer.TimerPublisher which is a ConnectablePublisher.
 We need to call .connect() manually to start a timer.
 */

/*
 What does .autoconnect() do?

 .autoconnect() wraps your ConnectablePublisher in a Autoconnect publisher.
 This automatically calls .connect() when the first subscriber attaches, so we don't have to manually manage connections.

 */

// Without .autoconnect()

//let timer = Timer.TimerPublisher(interval: 1.0, runLoop: .main, mode: .common)

var cancellable = Set<AnyCancellable>()

//timer
//    .sink(receiveValue: { print("received: \($0)") })
//    .store(in: &cancellable)
//
//timer.connect()


// With .autoconnect()

let newTimer = Timer.TimerPublisher(interval: 1.0, runLoop: .main, mode: .common)

newTimer
    .autoconnect()
    .sink(receiveValue: { print("value: \($0)") })
    .store(in: &cancellable)

/*
 When to use .autoconnect()?

 When you want a timer or other connectable publisher to start automatically when subscribe to.
 When you don't need to control the exact moment the publisher starts producing values.
 */
