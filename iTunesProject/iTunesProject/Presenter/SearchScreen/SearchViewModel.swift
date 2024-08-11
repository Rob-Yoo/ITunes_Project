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
        let cancelButtonTapped: ControlEvent<Void>
        let cellSelected: Observable<(ControlEvent<IndexPath>.Element, ControlEvent<App>.Element)>
    }
    
    struct Output {
        let appList: PublishRelay<[App]>
        let networkError: PublishRelay<String>
        let cellSelected: Observable<(ControlEvent<IndexPath>.Element, ControlEvent<App>.Element)>
    }

    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let appList = PublishRelay<[App]>()
        let networkError = PublishRelay<String>()
        
        input.searchButtonTapped
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .flatMap {
                NetworkManager.requestAPI(query: $0)
                    .catch { error in
                        networkError.accept(error.localizedDescription)
                        return Observable.empty()
                    }
            }
            .subscribe(with: self) { owner, value in
                appList.accept(value)
            }
            .disposed(by: disposeBag)
        
        input.cancelButtonTapped
            .map { [App]() }
            .bind(to: appList)
            .disposed(by: disposeBag)

        return Output(appList: appList, networkError: networkError, cellSelected: input.cellSelected)
    }
}
