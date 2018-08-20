//
//  MovieAppTests.swift
//  MovieAppTests
//
//  Created by Richa Netto on 8/13/18.
//  Copyright © 2018 Richa Netto. All rights reserved.
//

import XCTest
@testable import MovieApp

class MovieAppTests: XCTestCase {
    
    let service = MovieNetworkManager()
    let searchString = "Harry Potter"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetImageData() {
        let expect = expectation(description: "Image data is returned")
        service.fetchImageData { (images, error) in
            if images != nil {
                expect.fulfill()
            }
        }
        wait(for: [expect], timeout: 30)
    }
    
    func testGetMovieData() {
        let expect = expectation(description: "Movie data is returned")
        service.fetchMovieData(searchString: searchString) { (movies, error) in
            if movies != nil {
                expect.fulfill()
            }
        }
        wait(for: [expect], timeout: 30)
    }
    
    func testMovieDataParsing() {
        let movieDataJSON = Data(filename: "MovieResponse", ext: "json")
        let decoder = JSONDecoder()
        if let movieData = try? decoder.decode(MovieResponse.self, from: movieDataJSON) {
            if let movies = movieData.results {
                for movie in movies {
                    XCTAssertNotNil(movie.overview)
                    XCTAssertNotNil(movie.title)
                    XCTAssertNotNil(movie.releaseDate)
                    XCTAssertNotNil(movie.posterPath)
                }
            }
        } else {
            XCTFail("Failed to decode Movie Data Array")
        }
    }
    
    func testImageDataParsing() {
        let expectedBaseURL = "https://image.tmdb.org/t/p/"
        let expectedPosterSize = "w92"
        let imageDataJSON = Data(filename: "ImageData", ext: "json")
        let decoder = JSONDecoder()
        if let imageData = try? decoder.decode(ImageData.self, from: imageDataJSON) {
            let image = imageData.images
            if let baseURL = image?.secureBaseURL {
                XCTAssertEqual(baseURL, expectedBaseURL)
            }
            if let posterSizes = image?.posterSizes {
                XCTAssertEqual(posterSizes[0], expectedPosterSize)
            }
        } else {
            XCTFail("Failed to decode Image Data Array")
        }
    }
}
