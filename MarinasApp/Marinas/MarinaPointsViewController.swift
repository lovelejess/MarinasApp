//
//  MarinaPointsViewController.swift
//  MarinasApp
//
//  Created by Jess Lê on 8/24/22.
//

import UIKit
import Combine

class MarinaPointsViewController: UIViewController {

    enum Section {
        case main
    }

    private var subscribers = [AnyCancellable]()
    var coordinator: MarinasCoordinator?
    var viewModel: MarinasPointViewModel!
    var marinasCollectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Point>!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Marinas Home"
        configureCollectionView()
        configureDataSource()
        bindUIComponents()
    }

    private func bindUIComponents() {
        viewModel.$points
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { value in
            switch value {
            case .failure:
                print("Failure")
            case .finished:
                print("Finished")
            }
        }, receiveValue: { [weak self] value in
            guard let self = self else { return }
            let snapshot = self.getUpdatedSnapshot(with: value)
            self.dataSource.apply(snapshot, animatingDifferences: false)
          })
        .store(in: &subscribers)
    }
}

// MARK: Datasource
extension MarinaPointsViewController {
    private func configureDataSource() {
        
        let cellRegistration = createPointsCellRegistration()

        dataSource = UICollectionViewDiffableDataSource<Section, Point>(collectionView: marinasCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Point) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }

        let snapshot = snapshotForInitialState()
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func snapshotForInitialState() -> NSDiffableDataSourceSnapshot<Section, Point> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Point>()
        snapshot.appendSections([Section.main])
        return snapshot
    }

    private func getUpdatedSnapshot(with items: [Point]) -> NSDiffableDataSourceSnapshot<Section, Point> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Point>()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(items)
        return snapshot
    }

    private func createPointsCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Point> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, Point> { (cell, indexPath, point) in
            var content = cell.defaultContentConfiguration()

            // Configure content
            content.text = point.name
            content.secondaryText = point.kind.rawValue
            cell.contentConfiguration = content
        }
    }
}

// MARK: Layouts
extension MarinaPointsViewController {
    private func configureCollectionView() {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: configureLayout())
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        marinasCollectionView = collectionView
    }

    private func configureLayout() -> UICollectionViewLayout {
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
