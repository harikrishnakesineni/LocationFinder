//
//  LocationService.swift
//  LocationFinder
//
//  Created by Hari krishna on 28/04/23.
//

import Foundation

enum LoadingErrors: Error {
    case invalidUrl
    case errorLoading
    case loadingFailed
    case rangeError
}

class LocationService: ObservableObject {
    @Published var countries: [Country] = []
    @Published var locationInfo: LocationInfo?
    @Published var errorMessage: String?
    
    let baseUrl = "https://api.zippopotam.us"
    
    @MainActor
    func loadCountries() async throws {
        guard let url = Bundle.main.url(forResource: "Countries", withExtension: "json") else {
            throw LoadingErrors.invalidUrl
        }
        
        guard let data = try? Data(contentsOf: url) else {
            throw LoadingErrors.errorLoading
        }
        
        do {
            countries = try JSONDecoder().decode([Country].self, from: data)
            countries.insert(Country.none, at: 0)
        } catch {
            throw LoadingErrors.loadingFailed
        }
        
    }
    
    @MainActor
    func getLocation(countryCode: String, postalCode: String) async throws {
        
        guard let addedUrl = (baseUrl  + "/" + countryCode + "/" + postalCode).trimmingCharacters(in: .whitespacesAndNewlines)
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: addedUrl) else {
             errorMessage = "Incorrect url"
             throw LoadingErrors.invalidUrl
            
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                errorMessage = "Invalid response"
                throw LoadingErrors.loadingFailed
            }
            let location = try JSONDecoder().decode(Location.self, from: data)
            guard let locationPlace = location.places.first else {
                errorMessage = "Could not find location"
                throw LoadingErrors.errorLoading
            }
            
            let range = -180.0...180.0
            guard range.contains(Double(locationPlace.latitude)!), range.contains(Double(locationPlace.latitude)!) else {
                errorMessage = "Not within the range"
                throw LoadingErrors.rangeError
            }
            
            self.locationInfo = LocationInfo(placeName: locationPlace.placeName, state: locationPlace.state, latitude: Double(locationPlace.latitude) ?? 0, longitude: Double(locationPlace.longitude) ?? 0)
            
        } catch {
            errorMessage = error.localizedDescription
            throw LoadingErrors.errorLoading
        }
        
        
        
    }
        
    func resetLocation() {
        errorMessage = nil
        locationInfo = nil
    }
    
    
}
