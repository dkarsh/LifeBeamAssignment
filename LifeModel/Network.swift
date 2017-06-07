//
//  Network.swift
//  LifeBloo
//
//  Created by Daniel Karsh on 6/3/17.
//  Copyright © 2017 Daniel Karsh. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import Alamofire

public final class Network: Networking {
    private let serialJsonQueue = DispatchQueue(label: "serialJsonQueue")
    private let serialImageQueue = DispatchQueue(label: "serialImageQueue")
    public init() { }
    
    
    
    public func requestJSON(url: String, parameters: [String : Any]?) -> SignalProducer<Any, NetworkError>{
        return SignalProducer { observer, disposable in
            Alamofire.request(url, method: .get, parameters: parameters)
            .responseJSON(queue:self.serialJsonQueue)  { response in
                switch response.result {
                case .success(let value):
                    observer.send(value: value)
                    observer.sendCompleted()
                case .failure(let error):
                    observer.send(error: NetworkError(error: error as NSError))
                }
            }
        }
    }
    
    public func requestImage(url: String) -> SignalProducer<UIImage, NetworkError> {
        return SignalProducer { observer, disposable in
            let baseUrl = TheMovieDB.imgURL + url
            Alamofire.request(baseUrl, method: .get)
                .responseData(queue: self.serialImageQueue) {
                    response in
                    switch response.result {
                    case .success(let data):
                        guard let image = UIImage(data: data) else {
                            observer.send(error: .IncorrectDataReturned)
                            return
                        }
                        observer.send(value: image)
                        observer.sendCompleted()
                    case .failure(let error):
                        observer.send(error: NetworkError(error: error as NSError))
                    }
            }
        }
    }
    
    public func requestBackImage(url: String) -> SignalProducer<UIImage, NetworkError> {
        return SignalProducer { observer, disposable in
            let baseUrl = TheMovieDB.backImgURL + url
            Alamofire.request(baseUrl, method: .get)
                .responseData(queue: self.serialImageQueue) {
                    response in
                    switch response.result {
                    case .success(let data):
                        guard let image = UIImage(data: data) else {
                            observer.send(error: .IncorrectDataReturned)
                            return
                        }
                        observer.send(value: image)
                        observer.sendCompleted()
                    case .failure(let error):
                        observer.send(error: NetworkError(error: error as NSError))
                    }
            }
        }
    }

    
    public func cancelTasks(){
        let sessionManager = Alamofire.SessionManager.default
        sessionManager.session.getTasksWithCompletionHandler { (datas, tasks, downs) in
         print("datas = \(datas.count)")
                datas.forEach({ (data) in
                    data.cancel()
                })
        }
    }
}
