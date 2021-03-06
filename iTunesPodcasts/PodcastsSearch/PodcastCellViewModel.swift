import Foundation

class PodcastCellViewModel {
    let artistName: String
    let trackName: String
    let artworkUrl: URL
    let imageDownloader: ImageDownloader

    init(artistName: String, trackName: String, artworkUrl: URL, imageDownloader: ImageDownloader) {
        self.artistName = artistName
        self.trackName = trackName
        self.artworkUrl = artworkUrl
        self.imageDownloader = imageDownloader
    }
}
