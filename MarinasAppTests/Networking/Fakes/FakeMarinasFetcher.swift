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

        let point = Point(id: "95cz", name: "Baltimore Yacht Basin", kind: .marina)
        return Just(point)
            .setFailureType(to: Error.self)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
