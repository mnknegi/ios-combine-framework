
import Foundation
import Combine

let subscription = Timer.publish(every: 1.0, on: RunLoop.main, in: .default) // Return the publisher that repeatedly emits the current date on the given interval.
    .autoconnect() // Starts the timer when timer object is created.
    .print("Data stream")
    .sink { output in
        print("finished stream with \(output)") // Called when the subscription is finished.
    } receiveValue: { value in
        print("received value: \(value)") // Called when the value is published.
    }

RunLoop.main.schedule(after: .init(Date(timeIntervalSinceNow: 5))) {
    print(" - cancel subscription")
    subscription.cancel() // Cancel the timer to stop emitting the value.
}
