//
//  MovieViewController.swift
//  LifeBloo
//
//  Created by Daniel Karsh on 6/5/17.
//  Copyright © 2017 Daniel Karsh. All rights reserved.
//

import UIKit

import ReactiveSwift
import LifeViewModel

public final class MovieViewController: UIViewController {
    
    public var viewModel: MovieViewModeling?
    public override func viewDidLoad() {
        super.viewDidLoad()
        if let viewModel = viewModel {
            viewModel.image.producer
                .on(value: { self.imageView.image = $0 })
                .start()
            viewModel.title.producer
                .on(value: { self.title = $0 })
                .start()
            viewModel.overView.producer
                .on(value: { self.overviewTextView.text = $0 })
                .start()
            viewModel.cast.producer
                .on(value: { self.castTextView.text = $0 })
                .start()
            
            viewModel.errorMessage.producer
                .on(value: { errorMessage in
                    if let errorMessage = errorMessage {
                        self.displayErrorMessage(errorMessage)
                    }
                })
                .start()
        }
        
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        castTextView.text = ""
    }
    
    fileprivate func displayErrorMessage(_ errorMessage: String) {
        let title = "ops"
        let dismissButtonText = "Retry"
        let message = errorMessage
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: dismissButtonText, style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
//            self.viewModel?.startFetch()
            
        })
        self.present(alert, animated: true, completion: nil)
    }

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var castTextView: UITextView!
}
