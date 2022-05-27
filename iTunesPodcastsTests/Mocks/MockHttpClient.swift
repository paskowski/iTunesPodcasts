import RxSwift
@testable import iTunesPodcasts

class MockHttpClient: HTTPClient {
    var mockData: () -> Observable<Data>

    init(mockData: @escaping () -> Observable<Data>) {
        self.mockData = mockData
    }

    func get(from url: URL) -> Observable<Data> {
        mockData()
    }
}
