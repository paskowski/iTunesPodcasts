import Foundation
@testable import iTunesPodcasts

extension Podcast {
    static var mock: Podcast = Podcast(
        artistName: "Test Artist",
        trackName: "Test Track",
        artworkUrlThumbnail: .mock,
        artworkUrlDetail: .mock,
        releaseDate: Date(timeIntervalSince1970: 1)
    )
}
