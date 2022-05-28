import RxSwift
@testable import iTunesPodcasts

class MockImageDownloader: ImageDownloader {

    var image = UIImage.mock

    func getImage(url: URL) -> Observable<UIImage> {
        .just(image)
    }
}
