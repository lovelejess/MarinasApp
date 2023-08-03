//
//  MarinasCoordinatorDelegate.swift
//  MarinasApp
//
//  Created by Jess Lê on 8/3/23.
//

import Foundation

protocol MarinasCoordinatorDelegate: AnyObject {
    func navigate(to route: Route)
}
