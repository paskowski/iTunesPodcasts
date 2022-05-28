import Foundation

class PodcastDetailsViewModel {
    let artistName: String
    let trackName: String
    let artworkUrl: URL
    let releaseDate: String
    let imageDownloader: ImageDownloader

    init(artistName: String, trackName: String, artworkUrl: URL, releaseDate: String, imageDownloader: ImageDownloader) {
        self.artistName = artistName
        self.trackName = trackName
        self.artworkUrl = artworkUrl
        self.releaseDate = releaseDate
        self.imageDownloader = imageDownloader
    }
}
