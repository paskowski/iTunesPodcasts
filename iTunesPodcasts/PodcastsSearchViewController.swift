import UIKit
import RxSwift
import RxCocoa

class PodcastsSearchViewController: UIViewController {

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Enter podcast title"
        return searchBar
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PodcastCell.self, forCellReuseIdentifier: PodcastCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()

    private let disposeBag = DisposeBag()
    private let podcastsSearchViewModel: PodcastsSearchViewModel

    init(podcastsSearchViewModel: PodcastsSearchViewModel) {
        self.podcastsSearchViewModel = podcastsSearchViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBindings()
    }

    private func setupLayout() {
        view.backgroundColor = .white
        [searchBar, tableView].forEach(view.addSubview)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func setupBindings() {
        podcastsSearchViewModel
            .foundPodcasts
            .asDriver(onErrorJustReturn: [])
            .drive(
                tableView.rx.items(
                    cellIdentifier: PodcastCell.reuseIdentifier,
                    cellType: PodcastCell.self
                )
            ) { indexPath, podcastCellViewModel, cell in
                cell.configure(with: podcastCellViewModel)
            }
            .disposed(by: disposeBag)

        searchBar.rx.text
            .compactMap { $0 }
            .bind(to: podcastsSearchViewModel.searchTextDidChangeRelay)
            .disposed(by: disposeBag)
    }
}
