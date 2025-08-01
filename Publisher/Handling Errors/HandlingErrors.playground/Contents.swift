
import Foundation
import Combine

/* assertNoFailure(_:file:line:) */
// It is used to assert that no .failure completion has occurred.
// It raises a fatal error when its upstream publisher fail, and otherwise republishes all received input.

enum SubjectError: Error {
    case genericSubjectError
}

let subject = CurrentValueSubject<String, Error>("initial value")
subject
    .assertNoFailure()
    .sink(receiveCompletion: { print("completion: \($0)") },
          receiveValue: { print("value: \($0).") })

subject.send("second value")
//subject.send(completion: Subscribers.Completion<Error>.failure(SubjectError.genericSubjectError))


print(" ---- catch(_:) ---- ")


// Handles errors from an upstream publisher by replacing it with another publisher.
// It intercepts errors from failing publishers and replaces them with another publisher(like a fallback or a default value).

let failingPublisher = Fail<Int, Error>(error: URLError(.badURL))

let fallbackPublisher = Just(0).setFailureType(to: Error.self)

failingPublisher
    .catch { error in
        print("Caught error: \(error)")
        return fallbackPublisher
    }
    .sink(receiveCompletion: { print("Completed: \($0)") },
          receiveValue: { print("Received value: \($0)") })


print(" ---- catch(_:) Example 2 ---- ")


struct SimpleError: Error { }
let numbers = [5, 4, 3, 2, 1, 0, 9, 8, 7, 6]
var cancellable = Set<AnyCancellable>()

numbers.publisher
    .tryLast {
        guard $0 != 0 else { throw SimpleError() }
        return true
    }
    .catch { error in
        Just(-1)
    }
    .sink(receiveValue: { print("value: \($0)") })
    .store(in: &cancellable)



print(" ---- tryCatch(_:) ---- ")


// Handles errors from an upstream publisher by either replacing it with another publisher or throwing a new error.

var nums = [5, 4, 3, 2, 1, -1, 7, 8, 9, 10]

nums.publisher
    .tryMap { value in
        if value > 0 {
            return value
        } else {
            throw SimpleError()
        }
    }
    .tryCatch { error in
        Just(0) // Send a final value before completing normally.
        // Alternatively, throw a new error to terminate the stream.
    }
    .sink(receiveCompletion: { print("Completion: \($0).") },
          receiveValue: { print("Received: \($0).") })
    .store(in: &cancellable)

// Difference between catch and tryCatch
// You are handling errors from a non-throwing pipeline(Fail, setFailureType).
// You need to catch errors from throwing operators(tryMap, tryFilter).
// tryCatch is only available when there's a throw in the pipeline.
// The handler can also throw. If it does, the pipeline will fail with that new error.


print(" ---- retry(_:) ---- ")

/* retry(_:) */
// If the upstream publisher fails with an error, retry(_:) will re-subscribe to it the specified number of times before passing the error downstream.

struct WebSiteData: Codable {
    var rawHTML: String
}

let myURL = URL(string: "https://www.example.com")

URLSession.shared.dataTaskPublisher(for: myURL!)
    .retry(3)
    .map { page -> WebSiteData in
        return WebSiteData(rawHTML: String(decoding: page.data, as: UTF8.self))
    }
    .catch { error in
        return Just(WebSiteData(rawHTML: "<HTML>Unable to load page - timed out.</HTML>"))
    }
    .sink(receiveCompletion: { print("completion: \($0)") },
          receiveValue: { print("value: \($0)") })
    .store(in: &cancellable)

