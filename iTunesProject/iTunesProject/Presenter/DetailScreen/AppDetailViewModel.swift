//
//  AppDetailViewModel.swift
//  iTunesProject
//
//  Created by Jinyoung Yoo on 8/10/24.
//

import RxSwift
import RxCocoa

final class AppDetailViewModel {

    struct Input {
        let viewDidLoad: ControlEvent<Void>
    }
    
    struct Output {
        let appDetail: PublishRelay<App>
    }
    
    private let app: App
    private let disposeBag = DisposeBag()
    
    init(app: App) {
        self.app = app
    }
    
    func transform(input: Input) -> Output {
        let appDetail = PublishRelay<App>()
        
        input.viewDidLoad
            .subscribe(with: self) { owner, _  in
                appDetail.accept(owner.app)
            }
            .disposed(by: disposeBag)
        
        return Output(appDetail: appDetail)
    }
}
