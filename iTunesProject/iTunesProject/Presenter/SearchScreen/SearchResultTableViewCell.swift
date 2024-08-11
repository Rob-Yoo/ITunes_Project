//
//  SearchResultTableViewCell.swift
//  iTunesProject
//
//  Created by Jinyoung Yoo on 8/10/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher
import RxSwift
import RxCocoa

final class SearchResultTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: SearchResultTableViewCell.self)
    
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
    
    private let saveButton = UIButton().then {
        var config = UIButton.Configuration.gray()
        
        config.cornerStyle = .capsule
        $0.setTitle("받기", for: .normal)
//        $0.setTitleColor(.systemBlue, for: .normal)
        $0.configuration = config
    }
    
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func configureHierarchy() {
        self.contentView.addSubview(logoImageView)
        self.contentView.addSubview(appTitleLabel)
        self.contentView.addSubview(saveButton)
    }
    
    private func configureLayout() {
        logoImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.verticalEdges.equalToSuperview().inset(10)
            make.width.equalTo(logoImageView.snp.height)
        }
        
        appTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(logoImageView.snp.trailing).offset(20)
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        saveButton.snp.makeConstraints { make in
            make.leading.equalTo(appTitleLabel.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    func bind(appInfo: SharedSequence<DriverSharingStrategy, App>) {
        
        appInfo
            .map { $0.appIcon }
            .drive(with: self) { owner, imageURL in
                owner.logoImageView.kf.setImage(with: URL(string: imageURL)!)
            }
            .disposed(by: disposeBag)
        
        appInfo
            .map { $0.appName }
            .drive(appTitleLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
