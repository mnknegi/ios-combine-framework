# ios-combine-framework

## Functional Reactive Programming

- Build on the principle that comes from functional programming.
- It enables us to write a code that can be composed using many small functions that operate only on their inputs without changing anything outside of the function itself.
- For example map function in Swift.
- The function that only operates on the arguments it receives is called `pure function`.

- Reactive part in FRP means we don't operate on objects synchronously. Instead, we compose functions and operations in such a way that when something happens and we receive a new value of something, we perform a operation on it and get the certain outcome. Here the values are transmitted over time.

- In Combine events are called `stream`.

- It's ok to perform mutation or to operate on world that surrounds the sink because it is not the part of publisher chain.

- FRP uses Functional Programming to react to events that occur over time, or asynchronously.

- Publishers is an enum and that it's a "namespace for the type that serves as a publishers". This enum contains lot of Combine's build-in publishers.
- Publisher's associated types are: Output and Failure.

- The `sink` subscriber is an extension on Publisher. This means that we can use sink to subscribe to every possible publisher in Combine because all publishers must conform to Publisher protocol.
- Assign is second convenient build-in subscriber. It is also defined on Publishers and it allows us to directly assign publisher values to the property on an object.
- The assign method requires that the keyPath that we want to assign values to is a ReferenceWritableKeyPath.
- Both sink and assign return an object called `AnyCancellable`.
- When the AnyCancellable is deallocated, any subscription that is associated with this object is torn down along with it.

## Transforming Publishers

If we want to apply an operator to the output of a publisher that would transform that output into a new publisher, we'd have a publisher that would publishes other publishers.

- FlatMap -  In flatMap we receive values from a publisher and then change them into a new publisher and the nested publisher's result were then delivered to the sink.

Publisher can limit the input they can receive from their upstream publisher. 

## Operators that might fail

- Publishers can only complete or emit an error once. This means that after an error is thrown, the publisher can't emit new values. This is important to consider when you throw an error from an operator. Once the error is thrown, there is no going back.

- AnyPublisher: This operator removes all type information from the publisher and wraps it in an AnyPublisher.

- A subject is a special kind of publisher that allows us to inject the values into the stream. A subject allows us to determine which values are published, and when.
- Combine subjects are useful when the code is written in imperative style.
- Subjects in combine have a send(_:) method that allows us to send values down the publisher's stream of values.
- The origin of the value stream is often existing, imperative code that doesn't hold a state. This makes a PassthroughSubject a good fit for publishing values that represent ephemeral data, like events.

- PassthroughSubject doesn't hold on to any of the values that it has sent in the past. All it does is accept the value that you want to send, and that value is immediately send to all the subscribers and discarded afterwards.

- Use a CurrentValueSubject to represent a stateful stream of values.

- Wrap properties with the @Published property wrapper to turn them into publisher.
- To subscribe to a @Published property's changes, we need to use a `$` prefix on the property name.
- This allow us to access the wrapper itself, also known as projected value rather than the value that is wrapped by the property.
- In this case wrapper's projectedValue is a publisher, so we can subscribe to that property.

- @Published Property wrapper and CurrentVallueSubject are the same in functionality. The only difference is that the @Published wrapper update the underlaying property value after emitting the value to the subscriber but the CurrentValueSubject will update the underlaying value before emitting the value to the subscriber.
- @Published property can only be used with a class but CurrentValueSubject can be used with classes and structures.
- We can't use send(_:) on @Publisher as it is not a Subject. 
- Assigning a new value to a @Published property automatically emits this new value to subscribers which is equivaluent to using send(_:) with a new value.

## Choose an appropriate publisher for sending a information

- To publish an stream of events without a concept of state, then use PassthroughSubject.
- If we have a model that is defined as a struct, we can expose new data through CurrentValueSubject. This allow us to keep sending the new data to the subscribers while keeping the concept of current state, or value.
- If we are woking with class and we want the same behaviour as CurrentValueSubject except for not being to end the stream of values if needed, the @Publisher is likely to fit the need.

- `assign(to:)` assign the output of a publisher to the @Published property. This subscriber is created to link the output of the publisher to a @Published property without causing any retain cycle like `assign(to:on:)` does when assigning to a keyPath on self.
- assign(to:) manages its own cancellable and doesn't return one for us to manage. Its lifecycle is tied to @Publisher property that it assigns value to.

- Everything in SwiftUI is handled through property wrapper that manage state, like the @ObservableObject and @StateObject property wrapper for example. Both of these property wrappers are used to wrap objects that conform to ObservableObject protocol. The ObservableObject protocol can be applied to the classes and it automatically `adds objectWillChangePublisher` property to conforming class. This property observes all the @published properties contained in the ObservableObject and emits a value through its objectWillChangePublisher if any @Published property changes. 

`Debounding:` Waiting for a little while before processing user input.
- Debounce resets its cooldown period for every received value, the throttle operator will emits value at a given time interval. When we apply the throttle operator, we can choose whether we want to emit the first value received during the throttled interval or the last.

`Zip` publisher takes two or more publishers, and will output tuples of the values that are published by the publisher it zips. The values that are emitted by Publishers.Zip are tuples.
The number of values in these tuples is equal to the number of publishers it zipped. The values in these tuples can be accessed by their positions.

- If only one of the two(or more) zipped publisher emits a new value, we won't immidiately receive this value. This means that if one of the two publishers completes before the other publsher is completed, we won't get the new value from the uncompleted publisher because the already completed publisher doesn't emit new values anymore.
