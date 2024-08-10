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
    
    private let contentView = SearchRootView()
    private let viewModel = SearchViewModel()
    private let disposeBag = DisposeBag()

    
    override func loadView() {
        self.view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "검색"
        bind()
    }
    
    func bind() {
        let input = SearchViewModel.Input(searchText: searchController.searchBar.rx.text.orEmpty, searchButtonTapped: searchController.searchBar.rx.searchButtonClicked)
        let output = self.viewModel.transform(input: input)
        
        output.appList
            .bind(with: self) { owner, value in
                print(value)
            }
            .disposed(by: disposeBag)
    }
}

