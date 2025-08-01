
import Foundation
import Combine

// Encode the output from upstream using a specified encoder.

struct Article: Codable {
    let title: String
    let author: String
    let pubDate: Date
}

let dataProvider = PassthroughSubject<Article, Never>()
var cancellable = Set<AnyCancellable>()

dataProvider
    .encode(encoder: JSONEncoder())
    .sink(receiveCompletion: { print("Completion: \($0)") }) { data in
        guard let stringRepresentation = String(data: data, encoding: .utf8) else { return }
        print("Data received: \(data) string representation: \(stringRepresentation)")
    }
    .store(in: &cancellable)

dataProvider.send(Article(title: "My First Article", author: "Mayank Negi", pubDate: Date()))


// Decodes the output from the upstream using a specified decoder.

let dataProvider1 = PassthroughSubject<Data, Never>()
dataProvider1
    .decode(type: Article.self, decoder: JSONDecoder())
    .sink(receiveCompletion: { print("Completion: \($0)") }) {
        print("value: \($0)")
    }
    .store(in: &cancellable)

dataProvider1.send(Data("{\"pubDate\":775732570.455472, \"title\":\"My First Article\", \"author\": \"Mayank Negi\"}".utf8))
