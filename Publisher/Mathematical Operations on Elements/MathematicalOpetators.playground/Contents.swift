
import Foundation
import Combine

// Publishes the number of elements received from the upstream publisher.

let numbers = [5, 2, 7, 1, 10, 8]

var cancellable = Set<AnyCancellable>()

numbers.publisher
    .count()
    .sink(receiveValue: { print("\($0)") })
    .store(in: &cancellable)

print("-----")

/* max Publisher */
// Publishes the maximum value received from the upsteam publisher, after it finishes.

numbers.publisher
    .max()
    .sink(receiveValue: { print("\($0)") })
    .store(in: &cancellable)

print("-----")

/* max(by:) */
// Find the maximum value from a stream of emitted values, based on a custom comparison closure.

numbers.publisher
    .max(by: <)
    .sink(receiveValue: { print("\($0)") } )
    .store(in: &cancellable)

print("-----")

enum Rank: Int {
    case ace = 1, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king
}

let cards: [Rank] = [.five, .queen, .ace, .eight, .jack]
cards.publisher
    .max {
        $0.rawValue < $1.rawValue
    }
    .sink(receiveValue: { print("\($0)") } )
    .store(in: &cancellable)

print("-----")

struct Person {
    let name: String
    let age: Int
}

let people = [
    Person(name: "Alice", age: 28),
    Person(name: "Bob", age: 35),
    Person(name: "Charlie", age: 30)
]

people.publisher
    .max(by: { $0.age < $1.age })
    .sink(receiveValue: { print("\($0)")} )
    .store(in: &cancellable)

print("-----")


/* max(by:) */
// Determine max value received from the upstream publisher using an error-throwing closure you specify.

struct IllegalValueError: Error { }

numbers.publisher
    .tryMax { first, second in
        if first % 2 != 0 {
            throw IllegalValueError()
        }
        return first < second
    }
    .sink(receiveCompletion: { print("completion: \($0)") },
          receiveValue: {"value: \($0)"} )
    .store(in: &cancellable)

