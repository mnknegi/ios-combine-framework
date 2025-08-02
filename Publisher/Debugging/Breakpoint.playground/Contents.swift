
import Foundation
import Combine

/* Breakpoint Publisher: `Do not work as expexted in Swift Playground.` */

// It is a debugging tool. It let us insert breakpoint into a combine pipeline so you can pause execution in Xcode when certain events happen.
// It can trigger a debugger stop if: a value is received, a completion is received and a failure occured.

let numbers = [1, 2, 3, 4, 5]

var cancellable = Set<AnyCancellable>()

numbers
    .publisher
    .breakpoint(receiveOutput: { $0 == 3 })
    .sink(receiveValue: { print("value received: \($0)")})
    .store(in: &cancellable)


/* .breakpointOnError */

// Which breaks only when the publisher fails.
