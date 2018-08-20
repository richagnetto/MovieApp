//
//  MovieListTableViewCell.swift
//  MovieApp
//
//  Created by Richa Netto on 8/13/18.
//  Copyright © 2018 Richa Netto. All rights reserved.
//

import Foundation
import UIKit

class MovieListTableViewCell: UITableViewCell {
    
    static let identifier = "MovieListTableViewCell"
    
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieReleaseDateLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.black
        moviePosterImageView.image = UIImage(named: "movie_test")
    }
}
