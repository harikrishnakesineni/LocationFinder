//
//  MapView.swift
//  LocationFinder
//
//  Created by Hari krishna on 29/04/23.
//

import SwiftUI
import MapKit

struct MapView: View {
    var longitude: Double
    var latitude: Double
    @State private var region: MKCoordinateRegion
    
    init(longitude: Double, latitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    }
    
    var body: some View {
        Map(coordinateRegion: $region)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(longitude: 72.723494, latitude: -40.29393)
    }
}
