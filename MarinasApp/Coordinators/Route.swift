//
//  Route.swift
//  MarinasApp
//
//  Created by Jess Lê on 8/24/22.
//

import Foundation

enum Route: Equatable {
    case rootTabBar(TabBarRoute)

    enum TabBarRoute: Equatable {
        case searchMarinas (MarinasSearchRoute)
    }

    enum MarinasSearchRoute: Equatable {
        case main
        case point(point: PointDetails)
    }
}
