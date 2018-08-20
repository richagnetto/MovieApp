//
//  MovieServiceManager.swift
//  MovieApp
//
//  Created by Richa Netto on 8/17/18.
//  Copyright © 2018 Richa Netto. All rights reserved.
//

import Foundation

public class MovieNetworkManager {
    
    static let shared = MovieNetworkManager()
    
    public init() { }
    
    let baseURL = "https://api.themoviedb.org/3/"
    let apiKey = "2696829a81b1b5827d515ff121700838"
    let searchEndpoint = "search/movie"
    let imageEndpoint = "configuration"
    
    enum BackendError: Error {
        case urlError(reason: String)
        case objectSerialization(reason: String)
    }
    
    func fetchMovieData(searchString: String, completionHandler: @escaping ([MovieData]?, Error?) -> Void) {
        var formattedSearchString = String()
        if searchString.contains(" ") {
            formattedSearchString = searchString.replacingOccurrences(of: " ", with: "+")
        } else {
            formattedSearchString = searchString
        }
        let apiURL = baseURL + searchEndpoint + "?api_key=\(apiKey)" + "&language=en-US" + "&query=\(formattedSearchString)"
        guard let url = URL(string: apiURL) else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            completionHandler(nil, error)
            return
        }
        let urlRequest = URLRequest(url: url)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                completionHandler(nil, error)
                return
            }
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let movieResponse = try decoder.decode(MovieResponse.self, from: responseData)
                completionHandler(movieResponse.results, nil)
            } catch {
                print("error trying to convert data to JSON")
                print(error)
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
    
    func fetchImageData(completionHandler: @escaping (Images?, Error?) -> Void) {
        let apiURL = baseURL + imageEndpoint + "?api_key=\(apiKey)"
        guard let url = URL(string: apiURL) else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            completionHandler(nil, error)
            return
        }
        let urlRequest = URLRequest(url: url)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                completionHandler(nil, error)
                return
            }
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let imageResponse = try decoder.decode(ImageData.self, from: responseData)
                completionHandler(imageResponse.images, nil)
            } catch {
                print("error trying to convert data to JSON")
                print(error)
                completionHandler(nil, error)
            }
        }
        task.resume()
    }

}
