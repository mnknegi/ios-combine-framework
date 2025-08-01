
import Foundation
import Combine

// Delays the emission of values from an upstream publisher by a specified amount of time.

let subject = PassthroughSubject<String, Never>()
var cancellable = Set<AnyCancellable>()

subject
    .delay(for: .seconds(2), tolerance: .zero, scheduler: DispatchQueue.main)
    .sink(receiveCompletion: { completion in print("completed") },
          receiveValue: { print("Received after dalay: \($0)") })
    .store(in: &cancellable)

subject.send("Hello")
subject.send("World")
subject.send(completion: .finished)
