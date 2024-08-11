//
//  NetworkManager.swift
//  iTunesProject
//
//  Created by Jinyoung Yoo on 8/8/24.
//

import Alamofire
import RxSwift

enum NetworkManager {
    static func requestAPI(query: String) -> Observable<[App]> {
        let url = "https://itunes.apple.com/search?term=\(query)&country=kr&entity=software&limit=50&lang=ko_kr"
        
        let observable = Observable<[App]>.create { observer in
            let task = Task {
                
                let result = await AF.request(url)
                    .validate()
                    .serializingDecodable(AppResponse.self).result
                
                switch result {
                case .success(let value):
                    observer.onNext(value.results)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                task.cancel()
            }
        }
        
        return observable
    }
}
