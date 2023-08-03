//
//  Route.swift
//  MarinasApp
//
//  Created by Jess Lê on 8/24/22.
//

import Foundation

enum Route: Equatable {
    case rootTabBar(TabBarRoute)

    // All the navigational routes for the Tabbar
    enum TabBarRoute: Equatable {
        case searchMarinas (MarinasSearchRoute)
    }

    // All the navigational routes for the Marinas Search View
    enum MarinasSearchRoute: Equatable {
        case details(point: PointDetails)
    }

    // All the navigational routes for the PointDetails
    enum PointDetailsRoute: Equatable {
        case webView(via: URL)
    }
}
