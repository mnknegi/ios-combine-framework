
import Foundation
import Combine

// Publishes the value of a key path.

struct DiceRoll1 {
    let die1: Int
}

struct DiceRoll2 {
    let die1: Int
    let die2: Int
}

struct DiceRoll3 {
    let die1: Int
    let die2: Int
    let die3: Int
}

var cancellable = Set<AnyCancellable>()

print(" ---- map(_:) ---- ")

Just(DiceRoll1(die1: Int.random(in: (1...6))))
    .map(\.die1)
    .sink(receiveValue: { print("\($0)") })
    .store(in: &cancellable)

print(" ---- map(_:_:) ---- ")

Just(DiceRoll2(die1: Int.random(in: (1...6)),
              die2: Int.random(in: (1...6))))
    .map(\.die1, \.die2)
    .sink(receiveValue: { print("\($0), \($1)") })
    .store(in: &cancellable)

print(" ---- map(_:_:_:) ---- ")

Just(DiceRoll3(die1: Int.random(in: (1...6)),
              die2: Int.random(in: (1...6)),
              die3: Int.random(in: (1...6))))
    .map(\.die1, \.die2, \.die3)
    .sink(receiveValue: { print("\($0), \($1), \($2)") })
    .store(in: &cancellable)
