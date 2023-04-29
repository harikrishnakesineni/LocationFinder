//
//  ContentView.swift
//  LocationFinder
//
//  Created by Hari krishna on 28/04/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationService = LocationService()
    @State private var postalCode = ""
    @State var selectedCountry: Country = Country.none
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Pick a country", selection: $selectedCountry) {
                    ForEach(locationService.countries, id: \.self) { country in
                        Text(country.name).tag(country)
                    }
                }
                .buttonStyle(.bordered)
                
                if selectedCountry != .none {
                    
                    Text(selectedCountry.range)
                    Text("Postal Code/Zip Range")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top)
                    
                    TextField("Postal code", text: $postalCode)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 100)
                    
                    
                        
                    Button {
                        Task {
                           try await locationService.getLocation(countryCode: selectedCountry.code,postalCode: postalCode)
                        }
                    } label: {
                        Text("Set Location")
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(postalCode.isEmpty)
                    
                    if let errorInfo = locationService.errorMessage {
                        Text(errorInfo)
                            .foregroundColor(.red)
                    }
                    
                    if let locationInfo = locationService.locationInfo {
                        Text(locationInfo.placeName)
                        Text(locationInfo.state)
                        if locationService.errorMessage == nil {
                            MapView(longitude: locationInfo.longitude, latitude: locationInfo.latitude)
                                .padding()
                        }
                    }
                    
                }
                if locationService.locationInfo == nil {
                    Image("locationFinder")
                }
                Spacer()
                
            }
            .navigationTitle("Location Finder")
            .onChange(of: selectedCountry) { _ in
                postalCode = ""
            }
            .onChange(of: postalCode) { _ in
                locationService.resetLocation()
            }
            
        }
        .padding()
        .task {
            do {
                try await locationService.loadCountries()
            } catch {
                print(error.localizedDescription)
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
