
import Foundation
import Combine

// Changes the failure type declared by the upstream publisher.

let publisher1 = [0, 1, 2, 3, 4, 5].publisher
let publisher2 = CurrentValueSubject<Int, Error>(0)

var cancellable = Set<AnyCancellable>()

publisher1
//    .delay(for: 0.1, scheduler: DispatchQueue.main)
    .setFailureType(to: Error.self)
    .combineLatest(publisher2)
    .sink(receiveCompletion: { print("completed: \($0)") },
          receiveValue: { print("value: \($0)") } )
    .store(in: &cancellable)
