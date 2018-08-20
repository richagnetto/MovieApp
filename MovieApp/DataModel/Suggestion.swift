//
//  SuggestionList.swift
//  MovieApp
//
//  Created by Richa Netto on 8/18/18.
//  Copyright © 2018 Richa Netto. All rights reserved.
//

import Foundation
import RealmSwift

class Suggestion: Object {
    
//    @objc dynamic var searchString = ""
    let suggestionList = List<String>()
    
}
