
import Foundation

// MARK: - NewsFeedResponse
struct NewsFeedResponse: Codable {
    let status: String?
    let articles: [Article]?
    let totalResults: Int?
}

// MARK: - Article
struct Article: Codable {
    let source: Source?
    let author: String?
    let urlToImage: String?
    let content: String?
    let title: String?
    let publishedAt: String?
    let articleDescription: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case source, author, urlToImage, content, title, publishedAt
        case articleDescription = "description"
        case url
    }
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String?
}
