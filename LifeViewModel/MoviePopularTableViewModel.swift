//
//  ImageSearchTableViewModel.swift
//  LifeBloo
//
//  Created by Daniel Karsh on 6/3/17.
//  Copyright © 2017 Daniel Karsh. All rights reserved.
//

import LifeModel
import ReactiveSwift

public typealias GenresKeys = [Int:String]

public final class MoviePopularTableViewModel: MoviePopularTableViewModeling {
    
    public var cellModels:  Property<[MoviePopularTableViewCellModeling]> { return Property(_cellModels)}
    public var searching:   Property<Bool> { return Property(_searching) }
    public var errorMessage:Property<String?> { return Property(_errorMessage) }
    public var genresKeys:GenresKeys? = nil
    
    
    fileprivate let _cellModels = MutableProperty<[MoviePopularTableViewCellModeling]>([])
    fileprivate let _searching  = MutableProperty<Bool>(false)
    fileprivate let _errorMessage = MutableProperty<String?>(nil)
   
    
    /// Accepts property injection.
    public var movieDetailViewModel: MovieViewModelModifiable?
    
    public var loadNextPage: Action<(), (), NoError> {
        return Action(enabledIf: nextPageLoadable) { _ in
            return SignalProducer { observer, disposable in
                if let observer = self.npTrigger.value {
                    self._searching.value = true
                    observer.value = ()
                }
            }
        }
    }
    
    fileprivate var nextPageLoadable: Property<Bool> {
        return Property(
            initial: false,
            then: searching.producer
                .combineLatest(with: npTrigger.producer)
                .map { searching, trigger in !searching && trigger != nil })
    }
    
    fileprivate let npTrigger = MutableProperty<MutableProperty<Void>?>(nil) // SignalProducer buffer
    fileprivate let movieCalls: MovieCalling
    fileprivate let network: Networking
    fileprivate var fetchedMovies = [MovieModel]()
    
    public init(movieCalls: MovieCalling, network: Networking) {
        self.movieCalls = movieCalls
        self.network = network
    }
    
    private func startFetchGenres() {
        func installGen( _ respGenres : ResponseGenres) -> [Int:String] {
            var tkey : [Int:String] = [:]
            for gen in respGenres.genres {
                tkey[gen.id]=gen.name
            }
            return tkey
        }
        
        movieCalls.callGenres()
            .startWithResult { (result) in
                switch result{
                case let .success(resGenres):
                    self.genresKeys = installGen(resGenres)
                case let .failure(error):
                    self._errorMessage.value = error.description
                }
        }
    }
    
    
    public func startFetch() {
        self._cellModels.value = []
        self.genresKeys = [:]
        
        self.startFetchGenres()
        
        func toCellModel(_ movie: MovieModel) -> MoviePopularTableViewCellModeling {
            return MoviePopularTableViewCellModel(movie: movie, network: self.network, genresKeys:self.genresKeys) as MoviePopularTableViewCellModel
        }
        
        _searching.value = true
        npTrigger.value = MutableProperty()
        let trigger = npTrigger.value!.producer.skip(first: 1)
        
        movieCalls.callPopular(nextPageTrigger: trigger)
            .map { response in
                (response.movies, response.movies.map { toCellModel($0) })
            }
            .observe(on: UIScheduler())
            .on(value: { movies, cellModels in
                self.fetchedMovies += movies
                self._cellModels.value += cellModels
                self._searching.value = false
            })
            .on(failed: { error in
                self._errorMessage.value = error.description
            })
            .on(event: { event in
                switch event {
                case .completed, .failed, .interrupted:
                    self.npTrigger.value = nil
                    self._searching.value = false
                default:
                    break
                }
            })
            .start()
    }
    
    public func selectCellAtIndex(_ index: Int) {
        movieDetailViewModel?.update(movies:fetchedMovies, atIndex: index)
    }
}
