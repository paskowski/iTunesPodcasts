import RxSwift
@testable import iTunesPodcasts

class MockNetworkSession: NetworkSession {
    var response: (() -> Observable<Data>)

    init(response: @escaping (() -> Observable<Data>)) {
        self.response = response
    }

    func data(request: URLRequest) -> Observable<Data> {
        response()
    }
}
