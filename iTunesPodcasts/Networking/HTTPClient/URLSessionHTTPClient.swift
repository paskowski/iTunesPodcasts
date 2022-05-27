import RxSwift

final class URLSessionHTTPClient: HTTPClient {
    private let networkSession: NetworkSession

    init(networkSession: NetworkSession) {
        self.networkSession = networkSession
    }

    func get(from url: URL) -> Observable<Data> {
        let request = URLRequest(url: url)
        return networkSession.data(request: request)
    }
}
