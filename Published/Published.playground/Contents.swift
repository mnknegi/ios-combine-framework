
import Foundation
import Combine

// Property wrapper that automatically creates a publisher for a property so that other part of the code can observe its changes.

/*
 ```
 struct Published<Value> {
    var wrappedValue: Value
    var projectedValue: Published<Value>.Publisher { get }

 wrapperValue -> The stored property value(name).
 projectedValue -> A combine publisher ($name) that emits whenever wrappedValue changes.
 }
 ```
 */

class User: ObservableObject {
    @Published var name = "Mayank"
}

let user = User()

let cancellable = user.$name
    .sink(receiveValue: { print("Name changed to: \($0)") })

user.name = "Ved"
user.name = "Vaasu"
