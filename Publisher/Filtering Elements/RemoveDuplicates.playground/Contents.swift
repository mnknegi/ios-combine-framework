
import Foundation
import Combine

// Filter out consecutive duplicate values from the publisher's output stream.
// Only adjacent duplicate values are removed.

let numbers = [0, 1, 2, 2, 3, 3, 3, 4, 4, 4, 4, 0, 1]
var cancellable = Set<AnyCancellable>()

numbers.publisher
    .removeDuplicates()
    .sink(receiveValue: { print("\($0)") })
    .store(in: &cancellable)

print(" ")

// -------- //
/* removeDuplicates(by:) */
// Filter consecutive duplicate values using a custom comparison function(predicate), instead of relying on Equatable.

struct User {
    let id: Int
    let name: String
}

let users = [
    User(id: 1, name: "Mayank"),
    User(id: 1, name: "Ved"),
    User(id: 2, name: "Vaasu"),
    User(id: 2, name: "Mahima"),
    User(id: 3, name: "Ashish"),
    User(id: 1, name: "Mahendra"),
    User(id: 2, name: "Laxmi")
]

users.publisher
    .removeDuplicates { $0.id == $1.id }
    .sink(receiveValue: { print(("\($0.name)")) })
    .store(in: &cancellable)


// -------- //
/* tryRemoveDuplicates(by:) */
// Filter consecutive duplicate values using a custom throwing comparison function(predicate).

struct BadValuesError: Error { }
numbers.publisher
    .tryRemoveDuplicates { first, second -> Bool in
        if first == 4 && second == 4 {
            throw BadValuesError()
        }
        return first == second
    }
    .sink(receiveCompletion: { print("completion: \($0)") },
          receiveValue: { print("\($0)", terminator: " ") })
    .store(in: &cancellable)
