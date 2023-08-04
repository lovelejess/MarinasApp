//
//  MarinasSearchViewController.swift
//  MarinasApp
//
//  Created by Jess Lê on 8/24/22.
//

import UIKit
import Combine
import SDWebImage

class MarinasSearchViewController: UIViewController {

    enum Section {
        case main
    }

    private var subscribers = [AnyCancellable]()

    lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        return controller
    }()

    lazy var dataSource: UICollectionViewDiffableDataSource<Section, Point> = {
        return configureDataSource()
    }()

    var viewModel: MarinasSearchViewModel!
    var marinasCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        configureCollectionView()
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

//        viewModel.point
//        .receive(on: DispatchQueue.main)
//        .sink(receiveCompletion: { value in
//            switch value {
//            case .failure:
//                print("Failure")
//            case .finished:
//                print("Finished")
//            }
//        }, receiveValue: { [weak self] point in
//            guard let self = self else { return }
//            var url: URL? = nil
//            if let urlString = point.url {
//                url = URL(string: urlString)
//            }
//            let pointDetails = PointDetails(name: point.name, image: point.images.data.first?.smallUrl, kind: point.kind, url: url)
//            self.coordinator?.navigate(to: .rootTabBar(.searchMarinas(.point(point: pointDetails))))
//          })
//        .store(in: &subscribers)
    }

    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Marina Points"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
    }
}

// MARK: Datasource
extension MarinasSearchViewController {
    private func configureDataSource() -> UICollectionViewDiffableDataSource<Section, Point> {

        let cellRegistration = createPointsCellRegistration()

        let dataSource = UICollectionViewDiffableDataSource<Section, Point>(collectionView: marinasCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Point) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }

        let snapshot = snapshotForInitialState()
        dataSource.apply(snapshot, animatingDifferences: false)
        return dataSource
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
            let placeHolderImageURL = "https://picsum.photos/id/1025/200"
            let imageView = UIImageView()
            imageView.sd_setImage(with: URL(string: point.images.data.first?.thumbnailUrl ?? placeHolderImageURL), placeholderImage: UIImage(named: placeHolderImageURL)) { (image, error, imageCacheType, imageUrl) in
                content.image = imageView.image
                content.secondaryText = point.kind?.rawValue
                cell.contentConfiguration = content
            }
        }
    }
}

// MARK: Layouts
extension MarinasSearchViewController {
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
extension MarinasSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let point = viewModel.points[indexPath.row]
        viewModel.didSelectPoint(for: point.id)
        collectionView.deselectItem(at: indexPath, animated: false)
    }
}

// MARK: UISearchResultsUpdating
extension MarinasSearchViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
      let searchBar = searchController.searchBar
      guard let query = searchBar.text, query.count > 1 else { return }
      viewModel.searchText.send(query)
  }
}

// MARK: UISearchBarDelegate
extension MarinasSearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        let snapshot = self.getUpdatedSnapshot(with: [])
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }
}
