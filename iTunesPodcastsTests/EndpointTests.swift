import Foundation
import XCTest
@testable import iTunesPodcasts

class EndpointTests: XCTestCase {

    func testSearchEndpoint_hasHTTPScheme() {
        let endpoint = Endpoint.search(query: "test")

        XCTAssertEqual("https", endpoint.url.scheme)
    }
    
    func testSearchEndpoint_hasCorrectHost() {
        let endpoint = Endpoint.search(query: "test")

        XCTAssertEqual("itunes.apple.com", endpoint.url.host)
    }

    func testSearchEndpoint_hasCorrectPath() {
        let endpoint = Endpoint.search(query: "test")

        XCTAssertEqual("/search", endpoint.url.path)
    }

    func testSearchEndpoint_hasUrlWithQueryParams_term_myheritage_entity_podcast() {
        let endpoint = Endpoint.search(query: "myheritage")

        XCTAssertEqual("term=myheritage&entity=podcast", endpoint.url.query)
    }
}
