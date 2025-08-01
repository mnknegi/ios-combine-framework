
import Foundation
import Combine

/* switchToLatest */
// cancel previous publishers and only listen to the most recent one.
// When a new inner publisher is emitted, it cancels the subscription to the previous one and subscribe to the new one.
// Only the latest inner publisher's values are emitted downstream.

print("Cancel previous network calls on new search input")

class SearchViewModel: ObservableObject {
    @Published var query = ""
    @Published var results: [String] = []

    private var cancellable = Set<AnyCancellable>()

    init() {
        $query
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .map { query in
                self.performSearch(for: query)
            }
            .switchToLatest()
            .sink { [weak self] newResults in
                self?.results = newResults
            }
            .store(in: &cancellable)
    }

    func performSearch(for query: String) -> AnyPublisher<[String], Never> {
        let all = ["apple", "banana", "orange", "grape", "peach"]
        let filtered = all.filter { $0.contains(query.lowercased()) }

        return Just(filtered)
            .delay(for: .seconds(0.5), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

print(" ---- ")

let subject = PassthroughSubject<Int, Never>()

var cancellable = Set<AnyCancellable>()

subject
    .setFailureType(to: URLError.self)
    .map { index -> URLSession.DataTaskPublisher in
        let url = URL(string: "https://example.org/get?index=\(index)")!
        return URLSession.shared.dataTaskPublisher(for: url)
    }
    .switchToLatest()
    .sink(receiveCompletion: { print("Complete: \($0)") }) { (data, response) in
        guard let url = response.url else { print("Bad response."); return }
        print("URL: \(url)")
    }
    .store(in: &cancellable)

for index in 1...5 {
    DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(index / 10)) {
        subject.send(index)
    }
}
