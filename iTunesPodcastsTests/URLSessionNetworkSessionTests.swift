import XCTest
import RxSwift
import RxTest
@testable import iTunesPodcasts

class URLSessionNetworkSessionTests: XCTestCase {

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

    func testDataRequest_returnsData() {
        let urlSessionNetworkSession = URLSessionNetworkSession(requestHandler: { request in
            XCTAssertEqual(.mock, request.url)
            return .just("test".data(using: .utf8)!)
        })

        let dataRequestObserver = scheduler.createObserver(Data.self)

        let testRequest = URLRequest(url: .mock)
        urlSessionNetworkSession
            .data(request: testRequest)
            .subscribe(dataRequestObserver)
            .disposed(by: disposeBag)

        XCTAssertEqualStreams(["test".data(using: .utf8)!], dataRequestObserver)
    }

    func testDataRequest_createsRequestWithCorrectURL() {
        let expectation = expectation(description: "Request handler was called")
        let urlSessionNetworkSession = URLSessionNetworkSession(requestHandler: { request in
            XCTAssertEqual(.mock, request.url)
            expectation.fulfill()
            return .never()
        })

        let dataRequestObserver = scheduler.createObserver(Data.self)

        let testRequest = URLRequest(url: .mock)
        urlSessionNetworkSession
            .data(request: testRequest)
            .subscribe(dataRequestObserver)
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)
    }
}
