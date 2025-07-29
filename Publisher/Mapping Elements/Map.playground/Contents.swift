
import Combine

// transforms all elements from the upstream publisher with a provided closure.

let numbers = [5, 4, 3, 2, 1, 0]
let romanNumeralDict: [Int: String] = [
    1: "I", 2: "II", 3: "III", 4: "IV", 5: "V"
]

var cancellable = Set<AnyCancellable>()

numbers.publisher
    .map { romanNumeralDict[$0] ?? "[unknown]" }
    .sink { print("\($0)", terminator: " ") }
    .store(in: &cancellable)


print("")
//----------- Real-World use case

struct User {
    let firstName: String
    let lastName: String
}

let userPublisher = Just(User(firstName: "Mayank", lastName: "Negi"))

userPublisher
    .map { "\($0.firstName) \($0.lastName)" }
    .sink { fullName in
        print("User's full name is \(fullName)")
    }
    .store(in: &cancellable)
