import RxSwift
@testable import iTunesPodcasts

class MockPodcastsLoader: PodcastsLoader {

    var podcasts = [Podcast]()
    var queries = [String]()

    func loadPodcasts(for query: String) -> Observable<[Podcast]> {
        queries.append(query)
        return .just(podcasts)
    }
}
