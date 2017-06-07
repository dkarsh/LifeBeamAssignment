//
//  MoviePopularityTableViewModeling.swift
//  LifeBloo
//
//  Created by Daniel Karsh on 6/3/17.
//  Copyright © 2017 Daniel Karsh. All rights reserved.
//

import Foundation
import ReactiveSwift

public protocol MoviePopularTableViewModeling {
    
    var cellModels:     Property<[MoviePopularTableViewCellModeling]> { get }
    var searching:      Property<Bool> { get }
    var errorMessage:   Property<String?> { get }
    var loadNextPage:   Action<(), (), NoError> { get }
    
    func selectCellAtIndex(_ index: Int)
    func startFetch()
}
