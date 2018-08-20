//
//  TestHelper.swift
//  MovieAppTests
//
//  Created by Richa Netto on 8/19/18.
//  Copyright © 2018 Richa Netto. All rights reserved.
//

import Foundation

private final class DummyClass { }

extension Bundle {
    
    static var testBundle: Bundle {
        return Bundle.init(for: DummyClass.self)
    }
}

extension Data {
    init(filename: String,  ext: String) {
        guard let url = Bundle.testBundle.url(forResource: filename, withExtension: ext)
            else { fatalError() }
        
        try! self.init(contentsOf: url)
    }
}
