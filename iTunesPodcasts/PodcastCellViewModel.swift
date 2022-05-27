import Foundation

class PodcastCellViewModel {
    let artistName: String
    let trackName: String
    let artworkUrl: URL
    let imageDownloader: ImageDownloader

    init(artistName: String, trackName: String, imageUrl: URL, imageDownloader: ImageDownloader) {
        self.artistName = artistName
        self.trackName = trackName
        self.artworkUrl = imageUrl
        self.imageDownloader = imageDownloader
    }
}
