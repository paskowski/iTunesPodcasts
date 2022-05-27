import Foundation

struct PodcastsMapper {

    private struct Root: Decodable {
        let results: [Item]
    }

    private struct Item: Decodable {
        let artistName: String
        let trackName: String
        let artworkUrl: URL

        enum CodingKeys: String, CodingKey {
            case artistName
            case trackName
            case artworkUrl = "artworkUrl100"
        }
    }

    static func map(data: Data) throws -> [Podcast] {
        let root = try JSONDecoder().decode(Root.self, from: data)
        return root.results.map {
            Podcast(
                artistName: $0.artistName,
                trackName: $0.trackName,
                artworkUrl: $0.artworkUrl
            )
        }
    }
}
