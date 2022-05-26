import Foundation

struct Endpoint {
    var path: String
    var queryItems: [URLQueryItem] = []
}

extension Endpoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "itunes.apple.com"
        components.path = path
        components.queryItems = queryItems

        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }

        return url
    }
}

extension Endpoint {
    static func search(query: String) -> Endpoint {
        Endpoint(
            path: "/search",
            queryItems: [
                URLQueryItem(name: "term", value: query),
                URLQueryItem(name: "entity", value: "podcast")
            ]
        )
    }
}
