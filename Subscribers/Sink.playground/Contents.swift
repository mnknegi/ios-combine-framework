
import Foundation
import Combine

/* sink(receiveCompletion:receiveValue:) */
// Most common subscriber method with receivecCompletion and receiveValue closures.

var cancellable = Set<AnyCancellable>()

[1, 2, 3].publisher
    .sink { completion in
        switch completion {
        case .finished:
            print("Completed successfully.")
        case .failure(let error):
            print("Finished with error: \(error)")
        }
    } receiveValue: { value in
        print("Received value: \(value)")
    }
    .store(in: &cancellable)



print(" ---- Example 2 ---- ")



enum MyError: Error { case example }

Fail<Int, MyError>(error: .example)
    .sink { completion in
        if case .failure(let error) = completion {
            print("Error received:", error)
        }
    } receiveValue: { value in
        print("Value:", value)
    }
    .store(in: &cancellable)

print(" \n ---- sink(receiveValue:) ---- ")


/* sink(receiveValue:) */
// Attach a subscriber with a closure based publisher that never fails.

let integers = (1...10)
integers.publisher
    .sink { value in
        print("Received values: \(value)")
    }
    .store(in: &cancellable)
