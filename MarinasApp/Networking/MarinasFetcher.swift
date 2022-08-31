//
//  MarinasFetcher.swift
//  MarinasApp
//
//  Created by Jess Lê on 8/27/22.
//

import Foundation
import Combine

protocol MarinasFetcherable: AnyObject {
    /// Returns a publisher for `Points`
    ///
    /// - Returns: A publisher of type `<PointSearchResults, Error>` used to return `PointSearchResults`
    func search(for query: String) -> AnyPublisher<PointSearchResults, Error>

    /// Returns a publisher for `Points`
    ///
    /// - Returns: A publisher of type `<Point, Error>` used to return `Point`
    func point(for id: String) -> AnyPublisher<Point, Error>
}

class MarinasFetcher: MarinasFetcherable {
    private let networkService: Networkable!

    init(networkService: Networkable) {
        self.networkService = networkService
    }

    func search(for query: String) -> AnyPublisher<PointSearchResults, Error> {
        // TODO: User actual query - right now it returns ALL search results
        let urlRequest = URLRequest(url: MarinasFetcher.Endpoints.search.url)
        return networkService.decodableDataTaskPublisher(with: urlRequest)
    }

    func point(for id: String) -> AnyPublisher<Point, Error> {
        let urlRequest = URLRequest(url: MarinasFetcher.Endpoints.points(id: id).url)
        return networkService.decodableDataTaskPublisher(with: urlRequest)
    }
}

extension MarinasFetcher {
    enum Endpoints {
        static let scheme = "https"
        private static var host: String = "api.marinas.com"
        private static var accessToken: String = "cPEQZFRWsBNZBV3YNi1T"
        private static var clientIdQuery = URLQueryItem(name: "access_token", value: accessToken)

        case points(id: String)
        case search

        private var path: String {
            switch self {
            case .points(let id): return "/v1/points/\(id)"
            case .search: return "/v1/points/search"
            }
        }

        var url: URL {
            var urlComponents: URLComponents
            switch self {
            case .points:
                urlComponents = URLComponents()
                urlComponents.host = Endpoints.host
                urlComponents.path = path
                urlComponents.queryItems = [ Endpoints.clientIdQuery ]
            case .search:
                urlComponents = URLComponents()
                urlComponents.host = Endpoints.host
                urlComponents.path = path
                urlComponents.queryItems = [ Endpoints.clientIdQuery ]
            }
            urlComponents.scheme = Endpoints.scheme
            return urlComponents.url!
        }
    }
}
