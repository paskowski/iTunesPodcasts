import RxSwift

class PodcastsSearchViewModel {

    private let podcastsLoader: PodcastsLoader

    init(podcastsLoader: PodcastsLoader) {
        self.podcastsLoader = podcastsLoader
    }

    let searchTextDidChangeRelay = PublishSubject<String>()

    var foundPodcasts: Observable<[PodcastCellViewModel]> {
        searchTextDidChangeRelay
            .skip(1)
            .throttle(.milliseconds(250), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMap {
                self.podcastsLoader.loadPodcasts(for: $0)
            }
            .map { podcasts in
                podcasts.map {
                    PodcastCellViewModel(
                        artistName: $0.artistName,
                        trackName: $0.trackName,
                        imageUrl: $0.artworkUrl
                    )
                }
            }
    }
}
