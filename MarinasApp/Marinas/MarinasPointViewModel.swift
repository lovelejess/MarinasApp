//
//  MarinasPointViewModel.swift
//  MarinasApp
//
//  Created by Jess Lê on 8/28/22.
//

import Foundation
import Combine

class MarinasPointViewModel {
    
    private var marinasFetcher: MarinasFetcherable!
    private var subscribers = [AnyCancellable]()

    @Published
    var points: [Point] = []

    init(marinasFetcher: MarinasFetcherable) {
        self.marinasFetcher = marinasFetcher
        getPointInfo()
    }

    /// Retrieves points from the Marinas API.
    /// Once values are retrieved, it publishes the values via `photoDescription`
    ///
    /// - Returns: A publisher of type `<Point, NetworkError>` used to return `Point`
    func getPointInfo(for id: String = "95cz") {
        marinasFetcher.point(for: id)
            .sink(receiveCompletion: { [weak self] value in
                guard let self = self else { return }
                switch value {
                case .failure:
                    // TODO: More Granular Error Handling
                    self.points = []
                case .finished:
                    return
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }

                // TODO: Currently only one Point
                self.points = [response]

            })
            .store(in: &subscribers)
    }
}
