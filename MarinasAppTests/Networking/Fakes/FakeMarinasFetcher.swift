//
//  FakeMarinasFetcher.swift
//  MarinasAppTests
//
//  Created by Jess Lê on 8/27/22.
//

import Foundation
import Combine
@testable import MarinasApp


class FakeMarinasFetcher: MarinasFetcherable {
    private let images = PointImages(data: [PointImage(resource: "Resource", thumbnailUrl: "Thumnail URL", smallUrl: "Small URL")])
    private let networkService: Networkable!

    static var pointsPublisher: AnyPublisher<Point, Error> {
        return Empty(completeImmediately: false).eraseToAnyPublisher()
    }

    init(networkService: Networkable) {
        self.networkService = networkService
    }

    /// Returns a static fake publisher immediately of either type `Point` or `Error`
    ///
    /// - Returns: A publisher of type `<Point, Error>` used to return `Point`
    func point(for id: String) -> AnyPublisher<Point, Error> {
        let point = Point(id: "1234", name: "Fake Harbor", kind: .harbor, iconURL: "https://fakeurl.com", images: images, url: "https://weburl.com")
        return Just(point)
            .setFailureType(to: Error.self)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    /// Returns a static fake publisher immediately of either type `PointSearchResults` or `Error`
    ///
    /// - Returns: A publisher of type `<PointSearchResults, Error>` used to return `PointSearchResults`
    func search(for query: String) -> AnyPublisher<PointSearchResults, Error> {
        let point = Point(id: "1234", name: "Fake Harbor", kind: .harbor, iconURL: "https://fakeurl.com", images: images, url: "https://weburl.com")
        let pointSearchResults = PointSearchResults(data: [point])
        return Just(pointSearchResults)
            .setFailureType(to: Error.self)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
