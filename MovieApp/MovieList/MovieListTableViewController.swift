//
//  ViewController.swift
//  MovieApp
//
//  Created by Richa Netto on 8/13/18.
//  Copyright © 2018 Richa Netto. All rights reserved.
//

import UIKit

class MovieListTableViewController: UIViewController {

    @IBOutlet weak var movieListTableView: UITableView!
    var movieData: [MovieData] = []
    var baseURL: String?
    var posterSize: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieListTableView.register(UINib(nibName: "MovieListTableViewCell", bundle: Bundle(for: MovieListTableViewCell.self)), forCellReuseIdentifier: "MovieListTableViewCell")
        let footerView = UIView()
        movieListTableView.tableFooterView = footerView
        movieListTableView.backgroundColor = UIColor.black
    }

    func getPosterImage(baseURL: String, posterSize: String, posterPath: String) -> UIImage {
        let imageURLString = baseURL + posterSize + posterPath
        
        guard let imageURL = URL(string: imageURLString),
            let data = try? Data(contentsOf: imageURL),
            let posterImage = UIImage(data: data) else {
                return UIImage(named: "default_movie")!
        }
        
        return posterImage
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension MovieListTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListTableViewCell", for: indexPath) as! MovieListTableViewCell
        let movieItem = movieData[indexPath.row]
        if let releaseDate = movieItem.releaseStringToDate() {
            cell.movieReleaseDateLabel.text = "\(movieItem.yearFromDate(date: releaseDate))"
        } else {
            cell.movieReleaseDateLabel.text = ""
        }
        cell.movieNameLabel.text = movieItem.title
        cell.movieDescriptionLabel.text = movieItem.overview
        
        if let baseURL = baseURL, let posterSize = posterSize, let posterPath = movieItem.posterPath {
            cell.moviePosterImageView.image = getPosterImage(baseURL: baseURL, posterSize: posterSize, posterPath: posterPath)
        } else {
            cell.moviePosterImageView.image = UIImage(named: "default_movie")!
        }
          
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}
