//
//  AppDetailHeaderView.swift
//  iTunesProject
//
//  Created by Jinyoung Yoo on 8/11/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

import RxSwift
import RxCocoa

final class AppDetailHeaderView: UIView {
    
    private let logoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }
    
    private let appTitleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.numberOfLines = 1
    }
    
    private let developerNameLabel = UILabel().then {
        $0.textColor = .lightGray
        $0.font = .systemFont(ofSize: 15)
        $0.numberOfLines = 1
    }
    
    private let downloadButton = UIButton().then {
        var config = UIButton.Configuration.filled()
        
        config.cornerStyle = .capsule
        $0.setTitle("받기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.configuration = config
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
        self.addSubview(logoImageView)
        self.addSubview(appTitleLabel)
        self.addSubview(developerNameLabel)
        self.addSubview(downloadButton)
    }
    
    private func configureLayout() {
        logoImageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(logoImageView.snp.height)
        }
        
        appTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(logoImageView.snp.trailing).offset(20)
            make.top.equalToSuperview().offset(10)
        }
        
        developerNameLabel.snp.makeConstraints { make in
            make.top.equalTo(appTitleLabel.snp.bottom).offset(20)
            make.leading.equalTo(logoImageView.snp.trailing).offset(20)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.top.equalTo(developerNameLabel.snp.bottom).offset(10)
            make.leading.equalTo(logoImageView.snp.trailing).offset(20)
            make.bottom.equalToSuperview()
            make.width.equalTo(80)
        }
    }
    
    fileprivate func bind(app: App) {
        logoImageView.kf.setImage(with: URL(string: app.appIcon)!)
        appTitleLabel.text = app.appName
        developerNameLabel.text = app.developerName
    }
}

extension Reactive where Base: AppDetailHeaderView {
    var binder: Binder<App> {
        return Binder(base) { base, app in
            base.bind(app: app)
        }
    }
}
