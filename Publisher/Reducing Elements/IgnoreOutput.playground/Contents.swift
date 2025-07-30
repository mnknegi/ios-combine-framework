
import Foundation
import Combine

// Used when we don't care about the values emitted by a publisher - only whether it conpletes sucessfully or fails.
// Ignores(supresses) all output values, Only passes along completion events(.finished or .failure).

var cancellable = Set<AnyCancellable>()

[1, 2, 3, 4, 5].publisher
    .ignoreOutput()
    .sink(receiveCompletion: { print("\($0)") },
          receiveValue: { print("\($0)") }) // this will be ignored
    .store(in: &cancellable)

struct MyError: Error { }

[1, 2, 3, 4, 5].publisher
    .tryMap { value in
        if value == 4 {
            throw MyError()
        }
    }
    .ignoreOutput()
    .sink(receiveCompletion: { print("\($0)") },
          receiveValue: { print("\($0)") }) // this will be ignored
    .store(in: &cancellable)
