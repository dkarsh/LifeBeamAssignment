//
//  MoviePopularTableViewCellSpec.swift
//  LifeBloo
//
//  Created by Daniel Karsh on 6/4/17.
//  Copyright © 2017 Daniel Karsh. All rights reserved.
//

import Quick
import Nimble

import ReactiveSwift
import LifeViewModel
@testable import LiveView

class MoviePopularTableViewCellSpec: QuickSpec {
    
    class MockViewModel: MoviePopularTableViewCellModeling {
        let id: UInt64 = 0
        let title: String = ""
        let genres: String = ""
        
        var getPreviewImageStarted = false
        
        func getPreviewImage() -> SignalProducer<UIImage?, NoError> {
            return SignalProducer<UIImage?, NoError> { observer, _ in
                self.getPreviewImageStarted = true
                observer.sendCompleted()
            }
        }
        
    }
    
    override func spec() {
        it("starts getPreviewImage signal producer when its view model is set.") {
            let viewModel = MockViewModel()
            let view = createTableViewCell()
            
            expect(viewModel.getPreviewImageStarted) == false
            view.viewModel = viewModel
            expect(viewModel.getPreviewImageStarted) == true
        }
    }
}

private func createTableViewCell() -> MoviePopularTableViewCell {
    let bundle = Bundle(for: MoviePopularTableViewCell.self)
    let storyboard = UIStoryboard(name: "Main", bundle: bundle)
    let tableViewController = storyboard
        .instantiateViewController(withIdentifier: "MoviePopularTableViewController")
        as! MoviePopularTableViewController
    return tableViewController.tableView
        .dequeueReusableCell(withIdentifier: "MovieCell")
        as! MoviePopularTableViewCell
}
