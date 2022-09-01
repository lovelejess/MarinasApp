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
    
    lazy var detailsView: PointDetailsView = {
        let detailsView = PointDetailsView()
        detailsView.backgroundColor = UIColor.white
        detailsView.translatesAutoresizingMaskIntoConstraints = false
        return detailsView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.getName()
        detailsView.viewModel = viewModel
        view.addSubview(detailsView)
        setLayoutForOfferDetailView()
    }

    private func setLayoutForOfferDetailView() {
        detailsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        detailsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        detailsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        detailsView.heightAnchor.constraint(equalToConstant: 424).isActive = true
    }
}
