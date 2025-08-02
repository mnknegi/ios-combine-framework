
import Foundation
import Combine

// Waits until the subscriber attaches before creating and subscribing to its actual underlaying publisher.
/*
 When we create a publisher like Just(5), it's created immediately and ready to emit.
 With deferred, the creation of the publisher is postponed until subscription time.
 This is useful when:
    You want to create a fresh state for every subscriber.
    You want the execution to happen only when needed.
*/

/* How it works
 We pass a closure to deferred that returns a new publisher.
 Each time a subscriber subscribes:
    Deferred runs a closure.
    It subscribes the subscriber to the new publisher.
 This means each subscriber gets its own publisher instance.
 */

// without deferred
let publisher = Just(Date())

let cancellable1 = publisher
    .sink(receiveValue: { print("value: \($0)") })

sleep(2)

let cancellable2 = publisher
    .sink(receiveValue: { print("value: \($0)") })

// Both the subscribers receive the same value as the publisher is the same instance.

// with deferred

let deferredPubliser = Deferred {
    Just(Date())
}

sleep(1)

let cancellable3 = deferredPubliser
    .sink(receiveValue: { print("value: \($0)") })

sleep(2)

let cancellable4 = deferredPubliser
    .sink(receiveValue: { print("value: \($0)") })

// Time-sensitive values.
// Fresh resource per subscriber.
// Delaying expensive setup.

/*
 Relation to future
 - Future runs immediately when the subscriber subscribes.
 - Deferred is about postponing publisher creation, not just execution. It says don't even create a publisher until a subscriber subscribes and make a fresh one for each subscriber.
 */
