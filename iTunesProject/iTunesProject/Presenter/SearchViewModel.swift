//
//  SearchViewModel.swift
//  iTunesProject
//
//  Created by Jinyoung Yoo on 8/8/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel {
    
    struct Input {
        let searchText: ControlProperty<String>
        let searchButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let appList: PublishSubject<[AppDTO]>
    }

    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let appList = PublishSubject<[AppDTO]>()

        input.searchButtonTapped
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .flatMap {
                NetworkManager.requestAPI(query: $0)
            }
            .subscribe(with: self) { owner, value in
                appList.onNext(value)
            } onError: { owner, error in
                appList.onError(error)
            }
            .disposed(by: disposeBag)
        
        return Output(appList: appList)
    }
}
