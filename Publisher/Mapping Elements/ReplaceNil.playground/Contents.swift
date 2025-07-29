
import Foundation
import Combine

// Replaces nil elements in the stream with the provided element.

var cancellable = Set<AnyCancellable>()

let numbers: [Double?] = [1.0, 2.0, nil, 3.0]
numbers.publisher
    .replaceNil(with: 0.0)
    .sink(receiveValue: { print("\($0)", terminator: " ") })
    .store(in: &cancellable)
