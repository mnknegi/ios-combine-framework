
import Foundation
import Combine

// Controls on which scheduler(thread/queue) the subscription work of a publisher happens.
// It tells combine where to run:
// the subscription side effects(e.g. network request creation, file read and database query setup).
// It doesn't change where the values are delivered to the subscriber - that's what receive(on:) does.

let queue = DispatchQueue(label: "com.queue.background")

var cancellable = Set<AnyCancellable>()

[1, 2, 3].publisher
    .handleEvents(receiveSubscription: { _ in print("Subscriptin received on: \(Thread.current)") })
    .subscribe(on: queue) // run subscription setup on background queue.
    .sink(receiveValue: { _ in print("value received on: \(Thread.current)") })
    .store(in: &cancellable)


// Example 2

URLSession.shared.dataTaskPublisher(for: URL(string: "https://example.com")!)
    .subscribe(on: DispatchQueue.global(qos: .background)) // offload heave work in the global background queue.
    .receive(on: DispatchQueue.main) // get the response on the main thread.
    .sink(receiveCompletion: { print("completion: \($0)") },
          receiveValue: { print("value: \($0)") })
    .store(in: &cancellable)
