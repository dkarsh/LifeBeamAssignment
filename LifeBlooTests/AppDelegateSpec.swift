//
//  AppDelegateSpec.swift
//  LifeBloo
//
//  Created by Daniel Karsh on 6/3/17.
//  Copyright © 2017 Daniel Karsh. All rights reserved.
//


import Quick
import Nimble
import Swinject
import SwinjectStoryboard
import LifeModel
import LifeViewModel
import LiveView

@testable import LifeBloo

class AppDelegateSpec: QuickSpec {
    override func spec() {
        var container: Container!
        beforeEach {
            container = AppDelegate().container
        }
        
        describe("Container") {
            it("resolves every service type.") {
                // Models
                expect(container.resolve(Networking.self)).notTo(beNil())
                expect(container.resolve(MovieCalling.self)).notTo(beNil())
                
                // ViewModels
                expect(container.resolve(MoviePopularTableViewModeling.self)).notTo(beNil())
                expect(container.resolve(MovieViewModelModifiable.self)).notTo(beNil())
                expect(container.resolve(MovieViewModeling.self)).notTo(beNil())
            }
            it("injects view models to views.") {
                let bundle = Bundle(for: MoviePopularTableViewController.self)
                let storyboard = SwinjectStoryboard.create(name: "Main", bundle: bundle, container: container)
                let moviePopularTableViewController = storyboard.instantiateViewController(withIdentifier: "MoviePopularTableViewController")
                    as! MoviePopularTableViewController
                let movieViewController = storyboard.instantiateViewController(withIdentifier: "MovieViewController")
                    as! MovieViewController
                
                expect(moviePopularTableViewController.viewModel).notTo(beNil())
                expect(movieViewController.viewModel).notTo(beNil())
            }
        }
    }
}
