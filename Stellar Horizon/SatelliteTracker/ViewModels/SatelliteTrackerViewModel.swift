//
//  SatelliteTrackerViewModel.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 21.02.25.
//

import SwiftUI
import MapKit

@MainActor
@Observable
class SatelliteTrackerViewModel: ObservableObject {
    var annotations: [MKPointAnnotation] = []
    var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
    )
    var selectedSatelliteID = 25544 // Default to ISS
    
    private var timer: Timer?
    private let apiKey = "LFPV7E-78BNAT-UCKXDV-5F8T"
    
    func startTracking() {
        stopTracking()
        timer = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: true) { [weak self] _ in
            Task { await self?.loadCoordinates() }
        }
        Task { await loadCoordinates() }
    }
    
    func stopTracking() {
        timer?.invalidate()
        timer = nil
    }
    
    func loadCoordinates() async {
        let urlString = "https://api.n2yo.com/rest/v1/satellite/positions/\(selectedSatelliteID)/41.702/-76.014/0/2/&apiKey=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(SatelliteResponse.self, from: data)
            
            updateAnnotations(from: response.positions)
        } catch {
            print("Error fetching satellite data: \(error)")
        }
    }
    
    private func updateAnnotations(from positions: [SatellitePosition]) {
        self.annotations = positions.map { position in
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(
                latitude: position.satlatitude,
                longitude: position.satlongitude
            )
            return annotation
        }
        
        if let firstPosition = positions.first {
            self.region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: firstPosition.satlatitude,
                    longitude: firstPosition.satlongitude
                ),
                span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
            )
        }
    }
}
