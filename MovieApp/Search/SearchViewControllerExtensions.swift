//
//  SearchHelper.swift
//  MovieApp
//
//  Created by Richa Netto on 8/19/18.
//  Copyright © 2018 Richa Netto. All rights reserved.
//

import Foundation
import UIKit

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        suggestionListTableView.isHidden = true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.isEnabled = true
            cancelButton.tintColor = UIColor.white
        }
        self.suggestionListTableView.isHidden = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        suggestionListTableView.isHidden = true
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.isEnabled = false
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        activityIndicator.startAnimating()
        movieSearchBar.endEditing(true)
        
        guard let searchString = movieSearchBar.text else {
            return
        }
        
        if searchString.trimmingCharacters(in: .whitespaces).isEmpty  {
            showAlertWith(title: "Invalid Search", message: "Please enter a valid search string.")
            activityIndicator.stopAnimating()
            movieSearchBar.text = ""
            return
        }
        performSearch(searchString: searchString)
        
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "suggestionListTableViewCell")
        cell?.textLabel?.textColor = UIColor.white
        cell?.backgroundColor = UIColor.black
        cell?.textLabel?.text = suggestionArray[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSearch(searchString: suggestionArray[indexPath.row])
        movieSearchBar.text = suggestionArray[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}
