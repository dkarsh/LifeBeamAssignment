//
//  MoviePopularTableViewCellModel.swift
//  LifeBloo
//
//  Created by Daniel Karsh on 6/3/17.
//  Copyright © 2017 Daniel Karsh. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import LifeModel

public final class MoviePopularTableViewCellModel:NSObject, MoviePopularTableViewCellModeling {
    public let id: UInt64
    public let title: String
    public let genres: String
    
    private let network: Networking
    private let previewURL: String
    private var previewImage: UIImage?

    internal init(movie: MovieModel, network: Networking, genresKeys:GenresKeys?) {
        
        id = movie.id
        title = movie.title ?? ""
        genres =  { () -> String in
            guard let genresKeys = genresKeys, let genre_ids = movie.genre_ids else {
                return ""
            }
           return genre_ids.filter{genresKeys[Int($0)] != nil}.map{genresKeys[Int($0)]!}.joined(separator: ", ")
        }()
        previewURL =  movie.poster_path ?? ""
        self.network = network
        super.init()
    }
    
    
    public func getPreviewImage() -> SignalProducer<UIImage?, NoError> {
        if let previewImage = self.previewImage {
            return SignalProducer(value: previewImage).observe(on: UIScheduler())
        }
        else {
            let imageProducer = network.requestImage(url: previewURL)
                .on(value: { [weak self] (image) in self?.previewImage = image })
                .take(until: self.reactive.lifetime.ended)
                .map { $0 as UIImage? }
                .flatMapError { _ in SignalProducer<UIImage?, NoError>(value: nil) }
            
            
            return SignalProducer(value: nil)
                .concat(imageProducer)
                .observe(on: UIScheduler())
        }
    }
}
