
import Foundation
import Combine

// Conditionally allow or block values emitted by a publisher. It only let values through if they satisfy the given condition.

let numbers = [1, 2, 3, 4, 5]
var cancellable = Set<AnyCancellable>()

numbers.publisher
    .filter { $0 % 2 == 0 }
    .sink(receiveValue: { print("\($0)", terminator: " ") } )
    .store(in: &cancellable)

print(" ---- ")

/* TryFilter */

// Republishes all elements that match a provided error-throwing closure.

struct ZeroError: Error { }

let nums = [1, 2, 3, 4, 0, 5]
nums.publisher
    .tryFilter { value in
        if value == 0 {
            throw ZeroError()
        } else {
            return value % 2 == 0
        }
    }
    .sink(receiveCompletion: { print("\($0)") },
          receiveValue: { print("\($0)", terminator: " ") } )
    .store(in: &cancellable)
