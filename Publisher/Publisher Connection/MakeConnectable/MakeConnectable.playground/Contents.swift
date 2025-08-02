
import Foundation
import Combine

/* MakeConnectable */

// It is opposite of .autoconnect(). It wraps a normal publisher and turn it into a ConnectablePublisher.
// It delays the emission until .connect() is called on the publisher.
// Gives a manual control over when the upstream starts.

let publiser = Just("Hello")

let connectable = publiser.makeConnectable()

connectable
    .sink(receiveValue: { print("value: \($0)") })

connectable.connect()
