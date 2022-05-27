import XCTest
import RxSwift
import RxTest
@testable import iTunesPodcasts

class PodcastsLoaderTests: XCTestCase {

    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUp() {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        scheduler = nil
        disposeBag = nil
    }

    func testPodcastLoader_returnsEmptyArray_onLoadingEmptyPodcastData() {
        let podcastsLoader = PodcastsLoader(
            httpClient: MockHttpClient(
                mockData: { .just(self.createEmptyPodcastData()) }
            )
        )
        let podcastsObserver = scheduler.createObserver([Podcast].self)

        podcastsLoader
            .loadPodcasts(for: "test")
            .subscribe(podcastsObserver)
            .disposed(by: disposeBag)

        XCTAssertEqualStreams([[]], podcastsObserver)
    }

    func testPodcastLoader_returnsArrayWithPodcast_onLoadingCorrectNonEmptyPodcastData() {
        let podcastsLoader = PodcastsLoader(
            httpClient: MockHttpClient(
                mockData: { .just(self.createPodcastData()) }
            )
        )
        let podcastsObserver = scheduler.createObserver([Podcast].self)

        podcastsLoader
            .loadPodcasts(for: "test")
            .subscribe(podcastsObserver)
            .disposed(by: disposeBag)

        let expectedPodcast = Podcast(
            artistName: "John Appleseed",
            trackName: "Great track",
            artworkUrl: URL(string: "https://fake.com")!,
            releaseDate: Date(timeIntervalSince1970: 1639742400)
        )

        XCTAssertEqualStreams([[expectedPodcast]], podcastsObserver)
    }

    // MARK: Helpers

    private func createEmptyPodcastData() -> Data {
    """
    {
        "results": []
    }
    """.data(using: .utf8)!
    }

    private func createPodcastData() -> Data {
    """
    {
        "results": [
            {
                "artistName": "John Appleseed",
                "trackName": "Great track",
                "artworkUrl100": "https://fake.com",
                "releaseDate": "2021-12-17T12:00:00Z"
            }
        ]
    }
    """.data(using: .utf8)!
    }
}
