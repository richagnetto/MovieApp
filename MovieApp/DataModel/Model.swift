//
//  Movie.swift
//  MovieApp
//
//  Created by Richa Netto on 8/14/18.
//  Copyright © 2018 Richa Netto. All rights reserved.
//

import Foundation

struct MovieResponse: Codable {
    let results: [MovieData]?
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        results = try values.decodeIfPresent([MovieData].self, forKey: .results)
    }
    
}

struct MovieData: Codable {
    let title: String?
    let posterPath: String?
    let overview: String?
    let releaseDate: String?
    let id: Int?
    
    func releaseStringToDate() -> Date? {
        guard let releaseDateString = releaseDate else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd"
        guard let date = dateFormatter.date(from: releaseDateString) else {
            return nil
        }
        return date
    }
    
    func yearFromDate(date: Date) -> Int {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        
        return year
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case posterPath = "poster_path"
        case overview
        case releaseDate = "release_date"
        case id
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        posterPath = try values.decodeIfPresent(String.self, forKey: .posterPath)
        overview = try values.decodeIfPresent(String.self, forKey: .overview)
        releaseDate = try values.decodeIfPresent(String.self, forKey: .releaseDate)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
    }
}


struct ImageData: Codable {
    let images: Images?
    
    enum CodingKeys: String, CodingKey {
        case images
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        images = try values.decodeIfPresent(Images.self, forKey: .images)
    }
}

struct Images: Codable {
    let secureBaseURL: String?
    let posterSizes: [String]?
    
    enum CodingKeys: String, CodingKey {
        case secureBaseURL = "secure_base_url"
        case posterSizes = "poster_sizes"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        secureBaseURL = try values.decodeIfPresent(String.self, forKey: .secureBaseURL)
        posterSizes = try values.decodeIfPresent([String].self, forKey: .posterSizes)
        
    }
}




