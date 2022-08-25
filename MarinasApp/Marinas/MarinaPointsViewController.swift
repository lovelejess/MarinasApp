//
//  MarinaPointsViewController.swift
//  MarinasApp
//
//  Created by Jess Lê on 8/24/22.
//

import UIKit

class MarinaPointsViewController: UIViewController {

    enum Section {
        case main
    }

    var coordinator: MarinasCoordinator?
    var marinasCollectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Point>!
    var nameFilter: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Marinas Home"
        configureCollectionView()
        configureDataSource()
    }
}

// MARK: Datasource
extension MarinaPointsViewController {
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration
        <PointCollectionViewCell, Point> { (cell, indexPath, point) in
            cell.label.text = point.name
        }

        dataSource = UICollectionViewDiffableDataSource<Section, Point>(collectionView: marinasCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Point) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }

        let snapshot = snapshotForInitialState()
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func snapshotForInitialState() -> NSDiffableDataSourceSnapshot<Section, Point> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Point>()
        snapshot.appendSections([Section.main])
        let items = [Point(id: "1", name: "Point 1"), Point(id: "2", name: "Point 2"), Point(id: "3", name: "Point 3"), Point(id: "4", name: "Point 4")]
        snapshot.appendItems(items)
        return snapshot
    }
}

// MARK: Layouts
extension MarinaPointsViewController {
    func configureCollectionView() {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: configureLayout())
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.register(PointCollectionViewCell.self, forCellWithReuseIdentifier: PointCollectionViewCell.reuseIdentifier)
        marinasCollectionView = collectionView
    }

    func configureLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let fullPhotoItem = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(2/3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: fullPhotoItem, count: 1)

        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

// MARK: UICollectionViewDelegate
extension MarinaPointsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}

