//
//  File.swift
//  LifeBloo
//
//  Created by Daniel Karsh on 6/3/17.
//  Copyright © 2017 Daniel Karsh. All rights reserved.
//

import Quick
import Nimble

import ReactiveSwift
import LifeViewModel

@testable import LiveView

class MoviePopularTableViewControllerSpec: QuickSpec {
    // MARK: Mock
    class MockViewModel: MoviePopularTableViewModeling {
        let cellModels = Property(MutableProperty<[MoviePopularTableViewCellModeling]>([]))
        let searching = Property(value: false)
        let errorMessage = Property<String?>(value: nil)
        var loadNextPage: Action<(), (), NoError> = Action { SignalProducer.empty }
        var startSearchCallCount = 0
        
        func startFetch() {
            startSearchCallCount += 1
        }
        
        func selectCellAtIndex(_ index: Int) {
        }
    }
    
    // MARK: Spec
    override func spec() {
        it("starts searching images when the view is about to appear at the first time.") {
            let viewModel = MockViewModel()
            let storyboard = UIStoryboard(
                name: "Main",
                bundle: Bundle(for: MoviePopularTableViewController.self))
            let viewController = storyboard.instantiateViewController(
                withIdentifier: "MoviePopularTableViewController")
                as! MoviePopularTableViewController
            
            viewController.viewModel = viewModel
            expect(viewModel.startSearchCallCount) == 0
            viewController.viewWillAppear(true)
            expect(viewModel.startSearchCallCount) == 1
            viewController.viewWillAppear(true)
            expect(viewModel.startSearchCallCount) == 1
        }
    }
}
