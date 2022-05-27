import Foundation

class PodcastCellViewModel {
    let artistName: String
    let trackName: String
    let artworkUrl: URL

    init(artistName: String, trackName: String, imageUrl: URL) {
        self.artistName = artistName
        self.trackName = trackName
        self.artworkUrl = imageUrl
    }
}
