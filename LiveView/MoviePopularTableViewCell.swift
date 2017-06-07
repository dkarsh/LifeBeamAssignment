//
//  MoviePopularTableViewCell.swift
//  LifeBloo
//
//  Created by Daniel Karsh on 6/3/17.
//  Copyright © 2017 Daniel Karsh. All rights reserved.
//

import UIKit
import LifeViewModel

internal final class MoviePopularTableViewCell: UITableViewCell {
    internal var viewModel: MoviePopularTableViewCellModeling?{
        didSet {
            titleLabel.text = viewModel?.title
            genresLabel.text = viewModel?.genres
            
            if let viewModel = viewModel {
                viewModel.getPreviewImage()
                    .take(until: self.reactive.prepareForReuse)
                    .on(value: { self.previewImageView.image = $0 })
                    .start()
            }
            else {
                previewImageView.image = nil
            }
        }
    }

    
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
}
