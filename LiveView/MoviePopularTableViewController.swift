//
//  MoviePopularTableViewController.swift
//  LifeBloo
//
//  Created by Daniel Karsh on 6/3/17.
//  Copyright © 2017 Daniel Karsh. All rights reserved.
//

import UIKit
import LifeViewModel

public final class MoviePopularTableViewController: UITableViewController {

    fileprivate var autoSearchStarted = false
    @IBOutlet var footerView: UIView!
    @IBOutlet weak var searchingIndicator: UIActivityIndicatorView!
    
    public var viewModel: MoviePopularTableViewModeling? {
        didSet {
            if let viewModel = viewModel {
                
                viewModel.cellModels.producer
                    .on(value: { _ in self.tableView.reloadData() })
                    .start()
                
                // Display the at the center of the screen if the table is empty.
                
                viewModel.searching.producer
                    .on(value: { searching in
                        if searching {
                            
                            self.footerView.frame.size.height = viewModel.cellModels.value.isEmpty
                                ? self.tableView.frame.size.height + self.tableView.contentOffset.y : 44.0
                            
                            self.tableView.tableFooterView = self.footerView
                            self.searchingIndicator.startAnimating()
                        }
                        else {
                            self.tableView.tableFooterView = nil
                            self.searchingIndicator.stopAnimating()
                        }
                    })
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
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !autoSearchStarted {
            autoSearchStarted = true
            viewModel?.startFetch()
        }
    }
    
    fileprivate func displayErrorMessage(_ errorMessage: String) {
        let title = "ops"
        let dismissButtonText = "Retry"
        let message = errorMessage
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: dismissButtonText, style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
            self.viewModel?.startFetch()
            
        })
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: UITableViewDataSource
extension MoviePopularTableViewController {
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let viewModel = viewModel {
            return viewModel.cellModels.value.count
        }
        return 0
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MoviePopularTableViewCell
        cell.viewModel = viewModel.map { $0.cellModels.value[indexPath.row] }
        return cell
    }
    
    
    public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let viewModel = viewModel , indexPath.row > viewModel.cellModels.value.count - 10 {
                viewModel.loadNextPage.apply(()).start()
        }
    }

}

// MARK: - UITableViewDelegate
extension MoviePopularTableViewController {
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.selectCellAtIndex(indexPath.row)
        performSegue(withIdentifier: "MovieViewControllerSegue", sender: self)
    }
}

