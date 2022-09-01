//
//  PointDetailsViewController.swift
//  MarinasApp
//
//  Created by Jess Lê on 8/31/22.
//

import Combine
import UIKit

class PointDetailsViewController: UIViewController {
    
    private var subscribers = [AnyCancellable]()
    var coordinator: MarinasCoordinator?
    var viewModel: PointDetailsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.getName()
    }
}
