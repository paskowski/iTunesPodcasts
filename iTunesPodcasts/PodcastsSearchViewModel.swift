import RxSwift
import RxRelay

class PodcastsSearchViewModel {

    private let podcastsLoader: PodcastsLoader
    private let imageDownloader: ImageDownloader

    init(podcastsLoader: PodcastsLoader, imageDownloader: ImageDownloader) {
        self.podcastsLoader = podcastsLoader
        self.imageDownloader = imageDownloader
    }

    let searchTextDidChangeRelay = PublishSubject<String>()

    private var foundPodcasts: Observable<[Podcast]> {
        searchTextDidChangeRelay
            .skip(1)
            .throttle(.milliseconds(250), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMap {
                self.podcastsLoader.loadPodcasts(for: $0)
            }
            .share()
    }

    var podcastsCellsViewModels: Observable<[PodcastCellViewModel]> {
        foundPodcasts
            .map { [imageDownloader] podcasts in
                podcasts.map {
                    PodcastCellViewModel(
                        artistName: $0.artistName,
                        trackName: $0.trackName,
                        artworkUrl: $0.artworkUrlThumbnail,
                        imageDownloader: imageDownloader
                    )
                }
            }
    }
}
