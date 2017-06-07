//
//  MoviePopularTableViewCellModelSpec.swift
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

class MoviePopularTableViewCellModelSpec: QuickSpec {
    
    class StubNetwork: Networking {
        func requestJSON(url: String, parameters: [String : Any]?) -> SignalProducer<Any, NetworkError>{
            return SignalProducer.empty
        }
        
        func requestImage(url: String) -> SignalProducer<UIImage, NetworkError>{
            return SignalProducer(value: image1x1).observe(on: QueueScheduler())
        }
        
        func requestBackImage(url: String) -> SignalProducer<UIImage, NetworkError>{
             return SignalProducer(value: image1x1).observe(on: QueueScheduler())
        }
    }
    
    class ErrorStubNetwork: Networking {
        func requestJSON(url: String, parameters: [String : Any]?) -> SignalProducer<Any, NetworkError>
        {
            return SignalProducer.empty
        }
        
        func requestImage(url: String) -> SignalProducer<UIImage, NetworkError> {
            return SignalProducer(error: .NotConnectedToInternet)
        }
        
        func requestBackImage(url: String) -> SignalProducer<UIImage, NetworkError>{
             return SignalProducer(error: .NotConnectedToInternet)
        }
    }
    
    
    override func spec() {
        var viewModel: MoviePopularTableViewCellModel!
        beforeEach {
            viewModel = MoviePopularTableViewCellModel(movie: dummyResponse.movies[0], network: StubNetwork(), genresKeys: GenresKeys())
        }
        
        describe("Constant values") {
            it("sets id.") {
                expect(viewModel.id).toEventually(equal(10000))
            }
            it("formats tag and page image size texts.") {
                expect(viewModel.title).toEventually(equal("Pirates of the Caribbean: Dead Men Tell No Tales"))
                expect(viewModel.genres).toEventually(equal(""))
            }
        }
        describe("Preview image") {
            it("returns nil at the first time.") {
                var image: UIImage? = image1x1
                viewModel.getPreviewImage()
                    .take(first: 1)
                    .on(value: { image = $0 })
                    .start()
                
                expect(image).toEventually(beNil())
            }
            it("eventually returns an image.") {
                var image: UIImage? = nil
                viewModel.getPreviewImage()
                    .on(value: { image = $0 })
                    .start()
                
                expect(image).toEventuallyNot(beNil())
            }
            it("returns an image on the main thread.") {
                var onMainThread = false
                viewModel.getPreviewImage()
                    .skip(first: 1) // Skips the first nil.
                    .on(value: { _ in onMainThread = Thread.isMainThread })
                    .start()
                
                expect(onMainThread).toEventually(beTrue())
            }
            context("with an image already downloaded") {
                it("immediately returns the image omitting the first nil.") {
                    var image: UIImage? = nil
                    viewModel.getPreviewImage().startWithCompleted {
                        viewModel.getPreviewImage()
                            .take(first: 1)
                            .on(value: { image = $0 })
                            .start()
                    }
                    
                    expect(image).toEventuallyNot(beNil())
                }
            }
            context("on error") {
                it("returns nil.") {
                    var image: UIImage? = image1x1
                    let viewModel = MoviePopularTableViewCellModel(
                        movie: dummyResponse.movies[0],
                        network: ErrorStubNetwork(),
                        genresKeys: GenresKeys())
                    viewModel.getPreviewImage()
                        .skip(first: 1) // Skips the first nil.
                        .on(value: { image = $0 })
                        .start()
                    
                    expect(image).toEventually(beNil())
                }
            }
        }
    }
}
