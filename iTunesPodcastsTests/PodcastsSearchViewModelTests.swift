import XCTest
import RxSwift
import RxTest
@testable import iTunesPodcasts

class PodcastsSearchViewModelTests: XCTestCase {

    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUp() {
        scheduler = TestScheduler(initialClock: 0, resolution: 1 / 1000)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        scheduler = nil
        disposeBag = nil
    }

    func testViewModelFetches_singlePodcast_onSearchTextChange_skippingFirstValue() {
        let podcastsLoader = MockPodcastsLoader()
        podcastsLoader.podcasts = [.mock]
        let viewModel = PodcastsSearchViewModel(
            podcastsLoader: podcastsLoader,
            imageDownloader: MockImageDownloader()
        )
        let cellsViewModelsObserver = scheduler.createObserver([PodcastCellViewModel].self)

        viewModel.podcastsCellsViewModels
            .subscribe(cellsViewModelsObserver)
            .disposed(by: disposeBag)

        viewModel.searchTextDidChangeRelay.accept("skipped")
        viewModel.searchTextDidChangeRelay.accept("searched")

        XCTAssertEqual(["searched"], podcastsLoader.queries)
        XCTAssertStreamValuesCount(1, cellsViewModelsObserver)
    }

    func testViewModel_shouldIngoreSearchQueries_doneMoreOftenThan250ms() {
        let podcastsLoader = MockPodcastsLoader()
        podcastsLoader.podcasts = [.mock]
        let viewModel = PodcastsSearchViewModel(
            podcastsLoader: podcastsLoader,
            imageDownloader: MockImageDownloader(),
            scheduler: scheduler
        )
        let cellsViewModelsObserver = scheduler.createObserver([PodcastCellViewModel].self)

        viewModel.podcastsCellsViewModels
            .subscribe(cellsViewModelsObserver)
            .disposed(by: disposeBag)

        viewModel.searchTextDidChangeRelay.accept("skipped")
        viewModel.searchTextDidChangeRelay.accept("searched")
        scheduler.advance(by: 0.2)
        viewModel.searchTextDidChangeRelay.accept("throttled")
        viewModel.searchTextDidChangeRelay.accept("searched2")
        scheduler.advance(by: 0.05)
        scheduler.advance(by: 0.3)
        viewModel.searchTextDidChangeRelay.accept("searched3")


        XCTAssertEqual(["searched", "searched2", "searched3"], podcastsLoader.queries)
        XCTAssertStreamValuesCount(3, cellsViewModelsObserver)
    }

    func testViewModel_ignoresNonDistinctSearches() {
        let podcastsLoader = MockPodcastsLoader()
        podcastsLoader.podcasts = [.mock]
        let viewModel = PodcastsSearchViewModel(
            podcastsLoader: podcastsLoader,
            imageDownloader: MockImageDownloader(),
            scheduler: scheduler
        )
        let cellsViewModelsObserver = scheduler.createObserver([PodcastCellViewModel].self)

        viewModel.podcastsCellsViewModels
            .subscribe(cellsViewModelsObserver)
            .disposed(by: disposeBag)

        viewModel.searchTextDidChangeRelay.accept("skipped")
        viewModel.searchTextDidChangeRelay.accept("test")
        scheduler.advance(by: 1)
        viewModel.searchTextDidChangeRelay.accept("test")
        scheduler.advance(by: 1)
        viewModel.searchTextDidChangeRelay.accept("test")
        scheduler.advance(by: 1)
        viewModel.searchTextDidChangeRelay.accept("not ignored")

        XCTAssertEqual(["test", "not ignored"], podcastsLoader.queries)
        XCTAssertStreamValuesCount(2, cellsViewModelsObserver)
    }

    func testViewModel_firesNavigateToDetailScreen_onTappedCellIndexRelay() {
        let podcastsLoader = MockPodcastsLoader()
        podcastsLoader.podcasts = [.mock]
        let viewModel = PodcastsSearchViewModel(
            podcastsLoader: podcastsLoader,
            imageDownloader: MockImageDownloader()
        )
        let navigateToDetailsObserver = scheduler.createObserver(PodcastDetailsViewModel.self)

        viewModel.navigateToDetailsScreen
            .subscribe(navigateToDetailsObserver)
            .disposed(by: disposeBag)

        viewModel.searchTextDidChangeRelay.accept("skipped")
        viewModel.searchTextDidChangeRelay.accept("test")

        viewModel.tappedCellIndexRelay.accept(0)
        XCTAssertStreamValuesCount(1, navigateToDetailsObserver)
    }
}
