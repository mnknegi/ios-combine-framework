
import Foundation
import Combine

// A Future is a combine publisher that wraps a one-time asynchronous task and turns it into a publisher.
// Its for asynchronous work where we know that we will get only one value, success or failure.

// Future is a single value asynchronous publisher.
// It produces exactly one value or one error and then finishes.

// Future is useful when we have a asynchronous operation(network request, database fetch), you want to wrap it in combine publisher to use combine operators and you know it will produce only one result.

// final class Future<Output, Failure> : Publisher where Failure: Error

/*
 How future works?

 When you create a Future, you pass a closure that takes a promise. The promise is a function `(Result<Output, Failure>) -> Void`.
 */

func generateAsyncRandomNumberFromFuture() -> Future<Int, Never> {
    return Future { promise in
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let number = Int.random(in: 1...10)
            promise(.success(number))
        }
    }
}

var cancellable = Set<AnyCancellable>()
generateAsyncRandomNumberFromFuture()
    .sink(receiveValue: { print("Got random number: \($0)") })
    .store(in: &cancellable)


print(" \n failure case ")

enum MyError: Error { case myError }

func failingFuture() -> Future<Int, MyError> {
    Future { promise in
        promise(.failure(.myError))
    }
}

failingFuture()
    .sink(receiveCompletion: { print("completed with: \($0)") },
          receiveValue: { print("value received: \($0)") })
    .store(in: &cancellable)


// One shot one - you can't emit multiple values
// The closure executes everytime a subscriber subscribes. (important)
// If you want to share the result with multiple subscribers, you might combine it with .share() or .multicase() operators.
