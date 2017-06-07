//
//  MovieViewModel.swift
//  LifeBloo
//
//  Created by Daniel Karsh on 6/5/17.
//  Copyright © 2017 Daniel Karsh. All rights reserved.
//


import ReactiveCocoa
import ReactiveSwift
import LifeModel

public final class MovieViewModel: MovieViewModeling {
    
    public var movieID:     Property<UInt64?> { return Property(_movieID) }
    public var title:       Property<String?> { return Property(_title) }
    public var overView:    Property<String?> { return Property(_overView) }
    public var cast:        Property<String?> { return Property(_cast) }
    public var image:       Property<UIImage?>{ return Property(_image) }
    public var errorMessage:Property<String?> { return Property(_errorMessage) }
    
    fileprivate let _movieID        = MutableProperty<UInt64?>(nil)
    fileprivate let _title          = MutableProperty<String?>(nil)
    fileprivate let _overView       = MutableProperty<String?>(nil)
    fileprivate let _cast           = MutableProperty<String?>(nil)
    fileprivate let _image          = MutableProperty<UIImage?>(nil)
    fileprivate let _errorMessage   = MutableProperty<String?>(nil)
    
    fileprivate var movieModels = [MovieModel]()
    fileprivate var currentMovieIndex = 0
    fileprivate var stop = MutableProperty<Void>()
    
    fileprivate let network: Networking
    fileprivate let movieCalls: MovieCalling
    
    public init(network: Networking, movieCalls: MovieCalling) {
        self.network = network
        self.movieCalls = movieCalls
    }
    
    fileprivate var currentMovieModel: MovieModel? {
        return movieModels.indices.contains(currentMovieIndex) ? movieModels[currentMovieIndex] : nil
    }
    
}

extension MovieViewModel: MovieViewModelModifiable {
    public func update(movies: [MovieModel], atIndex index: Int) {
        stop.value = ()
        stop = MutableProperty<Void>()
        
        self.movieModels    = movies
        currentMovieIndex   = index
        let movieModel      = currentMovieModel
        
        self._movieID.value     = movieModel?.id
        self._title.value       = movieModel?.title
        self._overView.value    = movieModel?.overview

        _image.value = nil
        
        if let movieModel = movieModel {
            _image <~ network.requestBackImage(url: movieModel.backdrop_path ?? "")
                .take(until: stop.producer.skip(first: 1))
                .map { $0 as UIImage? }
                .flatMapError { _ in SignalProducer<UIImage?, NoError>(value: nil) }
                .observe(on: UIScheduler())
            
            _cast <~ movieCalls.callCredit(movieID:String(movieModel.id))
                .take(until: stop.producer.skip(first: 1))
                .map { $0.cast.filter{$0.name != nil}.map{$0.name!}.joined(separator: ", ")}
                .flatMapError { _ in SignalProducer<String?, NoError>(value: nil) }
                .observe(on: UIScheduler())
        }
        
        
    }
}

