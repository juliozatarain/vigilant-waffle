import Foundation
import UIKit

class SearchViewController: UIViewController {
    var viewModel = SearchResultViewModel()
    let searchBar = UISearchBar()
    
    var onResultWasSelected: ((String) -> Void)?
    
    private var results: [SearchResultItemViewModel] = []
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 144/255.0, green: 213/255.0, blue: 255/255.0, alpha: 1.0)
        setupSearchBar()
        setupTableView()
        setupBindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.backgroundColor = UIColor(red: 144/255.0, green: 213/255.0, blue: 255/255.0, alpha: 1.0)
        navigationItem.titleView = searchBar
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor(red: 144/255.0, green: 213/255.0, blue: 255/255.0, alpha: 1.0)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ResultCell")
    }
    
    private func setupBindings() {
        viewModel.onSearchResultsUpdated = { [weak self] results in
            self?.results = results
            self?.tableView.reloadData()
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchQueryDidChange(query: searchText)
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
        let result = results[indexPath.row]
        cell.textLabel?.text = result.name
        cell.backgroundColor = UIColor(red: 144/255.0, green: 213/255.0, blue: 255/255.0, alpha: 1.0)
        cell.contentView.backgroundColor = UIColor(red: 144/255.0, green: 213/255.0, blue: 255/255.0, alpha: 1.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        onResultWasSelected?(results[indexPath.row].uid)
        self.navigationController?.dismiss(animated: true)
    }
}
