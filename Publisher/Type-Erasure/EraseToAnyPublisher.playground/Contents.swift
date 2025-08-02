
import Foundation
import Combine

// Hide the concrete type and expose the generic type only AnyPublisher<Output, failure>.

func makePubliser() -> Publishers.Map<Just<Int>, Int> {
    Just(5).map { $0 * 2 }
}

func makePublisher1() -> AnyPublisher<Int, Never> {
    Just(5).map { $0 * 2 }
        .eraseToAnyPublisher()
}

// Example 2

class TypeWithSubject {
    let publisher: some Publisher = PassthroughSubject<Int, Never>()
}

class TypeWithErasedSubject {
    let publisher: some Publisher = PassthroughSubject<Int, Never>()
        .eraseToAnyPublisher()
}

let nonErased = TypeWithSubject()
if let subject = nonErased.publisher as? PassthroughSubject<Int, Never> {
    print("Successfull cast nonErased.publisher")
}

let erased = TypeWithErasedSubject()
if let subject = erased.publisher as? PassthroughSubject<Int, Never> {
    print("Successfull cast erased.publisher")
}
