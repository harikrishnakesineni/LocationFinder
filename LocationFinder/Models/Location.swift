//
//  Location.swift
//  LocationFinder
//
//  Created by Hari krishna on 28/04/23.
//

import Foundation

struct Location: Codable {
    var postCode: String
    var country: String
    var countryAbbreviation: String
    var places: [Place]
    
    enum CodingKeys: String, CodingKey {
        case postCode = "post code"
        case country
        case countryAbbreviation = "country abbreviation"
        case places
    }
    
}


struct Place: Codable {
    var placeName: String
    var longitude: String
    var state: String
    var stateAbbreviation: String
    var latitude: String
    
    enum CodingKeys: String, CodingKey {
        case placeName = "place name"
        case longitude
        case state
        case stateAbbreviation = "state abbreviation"
        case latitude
        
    }
}
