//
//  Country.swift
//  LocationFinder
//
//  Created by Hari krishna on 28/04/23.
//

import Foundation

struct Country: Codable, Hashable {
    let name: String
    let code: String
    let range: String
    
    static var none: Country {
        Country(name: "Select Country", code: "XX", range: "")
    }
}
