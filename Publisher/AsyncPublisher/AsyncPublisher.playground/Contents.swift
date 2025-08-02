
import Foundation
import Combine

// The elements produced by the publisher, as an asynchoronous sequence.

let numbers = [1, 2, 3, 4, 0, 5]
let filtered = numbers.publisher
    .filter { $0 % 2 == 0 }

for await number in filtered.values {
    print(number)
}


/* AsyncThrowingPublisher */

struct ZeroError: Error {}


let filterPublisher = numbers.publisher
    .tryFilter{
        if $0 == 0 {
            throw ZeroError()
        } else {
            return $0 % 2 == 0
        }
    }


do {
    for try await number in filterPublisher.values {
        print ("\(number)", terminator: " ")
    }
} catch {
    print ("\(error)")
}
