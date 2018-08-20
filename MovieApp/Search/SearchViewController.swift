//
//  SearchViewController.swift
//  MovieApp
//
//  Created by Richa Netto on 8/14/18.
//  Copyright © 2018 Richa Netto. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class SearchViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var suggestionListTableView: UITableView!
    
    let realm = try! Realm()
    var suggestionArray = [String]()
    
    override func viewDidLoad() {
        configureUI()
        if realm.objects(Suggestion.self).first == nil {
            instantiateSuggestionObject()
        }
        guard let suggestedObject = realm.objects(Suggestion.self).first else {
            return
        }
        suggestionArray = Array(suggestedObject.suggestionList)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func configureUI() {
        activityIndicator.hidesWhenStopped = true
        suggestionListTableView.isHidden = true
        view.backgroundColor = UIColor.black
        suggestionListTableView.backgroundColor = UIColor.black
        let searchTextField = movieSearchBar.value(forKey: "searchField") as? UITextField
        searchTextField?.textColor = UIColor.white
    }
    
    func performSearch(searchString: String) {
        MovieNetworkManager.shared.fetchImageData { (imageData, error) in
            guard let imageData = imageData,
            let baseURL = imageData.secureBaseURL,
            let posterSizes = imageData.posterSizes else {
                return
            }
            
            let posterSize = posterSizes[0]
            
            MovieNetworkManager.shared.fetchMovieData(searchString: searchString) { (movieData, error) in
                
                guard let movieData = movieData else {
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.showAlertWith(title: "Error Fetching Data", message: "Please try again.")
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    if movieData.count < 1 {
                        self.showAlertWith(title: "No Results", message: "There were no search results found. Please try again.")
                    } else {
                        self.showSearchResults(movieData: movieData, baseURL: baseURL, posterSize: posterSize)
                        self.populateSuggestionList(searchString: searchString)
                    }
                }
            }
        }
    }
    
    func instantiateSuggestionObject() {
        let object = realm.objects(Suggestion.self)
        if object.isEmpty {
            let suggestionObject = Suggestion()
            try! realm.write {
                realm.add(suggestionObject)
            }
        }
    }
    
    func populateSuggestionList(searchString: String) {
        
        guard let suggestionObject = realm.objects(Suggestion.self).first else {
            return
        }
        
        try! realm.write {
            if suggestionObject.suggestionList.count >= 10 {
                suggestionObject.suggestionList.removeLast()
            }
            suggestionObject.suggestionList.insert(searchString, at: 0)
        }
        suggestionArray = Array(suggestionObject.suggestionList)
        suggestionListTableView.reloadData()

    }

    func showSearchResults(movieData: [MovieData], baseURL: String, posterSize: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let movieListTableViewController = storyboard.instantiateViewController(withIdentifier: "movieListVC") as! MovieListTableViewController
        movieListTableViewController.movieData = movieData
        movieListTableViewController.baseURL = baseURL
        movieListTableViewController.posterSize = posterSize
        self.navigationController?.pushViewController(movieListTableViewController, animated: true)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            suggestionListTableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            suggestionListTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }
}

extension SearchViewController {
    func showAlertWith(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
