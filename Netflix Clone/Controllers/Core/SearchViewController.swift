//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by Ahmad Nabil on 09/05/24.
//

import UIKit

class SearchViewController: UIViewController {

    private var titles: [Title] = [Title]()
    
    private let discoverTable: UITableView = {
        let tableView = UITableView()
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return tableView
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for a Movie or TV show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        
        view.addSubview(discoverTable)
        discoverTable.delegate = self
        discoverTable.dataSource = self
        
        fetchDiscoverMovies()
        
        searchController.searchResultsUpdater = self
    }
    
    func fetchDiscoverMovies() {
        APICaller.shared.getDiscoverMovies {[weak self] result in
            switch result {
                case .success(let titles):
                    self?.titles = titles
                    
                    DispatchQueue.main.async {
                        self?.discoverTable.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }

}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let title = titles[indexPath.row].original_name ?? titles[indexPath.row].original_title ?? "Unknown"
        cell.configure(with: TitleViewModel(titleName: title, posterURL: titles[indexPath.row].poster_path ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_title ?? title.original_name else { return }
        
        APICaller.shared.getMovie(with: titleName) {[weak self] result in
            switch result {
                case .success(let videoElement):
                    DispatchQueue.main.async {
                        let vc = TitlePreviewViewController()
                        vc.configure(with: TitlePreviewViewmodel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}

extension SearchViewController: UISearchResultsUpdating, SearchResultsViewControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchbar = searchController.searchBar
        
        guard let query = searchbar.text,
        !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
        query.trimmingCharacters(in: .whitespacesAndNewlines).count >= 3,
        let resultsController = searchController.searchResultsController as? SearchResultsViewController else { return }
        resultsController.delegate = self
        APICaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let titles):
                        resultsController.titles = titles
                        resultsController.searchResultsCollectionView.reloadData()
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
        }
    }
    
    func SearchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewmodel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
