//
//  PointDetailsViewModel.swift
//  MarinasApp
//
//  Created by Jess Lê on 8/31/22.
//

import Foundation

class PointDetailsViewModel {

    private var marinasFetcher: MarinasFetcherable!
    private var point: PointDetails
    weak var coordinatorDelegate: PointDetailsCoordinatorDelegate?

    init(marinasFetcher: MarinasFetcherable, point: PointDetails) {
        self.marinasFetcher = marinasFetcher
        self.point = point
    }

    func getName() -> String {
        return point.name
    }

    func getImageName() -> String? {
        return point.image
    }
    
    func getKind() -> Kind? {
        return point.kind
    }

    func getURL() -> URL? {
        return point.url
    }

    // TODO: JESS this should use coordinator delegate
    func redirectToWeb() {
//        guard let url = point.url else { return }
//        coordinator?.navigate(to: .rootTabBar(.searchMarinas(.pointURL(via: url))))
    }

}
