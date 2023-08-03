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
    
    weak var coordinatorDelegate: MarinasCoordinatorDelegate?
    var point = PassthroughSubject<Point, Error>()
    var searchText = PassthroughSubject<String, Never>()

    init(marinasFetcher: MarinasFetcherable) {
        self.marinasFetcher = marinasFetcher
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
    func didSelectPoint(for id: String = "95cz") {
        marinasFetcher.point(for: id)
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { [weak self] value in
            guard let self = self else { return }
            switch value {
            case .failure:
                // TODO: More Granular Error Handling
                self.point.send(completion: .failure(NetworkError.parsing(description: "FIX ME")))
            case .finished:
                return
            }
        }, receiveValue: { [weak self] point in
            guard let self = self else { return }
            var url: URL? = nil
            if let urlString = point.url {
                url = URL(string: urlString)
            }
            let pointDetails = PointDetails(name: point.name, image: point.images.data.first?.smallUrl, kind: point.kind, url: url)
            self.coordinatorDelegate?.navigate(to: .rootTabBar(.searchMarinas(.point(point: pointDetails))))
        })
        .store(in: &subscribers)
    }

    private func subscribeToSearchText() {
        searchText
        // the execution of closures scheduled on the main run loop will be delayed for execution whenever user interaction occurs.
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
