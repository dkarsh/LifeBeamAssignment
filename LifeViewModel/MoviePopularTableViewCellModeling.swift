//
//  MoviePopularTableViewCellModeling.swift
//  LifeBloo
//
//  Created by Daniel Karsh on 6/3/17.
//  Copyright © 2017 Daniel Karsh. All rights reserved.
//


import ReactiveSwift

import enum Result.NoError
public typealias NoError = Result.NoError

public protocol MoviePopularTableViewCellModeling {
    var id: UInt64 { get }
    var title: String { get }
    var genres: String { get }
    
    func getPreviewImage() -> SignalProducer<UIImage?, NoError>
}
