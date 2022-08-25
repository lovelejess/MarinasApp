//
//  PointCollectionViewCell.swift
//  MarinasApp
//
//  Created by Jess Lê on 8/24/22.
//

import Foundation
import UIKit

class PointCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "pointCollectionViewCell"
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init with coder not implemented")
    }
}

extension PointCollectionViewCell {
    func configure() {
        backgroundColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray2.cgColor
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
    }
}
