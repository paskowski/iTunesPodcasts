import XCTest
import RxSwift
import RxTest
@testable import iTunesPodcasts

class URLSessionHTTPClientTests: XCTestCase {

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

    func testClient_returnsData() {
        let networkSession = MockNetworkSession(response: { .just("test".data(using: .utf8)!) })
        let urlSessionHTTPClient = URLSessionHTTPClient(networkSession: networkSession)
        let getObserver = scheduler.createObserver(Data.self)

        urlSessionHTTPClient
            .get(from: .mock)
            .subscribe(getObserver)
            .disposed(by: disposeBag)

        XCTAssertEqualStreams(["test".data(using: .utf8)!], getObserver)
    }
}
