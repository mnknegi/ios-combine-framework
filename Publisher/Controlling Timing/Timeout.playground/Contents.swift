
import Foundation
import Combine

// Terminate a publisher with an error if it doesn't emit a value within a specified time interval.

enum TimeoutError: Error {
    case tookTooLong
}

let subject = PassthroughSubject<String, TimeoutError>()
var cancellable = Set<AnyCancellable>()

subject
    .timeout(.seconds(1.0), scheduler: DispatchQueue.main, customError: { .tookTooLong })
    .sink { completion in
        switch completion {
        case .finished:
            print("Finished")
        case .failure(let error):
            print("Timeout error: \(error)")
        }
    } receiveValue: { value in
        print("Received value: \(value)")
    }
    .store(in: &cancellable)

subject.send("A")

DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
    subject.send("B")
}

