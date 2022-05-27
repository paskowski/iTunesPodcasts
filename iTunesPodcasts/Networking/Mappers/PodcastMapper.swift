import Foundation

struct PodcastsMapper {

    private struct Root: Decodable {
        let results: [Item]
    }

    private struct Item: Decodable {
        let artistName: String
        let trackName: String
        let artworkUrl: URL
        let releaseDate: Date

        enum CodingKeys: String, CodingKey {
            case artistName
            case trackName
            case artworkUrl = "artworkUrl100"
            case releaseDate
        }
    }

    static func map(data: Data) throws -> [Podcast] {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        let root = try jsonDecoder.decode(Root.self, from: data)
        return root.results.map {
            Podcast(
                artistName: $0.artistName,
                trackName: $0.trackName,
                artworkUrl: $0.artworkUrl,
                releaseDate: $0.releaseDate
            )
        }
    }
}
