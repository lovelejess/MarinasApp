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
    
    var searchText = PassthroughSubject<String, Never>()

    init(marinasFetcher: MarinasFetcherable) {
        self.marinasFetcher = marinasFetcher
        getPointInfo()
        subscribeToSearchText()
    }

    /// Retrieves point info from the Marinas API and creates a list of `Points`
    /// Once values are retrieved, it publishes the values via `points`
    ///
    func getSearch(for query: String = "95cz") {
        marinasFetcher.search(for: query)
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
            self.points = response.data
        })
        .store(in: &subscribers)
    }

    /// Retrieves points from the Marinas API.
    /// Once values are retrieved, it publishes the values via `points`
    ///
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

    private func subscribeToSearchText() {
        searchText
        .debounce(for: .milliseconds(800), scheduler: RunLoop.main)
        .removeDuplicates()
        .compactMap{ $0 }
        .sink { (_) in
            //
        } receiveValue: { [self] (query) in
            getSearch(for: query)
        }.store(in: &subscribers)
    }
}
