
import Foundation
import Combine

// Replace an error in the stream with the provided element.

struct MyError: Error { }

let fail = Fail<String, MyError>(error: MyError())

var cancellable = Set<AnyCancellable>()

fail
    .replaceError(with: "replacement element")
    .sink(receiveValue: { print("\($0)") })
    .store(in: &cancellable)


print(" ----- ")

func fetchUserID() -> AnyPublisher<Int, Never> {
    URLSession.shared.dataTaskPublisher(for: URL(string: "https://exaple.com/user")!)
        .map(\.data)
        .decode(type: Int.self, decoder: JSONDecoder())
        .replaceError(with: -1000)
        .eraseToAnyPublisher()
}

fetchUserID()
    .sink(receiveValue: { print("\($0)") })
    .store(in: &cancellable)
