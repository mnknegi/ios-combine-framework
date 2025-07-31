
import Foundation
import Combine

/* FlatMap(maxPublishers:_:) */
// Transforms all elements from an upstream publisher into a new publisher up to a maximum number of publishers you specify.
// OuterPublisher emits values.
// For each emitted value, it starts a new inner publisher.
// All values from all active inner publishers are merged into a single stream.
// maxPublisher limits how many inner publishers are allowed to be active at the same time.

let numbers = [1, 2, 3].publisher

var cancellable = Set<AnyCancellable>()

numbers
    .flatMap { number in
        Just(number * 10)
    }
    .sink(receiveValue: { print("received: \($0)") })
    .store(in: &cancellable)

print(" ---- ")


struct WeatherStation {
    let stationID: String
}

var weatherPublisher = PassthroughSubject<WeatherStation, URLError>()

weatherPublisher.flatMap { station -> URLSession.DataTaskPublisher in
    let url = URL(string: "https://weatherapi.example.com/stations/\(station.stationID)/observations/latest")!
    return URLSession.shared.dataTaskPublisher(for: url)
}
.sink { completion in
    // Handle publisher completion (normal or error).
} receiveValue: { publisher in
    // Process the received data.
}
.store(in: &cancellable)

weatherPublisher.send(WeatherStation(stationID: "KSFO"))
weatherPublisher.send(WeatherStation(stationID: "EGLC"))
weatherPublisher.send(WeatherStation(stationID: "ZBBB"))

print(" ---- ")

struct User: Decodable {
    let id: Int
    let name: String
}

func fetchUser(id: Int) -> AnyPublisher<User, Error> {
    let url = URL(string: "https://jsonplaceholder.typicode.com/users/\(id)")!
    return URLSession.shared.dataTaskPublisher(for: url)
        .map(\.data)
        .decode(type: User.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
}

let userIDs = [1, 2, 3].publisher

userIDs
    .flatMap(maxPublishers: .max(2)) { id in
        fetchUser(id: id)
    }
    .sink { completion in
        print("completed with: ", completion)
    } receiveValue: { user in
        print("Fetched user: ", user.name)
    }

// This starts up to 2 concurrent fetches at a time.

print(" ---- ")

class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var results: [String] = []

    private var cancellable = Set<AnyCancellable>()

    init() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { query in
                self.search(query: query)
            }
            .receive(on: RunLoop.main)
            .sink { [weak self] newResults in
                self?.results = newResults
            }
            .store(in: &cancellable)
    }

    func search(query: String) -> AnyPublisher<[String], Never> {
        let allItems = ["Apple", "Banana", "Grapes", "Orange", "Peach"]
        let filtered = allItems.filter { $0.localizedCaseInsensitiveContains(query) }
        return Just(filtered)
            .delay(for: .milliseconds(200), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

// flatMap turns each search query into a new search publisher.
// The latest search cancels earlier ones if they haven't finished yet.
// Combine handles all this declaratively.
