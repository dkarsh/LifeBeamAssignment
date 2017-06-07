//
//  MovieViewModeling.swift
//  LifeBloo
//
//  Created by Daniel Karsh on 6/5/17.
//  Copyright © 2017 Daniel Karsh. All rights reserved.
//
import LifeModel
import ReactiveSwift

public protocol MovieViewModeling {
    
    var movieID:    Property<UInt64?> { get }
    var title:      Property<String?> { get }
    var overView:   Property<String?> { get }
    var cast:       Property<String?> { get }
    var image:      Property<UIImage?> { get }
    var errorMessage:Property<String?> { get }
    
}


public protocol MovieViewModelModifiable: MovieViewModeling {
    func update(movies: [MovieModel], atIndex index: Int)
}
