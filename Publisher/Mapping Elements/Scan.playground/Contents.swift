
import Foundation
import Combine

// Scan works like reduce, but emits intermediate results each time a new value is received.

let range = (0...5)

var cancellable = Set<AnyCancellable>()

range.publisher
    .scan(0, +)
    .sink(receiveValue: { print("\($0)", terminator: " ") } )
    .store(in: &cancellable)
