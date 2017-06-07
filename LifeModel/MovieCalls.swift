//
//  MovieSearch.swift
//  LifeBloo
//
//  Created by Daniel Karsh on 6/3/17.
//  Copyright © 2017 Daniel Karsh. All rights reserved.
//

import ReactiveSwift
import Result
import Himotoki

public final class MovieCalls: MovieCalling {
    private let network: Networking
    
    public init(network: Networking) {
        self.network = network
    }
    
    public func callPopular(nextPageTrigger trigger: SignalProducer<(), NoError>) -> SignalProducer<ResponsePopular, NetworkError> {
        return SignalProducer { observer, disposable in
            
            let url = TheMovieDB.apiURL + TheMovieDB.popular
            let firstSearch = SignalProducer<(), NoError>(value: ())
            let load = firstSearch.concat(trigger)
            var parameters = TheMovieDB.requestParameters
            var page = 1
            
            load.on(value: {
                parameters["page"] = page
                self.network.requestJSON(url: url, parameters: parameters)
                    .start({ event in
                        switch event {
                        case .value(let json):
                            if let response = try? ResponsePopular.decodeValue(json) {
                                observer.send(value: response)
                                if response.total_pages == response.page {
                                    observer.sendCompleted()
                                }
                            }
                            else {
                                observer.send(error: .IncorrectDataReturned)
                            }
                        case .failed(let error):
                            observer.send(error: error)
                        case .completed:
                            break
                        case .interrupted:
                            observer.sendInterrupted()
                        }
                    })
                page += 1
            }).start()
        }
    }

    
    public func callCredit(movieID:String) -> SignalProducer<ResponseCredits, NetworkError> {
         return SignalProducer { observer, disposable in
            let url = TheMovieDB.apiURL + movieID + TheMovieDB.credit
            let parameters = TheMovieDB.requestParameters
            self.network.requestJSON(url: url, parameters: parameters)
            .startWithResult({ (result) in
                switch result {
                    case .success(let json):
                        if let response = try? ResponseCredits.decodeValue(json) {
                            observer.send(value: response)
                            observer.sendCompleted()
                        }
                        else {
                            observer.send(error: .IncorrectDataReturned)
                        }
                    case .failure(let error):
                    observer.send(error: error)
                }
            })
        }
    }
    
    public func callGenres() -> SignalProducer<ResponseGenres, NetworkError> {
        return SignalProducer { observer, disposable in
            let url = TheMovieDB.genresURL
            let parameters = TheMovieDB.requestParameters
            self.network.requestJSON(url: url, parameters: parameters)
                .startWithResult({ (result) in
                    switch result {
                    case .success(let json):
                        if let response = try? ResponseGenres.decodeValue(json) {
                            observer.send(value: response)
                            observer.sendCompleted()
                        }
                        else {
                            observer.send(error: .IncorrectDataReturned)
                        }
                    case .failure(let error):
                        observer.send(error: error)
                    }
                })
        }
    }
    
}
