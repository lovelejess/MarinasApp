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
        case marinas (HomeRoute)
    }

    enum HomeRoute: Equatable {
        case home
    }
}
