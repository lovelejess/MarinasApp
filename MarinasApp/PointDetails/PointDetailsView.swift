//
//  PointDetailsView.swift
//  MarinasApp
//
//  Created by Jess Lê on 8/31/22.
//

import Foundation
import UIKit

class PointDetailsView: UIView {
    
    var viewModel: PointDetailsViewModel?

    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
     }()

    override init(frame: CGRect){
        super.init(frame: frame)

        self.layer.cornerRadius = 5
        
        let placeHolderImageURL = "https://picsum.photos/id/1084/200"
        imageView.sd_setImage(with: URL(string: viewModel?.getImageName() ?? placeHolderImageURL), placeholderImage: UIImage(named: placeHolderImageURL)) { [weak self] (image, error, imageCacheType, imageUrl) in
            guard let self = self else { return }
            self.imageView.setNeedsDisplay()
        }

        self.addSubview(imageView)

        setImageLayoutConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setImageLayoutConstraints() {
        imageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
}
