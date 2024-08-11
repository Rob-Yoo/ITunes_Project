//
//  ReleaseContentView.swift
//  iTunesProject
//
//  Created by Jinyoung Yoo on 8/11/24.
//

import UIKit
import SnapKit
import Then

import RxSwift
import RxCocoa

final class ReleaseContentView: UIView {
    
    private let titleLabel = UILabel().then {
        $0.text = "새로운 소식"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 20, weight: .medium)
    }
    
    private let versionLabel = UILabel().then {
        $0.textColor = .lightGray
        $0.font = .systemFont(ofSize: 15)
    }
    
    private let releaseNotesLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 15)
        $0.numberOfLines = 0
    }
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        self.addSubview(titleLabel)
        self.addSubview(versionLabel)
        self.addSubview(releaseNotesLabel)
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        versionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview()
        }
        
        releaseNotesLabel.snp.makeConstraints { make in
            make.top.equalTo(versionLabel.snp.bottom)
                .offset(20)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    fileprivate func bind(app: App) {
        versionLabel.text = "버전 " + app.version
        releaseNotesLabel.text = app.releaseNotes
    }
}

extension Reactive where Base: ReleaseContentView {
    var binder: Binder<App> {
        return Binder(base) { base, app in
            base.bind(app: app)
        }
    }
}
