//
//  MarinaPointsViewController.swift
//  MarinasApp
//
//  Created by Jess Lê on 8/24/22.
//

import UIKit
import Combine
import SDWebImage

class MarinaPointsViewController: UIViewController {

    enum Section {
        case main
    }

    let searchController = UISearchController(searchResultsController: nil)
    private var subscribers = [AnyCancellable]()
    var coordinator: MarinasCoordinator?
    var viewModel: MarinasPointViewModel!
    var marinasCollectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Point>!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Marinas Home"
        configureSearchController()
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

    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Marina Points"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.scopeButtonTitles = Kind.getPopularFilters().map { $0.rawValue }
        searchController.searchBar.delegate = self
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
            
            // TODO: Figure out how to load an SVG from URL
//            let iconURL = point.iconURL ?? "https://picsum.photos/200"
            let placeHolderImageURL = "https://picsum.photos/seed/picsum/200"
            let imageView = UIImageView()
            imageView.sd_setImage(with: URL(string: placeHolderImageURL), placeholderImage: UIImage(named: placeHolderImageURL)) { (image, error, imageCacheType, imageUrl) in
                content.image = imageView.image
                content.secondaryText = point.kind.rawValue
                cell.contentConfiguration = content
            }
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

// MARK: UISearchResultsUpdating
extension MarinaPointsViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
      let searchBar = searchController.searchBar
      print("JESS: text: \(searchBar.text)")

      guard let query = searchBar.text, query.count > 1 else { return }
      print("JESS: sending searchText: \(query)")
      viewModel.searchText.send(query)
  }
}

// MARK: UISearchBarDelegate
extension MarinaPointsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {

  }
}
