import RxSwift
import SDWebImage

class SDImageDownloader: ImageDownloader {

    let manager = SDWebImageManager()

    func getImage(url: URL) -> Observable<UIImage> {
        Observable.create { [manager] observer in
            let operation = manager.loadImage(
                with: url,
                progress: nil,
                completed: { image, data, error, _, _, _ in
                    if let error = error {
                        observer.onError(error)
                    }

                    if let image = image {
                        observer.onNext(image)
                    }
                }
            )

            return Disposables.create {
                operation?.cancel()
            }
        }
    }
}
