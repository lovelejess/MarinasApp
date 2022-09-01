//
//  PointDetailsViewModel.swift
//  MarinasApp
//
//  Created by Jess Lê on 8/31/22.
//

import Foundation

class PointDetailsViewModel {

    private var marinasFetcher: MarinasFetcherable!
    var point: Point

    init(marinasFetcher: MarinasFetcherable, point: Point) {
        self.marinasFetcher = marinasFetcher
        self.point = point
    }

    func getName() -> String {
        return point.name ?? ""
    }

}
