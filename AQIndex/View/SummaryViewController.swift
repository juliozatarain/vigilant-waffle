import UIKit

class SummaryViewController: UIViewController {
    private let searchBar = UISearchBar()
    private let locationButton = UIButton(type: .system)
    private let noContentView = UIView()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let contentView = UIView()
    private let stationInfoView = StationInfoView()
    private let primaryView = UIView()
    private let secondaryView = UIView()
    private let tertiaryView = UIView()
    private let tableView = UITableView()
    private var daySummary: [DaySummaryViewModel] = []
    
    var viewModel = SummaryScreenViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupBindings()
        updateViewState(state: viewModel.state)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Task.detached {
            await self.viewModel.onViewDidAppear()
        }
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor(red: 144/255.0, green: 213/255.0, blue: 255/255.0, alpha: 1.0)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundColor = .clear
        searchBar.backgroundImage = UIImage()
        searchBar.layer.borderColor = UIColor.clear.cgColor
        searchBar.delegate = self
        view.addSubview(searchBar)
        
        locationButton.setTitle("Location", for: .normal)
        locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(locationButton)
        
        noContentView.translatesAutoresizingMaskIntoConstraints = false
        let alertIcon = UIImageView(image: UIImage(systemName: "exclamationmark.triangle"))
        alertIcon.translatesAutoresizingMaskIntoConstraints = false
        let noContentLabel = UILabel()
        noContentLabel.text = "No Content"
        noContentLabel.translatesAutoresizingMaskIntoConstraints = false
        noContentView.addSubview(alertIcon)
        noContentView.addSubview(noContentLabel)
        view.addSubview(noContentView)
        
        NSLayoutConstraint.activate([
            alertIcon.centerXAnchor.constraint(equalTo: noContentView.centerXAnchor),
            alertIcon.centerYAnchor.constraint(equalTo: noContentView.centerYAnchor, constant: -10),
            noContentLabel.centerXAnchor.constraint(equalTo: noContentView.centerXAnchor),
            noContentLabel.topAnchor.constraint(equalTo: alertIcon.bottomAnchor, constant: 10)
        ])
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicator)
        
        tableView.register(SummaryRectangleCell.self, forCellReuseIdentifier: SummaryRectangleCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.bounces = false
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(red: 144/255.0, green: 213/255.0, blue: 255/255.0, alpha: 1.0)
        contentView.addSubview(stationInfoView)
        stationInfoView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tableView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(contentView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: locationButton.leadingAnchor, constant: -10),
            
            locationButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            locationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            noContentView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            noContentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noContentView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            noContentView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            loadingIndicator.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            contentView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            stationInfoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stationInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stationInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stationInfoView.bottomAnchor.constraint(equalTo: tableView.topAnchor),
                    
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    private func setupBindings() {
        viewModel.onStateChange = { [weak self] state in
            self?.updateViewState(state: state)
        }
    }
    
    private func updateViewState(state: SummaryViewState) {
        noContentView.isHidden = true
        loadingIndicator.isHidden = true
        contentView.isHidden = true
        
        switch state {
        case .noContent:
            daySummary = []
            noContentView.isHidden = false
        case .loading:
            daySummary = []
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
        case .content(let vm):
            stationInfoView.configure(with: vm.locationInfo)
            daySummary = vm.daySummary
            loadingIndicator.stopAnimating()
            contentView.isHidden = false
            tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }
    }

    @objc private func locationButtonTapped() {
        Task.detached {
            await self.viewModel.locationButtonWasTapped()
        }
    }
}

extension SummaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daySummary.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SummaryRectangleCell.reuseIdentifier, for: indexPath) as! SummaryRectangleCell
        let viewModel = daySummary[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
}


extension SummaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension SummaryViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let searchVC = SearchViewController()
        searchVC.onResultWasSelected = { [weak self] uid in
            Task {
               await self?.viewModel.onSearchItemWasSelected(uid: uid)
            }
        }
        let navController = UINavigationController(rootViewController: searchVC)
        present(navController, animated: true, completion: nil)
    }
}
