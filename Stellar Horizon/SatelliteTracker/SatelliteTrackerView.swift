import SwiftUI
import MapKit

// MARK: - MapView (UIViewRepresentable)
struct MapView: UIViewRepresentable {
    @Binding var annotations: [MKPointAnnotation]
    @Binding var region: MKCoordinateRegion

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: true) // Karte auf die Region zentrieren
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations(annotations)

        // Aktualisiere die Region, wenn sich die Annotationen ändern
        if let firstAnnotation = annotations.first {
            let newRegion = MKCoordinateRegion(
                center: firstAnnotation.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100)
            )
            uiView.setRegion(newRegion, animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "SatelliteAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = false
                annotationView?.image = UIImage(named: "satellite")
            } else {
                annotationView?.annotation = annotation
            }

            // Pulsierungsanimation hinzufügen
            let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
            pulseAnimation.duration = 1.5
            pulseAnimation.fromValue = 0.1
            pulseAnimation.toValue = 0.12
            pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            pulseAnimation.autoreverses = true
            pulseAnimation.repeatCount = .infinity

            annotationView?.layer.add(pulseAnimation, forKey: "pulse")

            return annotationView
        }
    }
}

// MARK: - ContentView
struct SatelliteTrackerView: View {
    @State private var annotations: [MKPointAnnotation] = []
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0), // Startwert, wird später überschrieben
        span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
    )
    @State private var timer: Timer?
    @State private var selectedSatelliteID = 25544 // Standardmäßig ISS
    let satellites = [
        "ISS (25544)": 25544,
        "Hubble (20580)": 20580
    ]

    var body: some View {
        VStack {
            Picker("Satellite", selection: $selectedSatelliteID) {
                ForEach(Array(satellites.keys), id: \.self) { name in
                    Text(name).tag(satellites[name]!)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            MapView(annotations: $annotations, region: $region)
                .edgesIgnoringSafeArea(.all)
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
        .onChange(of: selectedSatelliteID) { oldValue, newValue in
            // Wenn sich die Satellitenauswahl ändert, laden Sie die neuen Koordinaten
            loadCoordinatesFromAPI()
        }
    }

    func startTimer() {
        // Timer starten, der alle 15 Sekunden die API aufruft
        timer = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: true) { _ in
            loadCoordinatesFromAPI()
        }
        // Sofort beim Start die ersten Daten laden
        loadCoordinatesFromAPI()
    }

    func stopTimer() {
        // Timer anhalten, wenn die View verschwindet
        timer?.invalidate()
        timer = nil
    }

    func loadCoordinatesFromAPI() {
        let apiKey = "LFPV7E-78BNAT-UCKXDV-5F8T"
        let urlString = "https://api.n2yo.com/rest/v1/satellite/positions/\(selectedSatelliteID)/41.702/-76.014/0/2/&apiKey=\(apiKey)"

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let positions = json?["positions"] as? [[String: Any]] {
                    DispatchQueue.main.async {
                        self.annotations = positions.compactMap { position in
                            guard let lat = position["satlatitude"] as? Double,
                                  let lon = position["satlongitude"] as? Double else {
                                return nil
                            }
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                            return annotation
                        }

                        // Zentriere die Karte auf die erste Position des Satelliten
                        if let firstAnnotation = self.annotations.first {
                            self.region = MKCoordinateRegion(
                                center: firstAnnotation.coordinate,
                                span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
                            )
                        }
                    }
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }

        task.resume()
    }
}

#Preview {
    SatelliteTrackerView()
}
let apiKey = "LFPV7E-78BNAT-UCKXDV-5F8T"
