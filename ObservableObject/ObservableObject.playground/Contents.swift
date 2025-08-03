
import Foundation
import Combine

// ObservableObject is a protocol that is conform by a class when you want a class to publish state changes to its subscribers.
// This protocol can only be adopted by a reference type(class) `protocol ObservableObject: AnyObject`.

// It has a special publisher: `var objectWillChange: ObservableObjectPublisher`
// This publisher send events before the object changes, so the UI can prepare to update.

/*
 - You create a class conforming to ObservableObject.
 - Mark properties that should trigger updates with @Published.
 - Views or other subscribers listen for objectWillChange.
 - When a @Published property changes:
    + Combine automatically calls objectWillChange.send().
    + SwiftUI (or your subscriber) reacts and updates.
 */

// By default an ObservableObject synthesizes an objectWillChange publisher that emits the changed value before any of its @Published properties changes.

class Contact: ObservableObject {
    @Published var name: String
    @Published var age: Int

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }

    func haveBirthday() -> Int {
        age += 1
        return age
    }
}

let john = Contact(name: "John Appleseed", age: 24)
let cancellable = john.objectWillChange
    .sink { _ in
        print("\(john.age) will change")
}

print(john.haveBirthday())
