//
//  MoviePopularTableViewModelSpec.swift
//  LifeBloo
//
//  Created by Daniel Karsh on 6/3/17.
//  Copyright © 2017 Daniel Karsh. All rights reserved.
//

import Quick
import Nimble

import ReactiveSwift
@testable import LifeModel
@testable import LifeViewModel

class MoviePopularTableViewModelSpec: QuickSpec {
    // MARK: Stub
    class StubMoviePopular: MovieCalling {
        func callPopular(nextPageTrigger trigger: SignalProducer<(), NoError>) -> SignalProducer<ResponsePopular, NetworkError> {
            return SignalProducer { observer, disposable in
                observer.send(value: dummyResponse)
                observer.sendCompleted()
                }
                .observe(on: QueueScheduler())
        }
        
        func callCredit(movieID:String) -> SignalProducer<ResponseCredits, NetworkError> {
             return SignalProducer.empty
        }
        func callGenres() -> SignalProducer<ResponseGenres, NetworkError>{
             return SignalProducer.empty
        }
    }
    
    class StubNetwork: Networking {
        func requestJSON(url: String, parameters: [String : Any]?) -> SignalProducer<Any, NetworkError>{
            return SignalProducer.empty
        }
        
        func requestImage(url: String) -> SignalProducer<UIImage, NetworkError>{
            return SignalProducer.empty
        }
        
        func requestBackImage(url: String) -> SignalProducer<UIImage, NetworkError>{
            return SignalProducer.empty
        }
    }

    
    // MARK: Spec
    override func spec() {
        var viewModel: MoviePopularTableViewModel!
        beforeEach {
            viewModel = MoviePopularTableViewModel(
                movieCalls: StubMoviePopular(),
                network: StubNetwork())
        
        it("eventually sets cellModels property after the search.") {
            var cellModels: [MoviePopularTableViewCellModeling]? = nil
            viewModel.cellModels.producer
                .on(value: { cellModels = $0 })
                .start()
            viewModel.startFetch()
            
            expect(cellModels).toEventuallyNot(beNil())
            expect(cellModels?.count).toEventually(equal(2))
            expect(cellModels?[0].id).toEventually(equal(10000))
            expect(cellModels?[1].id).toEventually(equal(10001))
        }
        it("sets cellModels property on the main thread.") {
            var onMainThread = false
            viewModel.cellModels.producer
                .on(value: { _ in onMainThread = Thread.isMainThread })
                .start()
            viewModel.startFetch()
            
            expect(onMainThread).toEventually(beTrue())
        }
        }
    }
    
}
