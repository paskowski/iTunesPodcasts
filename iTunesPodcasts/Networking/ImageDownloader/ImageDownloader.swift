import UIKit
import RxSwift

protocol ImageDownloader {
    func getImage(url: URL) -> Observable<UIImage>
}
