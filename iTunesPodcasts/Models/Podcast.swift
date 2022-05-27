import Foundation

struct Podcast: Equatable {
    let artistName: String
    let trackName: String
    let artworkUrlThumbnail: URL
    let artworkUrlDetail: URL
    let releaseDate: Date
}
