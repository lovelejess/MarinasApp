//
//  PointDetailsView.swift
//  MarinasApp
//
//  Created by Jess Lê on 8/31/22.
//

import Foundation
import SafariServices
import UIKit

class PointDetailsView: UIView {
    let placeHolderImageURL = "https://picsum.photos/id/1084/200"

    var viewModel: PointDetailsViewModel? {
        didSet {
            configureUIDetails()
        }
    }

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 2
        imageView.image = UIImage(named: "notFound")

        return imageView
     }()

    lazy var name: UILabel = {
        let label = UILabel()
        label.text = viewModel?.getName() ?? "N/A"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
     }()
    
    lazy var webButton: UIButton = {
        let button = UIButton()
        button.setTitle("See More Info", for: .normal )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
     }()

    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var detailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 16
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(frame: CGRect){
        super.init(frame: frame)

        addSubview(mainStackView)
        mainStackView.addArrangedSubview(imageView)
        mainStackView.addArrangedSubview(detailStackView)
        detailStackView.addArrangedSubview(name)

        setImageLayoutConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUIDetails() {
        name.text = viewModel?.getName() ?? "N/A"
        let imageName = viewModel?.getImageName()
        imageView.sd_setImage(with: URL(string: imageName ?? placeHolderImageURL), placeholderImage: UIImage(named: placeHolderImageURL)) { [weak self] (image, error, imageCacheType, imageUrl) in
            guard let self = self else { return }
            self.imageView.setNeedsDisplay()
        }
    }

    private func setImageLayoutConstraints() {
        mainStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        mainStackView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
}
