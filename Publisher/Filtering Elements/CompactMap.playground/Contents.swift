
import Foundation
import Combine

// Transform + filter nils in one go.

let numbers = (0...5)
let romanNumeralDict: [Int: String] = [1: "I", 2: "II", 3: "III", 5: "V"]

var cancellable = Set<AnyCancellable>()

numbers.publisher
    .compactMap { romanNumeralDict[$0] }
    .sink(receiveValue: { print("\($0)", terminator: " ") })

print(" -------- ")

/* TryCompactMap */

// failable version of CompactMap(_:).
// - If transform returns a non-nil value -> it's emitted.
// - If transform returns nil -> it's filtered out.
// - If transform throws -> the stream fails.

struct ParseError: Error { }

func romanNumeral(from: Int) throws -> String? {
    let romanNumeralDict: [Int: String] = [1: "I", 2: "II", 4: "IV", 5: "V"]
    guard from != 0 else { throw ParseError() }
    return romanNumeralDict[from]
}

let numerals = [6, 5, 4, 3, 2, 1, 0]
numerals.publisher
    .tryCompactMap { try romanNumeral(from: $0) }
    .sink(receiveCompletion: { print("\($0)") },
          receiveValue: { print("\($0)", terminator: " ") })
    .store(in: &cancellable)
