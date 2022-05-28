import Foundation
import RxSwift

protocol PodcastsLoader {
    func loadPodcasts(for query: String) -> Observable<[Podcast]>
}

class RemotePodcastsLoader: PodcastsLoader {
    private let httpClient: HTTPClient

    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }

    func loadPodcasts(for query: String) -> Observable<[Podcast]> {
        httpClient
            .get(from: Endpoint.search(query: query).url)
            .map { try PodcastsMapper.map(data: $0) }
    }
}
