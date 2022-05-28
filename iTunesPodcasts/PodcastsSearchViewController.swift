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

    private let podcastsTableView: UITableView = {
        let podcastsTableView = UITableView()
        podcastsTableView.translatesAutoresizingMaskIntoConstraints = false
        podcastsTableView.register(PodcastCell.self, forCellReuseIdentifier: PodcastCell.reuseIdentifier)
        podcastsTableView.rowHeight = UITableView.automaticDimension
        return podcastsTableView
    }()

    private let disposeBag = DisposeBag()
    private let podcastsSearchViewModel: PodcastsSearchViewModel

    init(podcastsSearchViewModel: PodcastsSearchViewModel) {
        self.podcastsSearchViewModel = podcastsSearchViewModel
        super.init(nibName: nil, bundle: nil)
        self.title = "Podcasts"
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
        [searchBar, podcastsTableView].forEach(view.addSubview)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            podcastsTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            podcastsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            podcastsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            podcastsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func setupBindings() {
        podcastsSearchViewModel
            .podcastsCellsViewModels
            .asDriver(onErrorJustReturn: [])
            .drive(
                podcastsTableView.rx.items(
                    cellIdentifier: PodcastCell.reuseIdentifier,
                    cellType: PodcastCell.self
                )
            ) { indexPath, podcastCellViewModel, cell in
                cell.configure(with: podcastCellViewModel)
            }
            .disposed(by: disposeBag)

        podcastsTableView.rx.itemSelected
            .map { $0.row }
            .bind(to: podcastsSearchViewModel.tappedCellIndexRelay)
            .disposed(by: disposeBag)

        podcastsSearchViewModel.navigateToDetailsScreen
            .withUnretained(self)
            .subscribe(onNext: { owner, viewModel in
                let detailsViewController = PodcastDetailsViewController(podcastDetailsViewModel: viewModel)
                owner.navigationController?.pushViewController(detailsViewController, animated: true)
            })
            .disposed(by: disposeBag)

        searchBar.rx.text
            .compactMap { $0 }
            .bind(to: podcastsSearchViewModel.searchTextDidChangeRelay)
            .disposed(by: disposeBag)
    }
}
