//
//  SearchViewController.swift
//  iTunesProject
//
//  Created by Jinyoung Yoo on 8/8/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Toast

class SearchViewController: UIViewController {
    
    private lazy var searchController = UISearchController(searchResultsController: nil).then {
        $0.searchBar.placeholder = "게임, 앱, 스토리 등"
        $0.searchBar.searchBarStyle = .prominent
        $0.searchBar.autocapitalizationType = .none
        $0.searchBar.autocorrectionType = .no
        $0.hidesNavigationBarDuringPresentation = true
        $0.automaticallyShowsCancelButton = true

        self.navigationItem.searchController = $0
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    private let viewModel = SearchViewModel()
    private let disposeBag = DisposeBag()
    private let tableView = UITableView().then {
        $0.rowHeight = 100
        $0.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "검색"
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        bind()
    }
    
    func bind() {
        let cellSelected = Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(App.self))
        let input = SearchViewModel.Input(searchText: searchController.searchBar.rx.text.orEmpty, searchButtonTapped: searchController.searchBar.rx.searchButtonClicked, cancelButtonTapped: searchController.searchBar.rx.cancelButtonClicked, cellSelected: cellSelected)
        let output = self.viewModel.transform(input: input)
        
        output.appList
            .bind(to: tableView.rx.items(cellIdentifier: SearchResultTableViewCell.identifier, cellType: SearchResultTableViewCell.self)) { row, element, cell in
                let element = BehaviorRelay(value: element).asDriver()
                
                cell.bind(appInfo: element)
            }
            .disposed(by: disposeBag)
        
        output.networkError
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, message in
                owner.view.makeToast(message, duration: 1.5, position: .center)
            }
            .disposed(by: disposeBag)
        
        output.cellSelected
            .bind(with: self) { owner, value in
                let nextVC = AppDetailViewController(viewModel: AppDetailViewModel(app: value.1))
                
                owner.navigationController?.pushViewController(nextVC, animated: true)
                owner.tableView.deselectRow(at: value.0, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

