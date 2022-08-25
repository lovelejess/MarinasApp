//
//  Coordinatable.swift
//  MarinasApp
//
//  Created by Jess Lê on 8/24/22.
//

import Foundation
import UIKit

protocol Coordinatable: AnyObject {
    var parentCoordinator: Coordinatable? { get }
    var childCoordinators: [Coordinatable] { get }
    var rootViewController: UIViewController { get }

    func navigate(to route: Route)
}
