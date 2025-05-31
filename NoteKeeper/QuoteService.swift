import Foundation

struct QuoteResponse: Codable {
    let content: String
    let author: String
}

class QuoteService {
    static func fetchQuote() async throws -> String {
        guard let url = URL(string: "https://api.quotable.io/random") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(QuoteResponse.self, from: data)
        return "\"\(decoded.content)\" — \(decoded.author)"
    }
}
