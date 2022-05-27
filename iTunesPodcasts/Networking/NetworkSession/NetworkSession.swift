import RxSwift
import RxCocoa

protocol NetworkSession {
    func data(request: URLRequest) -> Observable<Data>
}
