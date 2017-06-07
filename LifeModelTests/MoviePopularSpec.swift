//
//  MoviePopularSpec.swift
//  LifeBloo
//
//  Created by Daniel Karsh on 6/3/17.
//  Copyright © 2017 Daniel Karsh. All rights reserved.
//

import Quick
import Nimble

import ReactiveSwift

@testable import LifeModel

class MoviePopularSpec: QuickSpec {
    // MARK: Stub
    class GoodStubNetwork: Networking {
        
        func requestJSON(url: String, parameters: [String : Any]?)
            -> SignalProducer<Any, NetworkError>
        {
            var movieJSON0 = movieJSON
            movieJSON0["id"] = 0
            var movieJSON1 = movieJSON
            movieJSON1["id"] = 1
            let json: [String: Any] = [
                "page": 123,
                "results": [movieJSON0, movieJSON1],
                "total_results":19629,
                "total_pages":982
            ]
            
            return SignalProducer { observer, disposable in
                observer.send(value: json)
                observer.sendCompleted()
                }.observe(on: QueueScheduler())
        }
        
        func requestImage(url: String) -> SignalProducer<UIImage, NetworkError> {
            return SignalProducer.empty
        }
        
        func requestBackImage(url: String) -> SignalProducer<UIImage, NetworkError> {
            return SignalProducer.empty
        }
    }
    
    class BadStubNetwork: Networking {
        
        func requestJSON(url: String, parameters: [String : Any]?) -> SignalProducer<Any, NetworkError>
        {
            let json = [String: Any]()
            
            return SignalProducer { observer, disposable in
                observer.send(value: json)
                observer.sendCompleted()
                }.observe(on: QueueScheduler())
        }
        
        func requestImage(url: String) -> SignalProducer<UIImage, NetworkError> {
            return SignalProducer.empty
        }
        
        func requestBackImage(url: String) -> SignalProducer<UIImage, NetworkError> {
            return SignalProducer.empty
        }
    
        
    }
    
    class ErrorStubNetwork: Networking {
        
        func requestJSON(url: String, parameters: [String : Any]?) -> SignalProducer<Any, NetworkError>
        {
            return SignalProducer { observer, disposable in
                observer.send(error: .NotConnectedToInternet)
                }.observe(on: QueueScheduler())
        }
        
        func requestImage(url: String) -> SignalProducer<UIImage, NetworkError> {
            return SignalProducer.empty
        }
        
        func requestBackImage(url: String) -> SignalProducer<UIImage, NetworkError> {
            return SignalProducer.empty
        }
   
    }
    
    class CountConfigurableStubNetwork: Networking {
        var moviesCountToEmit = 100
        
        func requestJSON(url: String, parameters: [String : Any]?) -> SignalProducer<Any, NetworkError>{
            func createMovieJSON(id: Int) -> [String: Any] {
                var json = movieJSON
                json["id"] = id
                return json
            }
            let json: [String: Any] = [
                "page": 123,
                "results":(0..<moviesCountToEmit).map { createMovieJSON(id: $0) },
                "total_results":19629,
                "total_pages":982
            ]
            
            return SignalProducer { observer, disposable in
                observer.send(value: json)
                observer.sendCompleted()
                }.observe(on: QueueScheduler())
        }
        
        func requestImage(url: String) -> SignalProducer<UIImage, NetworkError> {
            return SignalProducer.empty
        }
        
        func requestBackImage(url: String) -> SignalProducer<UIImage, NetworkError> {
            return SignalProducer.empty
        }
    }
    
    // MARK: - Mock
    class MockNetwork: Networking {
        var passedParameters: [String : Any]?
        
        func requestJSON(url: String, parameters: [String : Any]?) -> SignalProducer<Any, NetworkError> {
            passedParameters = parameters
            return SignalProducer.empty
        }
        
        func requestImage(url: String) -> SignalProducer<UIImage, NetworkError> {
            return SignalProducer.empty
        }
        
        func requestBackImage(url: String) -> SignalProducer<UIImage, NetworkError> {
            return SignalProducer.empty
        }
    }
    

    
    // MARK: - Spec
    override func spec() {
        describe("Response") {
        it("returns images if the network works correctly.") {
            var response: ResponsePopular? = nil
            let search = MovieCalls(network: GoodStubNetwork())
            search.callPopular(nextPageTrigger: SignalProducer.empty)
                .on(value: { response = $0 })
                .start()
            
            expect(response).toEventuallyNot(beNil())
            expect(response?.page).toEventually(equal(123))
            expect(response?.total_results).toEventually(equal(19629))
            expect(response?.total_pages).toEventually(equal(982))
            expect(response?.movies.count).toEventually(equal(2))
            expect(response?.movies[0].id).toEventually(equal(0))
            expect(response?.movies[1].id).toEventually(equal(1))
        }
        it("sends an error if the network returns incorrect data.") {
            var error: NetworkError? = nil
            let search = MovieCalls(network: BadStubNetwork())
            search.callPopular(nextPageTrigger: SignalProducer.empty)
                .on(failed: { error = $0 })
                .start()
            
            expect(error).toEventually(equal(NetworkError.IncorrectDataReturned))
        }
        it("passes the error sent by the network.") {
            var error: NetworkError? = nil
            let search = MovieCalls(network: ErrorStubNetwork())
            search.callPopular(nextPageTrigger: SignalProducer.empty)
                .on(failed: { error = $0 })
                .start()
            
            expect(error).toEventually(equal(NetworkError.NotConnectedToInternet))
        }
        
    }
        describe("Pagination") {
            describe("page parameter") {
                var mockNetwork: MockNetwork!
                var movieCall: MovieCalling!
                beforeEach {
                    mockNetwork = MockNetwork()
                    movieCall = MovieCalls(network: mockNetwork)
                }
                
                it("sets page to 1 at the beginning.") {
                    movieCall.callPopular(nextPageTrigger: SignalProducer.empty).start()
                    expect(mockNetwork.passedParameters?["page"] as? Int).toEventually(equal(1))
                }
                it("increments page by nextPageTrigger") {
                    let trigger = SignalProducer<(), NoError>(value: ()) // Trigger once.
                    movieCall.callPopular(nextPageTrigger: trigger).start()
                    expect(mockNetwork.passedParameters?["page"] as? Int).toEventually(equal(2))
                }
            }
        }

    }
    
}
