//
//  AppDetailViewController.swift
//  iTunesProject
//
//  Created by Jinyoung Yoo on 8/10/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class AppDetailViewController: UIViewController {
    
    private let viewModel: AppDetailViewModel
    private let headerView = AppDetailHeaderView()
    private let releaseContentView = ReleaseContentView()
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: AppDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.largeTitleDisplayMode = .never
        configureHierarchy()
        configureLayout()
    }
    
    private func configureHierarchy() {
        self.view.addSubview(headerView)
        self.view.addSubview(releaseContentView)
    }
    
    private func configureLayout() {
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(headerView.snp.width).multipliedBy(0.3)
        }
        
        releaseContentView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).offset(-100)
        }
    }
    
    func bind() {
        let input = AppDetailViewModel.Input(viewDidLoad: self.rx.viewDidLoad)
        let output = self.viewModel.transform(input: input)
        
        output.appDetail
            .bind(to: headerView.rx.binder, releaseContentView.rx.binder)
            .disposed(by: disposeBag)
    }
}
