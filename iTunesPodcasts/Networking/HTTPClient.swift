import RxSwift

protocol HTTPClient {
    func get(from url: URL) -> Observable<Data>
}
