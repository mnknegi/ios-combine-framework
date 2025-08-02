
import Foundation
import Combine

// Specify the scheduler on which to receive elements from the publisher.

let queue = DispatchQueue(label: "com.queue")

var cancellable = Set<AnyCancellable>()

[1, 2, 3].publisher
    .subscribe(on: DispatchQueue.global(qos: .background))
    .map { value in
        print("Mapping on: \(Thread.current)")
        return value * 2
    }
    .receive(on: DispatchQueue.main)
    .sink(receiveValue: { print("value received: \($0)") })
    .store(in: &cancellable)


URLSession.shared.dataTaskPublisher(for: URL(string: "https://example.com")!)
    .subscribe(on: DispatchQueue.global(qos: .background))
    .map(\.data)
    .decode(type: String.self, decoder: JSONDecoder())
    .receive(on: DispatchQueue.main)
    .sink(receiveCompletion: { print("completion: \($0)") },
          receiveValue: { print("received values: \($0)") })
    .store(in: &cancellable)
