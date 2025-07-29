
import Foundation
import Combine

struct ParseError: Error { }

func romanNumeral(from: Int) throws -> String {
    let romanNumeralDict: [Int: String] = [1: "I", 2: "II", 3: "III", 4: "IV", 5: "V"]
    guard let numeral = romanNumeralDict[from] else {
        throw ParseError()
    }
    return numeral
}

let numbers = [1, 2, 3, 0, 4, 5]

var cancellable = Set<AnyCancellable>()

numbers.publisher
    .tryMap { try romanNumeral(from: $0) }
    .sink(receiveCompletion: { print("completion \($0)") },
          receiveValue: { print("\($0)", terminator: " ") })
    .store(in: &cancellable)

print(" ")

/*
// ------------- Real-World use case

struct User: Decodable {
    let id: Int
    let name: String
}

let jsonData = """
{ "id": 1, "name": "Mayank Negi" }
""".data(using: .utf8)!

let dataPublisher = Just(jsonData)

dataPublisher
    .tryMap { data in
        try JSONDecoder().decode(User.self, from: data)
    }
    .sink(receiveCompletion: { print("Completion \($0)") }) { user in
        print("User: \(user.name)")
    }
    .store(in: &cancellable)
*/
