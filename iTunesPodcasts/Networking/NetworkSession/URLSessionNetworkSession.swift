import RxSwift

class URLSessionNetworkSession: NetworkSession {
    private let requestHandler: (URLRequest) -> Observable<Data>

    init(requestHandler: @escaping (URLRequest) -> Observable<Data>) {
        self.requestHandler = requestHandler
    }

    func data(request: URLRequest) -> Observable<Data> {
        requestHandler(request)
    }
}
