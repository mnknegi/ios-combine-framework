
import Foundation
import Combine

// Replaces an empty stream(i.e., a publisher that completes without emitting any values) with a single default value.
// If the upstream emits any value -> replaceEmpty does nothing.
// If the upstream completes without emitting -> it emits the provided default value.

let emptyPublisher = Empty<Int, Never>()

var cancellable = Set<AnyCancellable>()

emptyPublisher
    .replaceEmpty(with: 1000)
    .sink(receiveValue: { print("\($0)") } )
    .store(in: &cancellable)

print("Ignore default")

// Ignore default
let justPublisher = Just(50)
justPublisher
    .replaceEmpty(with: 1000)
    .sink(receiveValue: { print("\($0)") } )
    .store(in: &cancellable)

// Real-World use case
func fetchUsers() -> AnyPublisher<[String], Never> {
    Just([])
        .replaceEmpty(with: ["No users found"])
        .eraseToAnyPublisher()
}

fetchUsers()
    .sink(receiveValue: { print("\($0)") })  // [] is not empty so the output will be [].
    .store(in: &cancellable)

let numbers: [Double] = []
numbers.publisher
    .replaceEmpty(with: Double.nan)
    .sink(receiveValue: { print("\($0)") }) // Here numbers is a empty array and its publisher has nothing to emit so here replaceEmpty will produce a value.
    .store(in: &cancellable)
