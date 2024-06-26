
# Combine

A `declrative Swift API` for `processing values over time`. I allows us to write `functional reactive` code. 
A functional reactive proramming allow you to process values over time. These kind of values are - Network response, userinterface events and other asynchronous event.

Example of FPR resonse:
- A network response is received.
- Its data is mapped to a JSON model.
- It is then assigned to a view.

## Table of Content
- [Introduction](#combine)
- [Functional Reactive Programming](#functional-reactive-programming)
- [Publisher](#publisher)

## Functional Reactive Programming

Functional Reactive Programming in Swift is a programming paradigm that combines `functinal programming` and `Reactive programming` to manage and compose asynchronous data stream. It allow us to handle data flows and the propagation change, making it easier to work with dynamic and time-varying values.

### Key concept in FRP:

- **Streams:** It treats data as a continuous stream of values over time. These streams can be observed and manipulated.

- **Signals:** Signals are the basic building block of FRP. One can subscribe to the signal to get notified whenever a new value is emitted.

- **Events:** Events are the individual values or occurances within a stream. They can represent anything from user inputs to network responses.

- **Observables:** Observables are types that represent a collection of future events. They allow you to define asynchronous sequences of data that can be observed.

- **Schedulers:** Schedulers control the execution context of signals and streams, allowing you to manage threading and concurrency.

- **Bindings:** FRP allows you to bind signals to UI elements or other data structures, ensuring that updates propagate automatically.


## Publisher

A publisher exposes values(that can change) on which a subscriber subscribes to receives all the updates.

- Publisher are like Observables.
- Subscribers are like Observers.

A Combine publisher is an object that sends values to its subscribers over time. Sometimes this is a single value, and other times a publisher can transmit multiple values or no values at all.

This defines how values and errors are produced over time. Its a value type which means we use struct. Publishers allow registration of subscribers. It provides data when available and upon request.

```
protocol Publisher {
associatedType output
associatedType Failure: Error

func subscribe<S: Subscriber>(_ subscriber: S) where S.Input == output, S.failure == failure
}
```

In the swift combine framework, a `publisher` is a protocol representing a sequence of the values over time. Publishers emit values, errors or a completion signal to subscriber.
A `Publisher` in combine conforms to `Publisher` protocol which defines methods and behaviors that allow for the transformation, combination and subscription to the values.

`Key characterstics of Publisher:`

- Emit Values: A publisher can emit value of a specified type over time. These values could represent event, data or any kind of information.
- Emit Errors: A publisher can emit error if anything goes wrong in the stream of events. Errors are represented by `Error` type in swift.
- Completion: A publisher can send completion signal to indicate that it has finished emitting values. The completion can finish with a success or a failure with an error.
- Supports Subscription: Publishers allow subscribers to connect to them and receive emitted values. Subscribers can request a certain number of values or an unlimited number, and they can cancel the subscription when they no longer want to receive values.
- Transformations: Publishers provide various operators (map, filter, flatMap, etc.) that allow for the transformation, combination, and manipulation of emitted values before they reach subscribers.

## Subscriber

A subscriber is responsible for requesting data and receiving the data or the error provided by the publisher. It can receive a value or a completion signal. It is of reference type.

```
protocol Subscriber {
associatedType Input
associatedType Failure: Error

func receive(subscription: Subscription)
func receive(_ input: Input) -> Subscription.Demand
func receive(completion: Subscriber.Completion<Failure>)
}
```

Publishers and operators are pointless unless something is listening to the published events. The something is the Subscriber. The Subscirber initiate the request for data and controls the amount of the data it receives.
The Subscriber receives the value, error or completion signal from the publisher.

There are two build in subscribers in combine in swift: `sink` and `assign`. There is another subscriber in SwiftUI which is `onReceive`.

Subscribers can support cancellation, which terminates a subscription which shut down all the streams. Both sink and assign are conform to` Cancellable` protocol.
