
import Foundation
import Combine

/* assign(to:on:) */

// Assign each element from a publisher to a property on an object.
// The keyPath should be `ReferenceWritableKeyPath` which means the object should be the type of reference.

class MyClass {
    var myProperty: Int = 0 {
        didSet {
            print("myProperty was set to: \(myProperty)")
        }
    }
}

var myObject = MyClass()
let myRange = (0...2)

myRange.publisher
    .assign(to: \.myProperty, on: myObject)


print(" ---- assign(to:) ---- ")

// Republishes elements received from a publisher, by assigning them to the property marked as a publisher.

class MyModel: ObservableObject {
    @Published var lastUpdated: Date = Date()

    init() {
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .assign(to: &$lastUpdated)
    }
}

// If you instead implemented MyModel with assign(to: lastUpdated, on: self), storing the returned AnyCancellable instance could cause a reference cycle, because the Subscribers.Assign subscriber would hold a strong reference to self. Using assign(to:) solves this problem.

class Model2: ObservableObject {
    @Published var id: Int = 0
}

let model2 = Model2()
Just(100)
    .assign(to: &model2.$id)
