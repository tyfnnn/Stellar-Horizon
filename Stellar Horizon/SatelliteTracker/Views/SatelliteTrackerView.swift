import SwiftUI
import MapKit

struct SatelliteTrackerView: View {
    @State private var viewModel = SatelliteTrackerViewModel()
    
    var body: some View {
        VStack {
            Picker("Satellite", selection: $viewModel.selectedSatelliteID) {
                ForEach(Satellite.available) { satellite in
                    Text("\(satellite.name) (\(satellite.id))").tag(satellite.id)
                }
            }
            .pickerStyle(.palette)
            .padding()
            
            MapView(annotations: $viewModel.annotations, region: $viewModel.region)
                .edgesIgnoringSafeArea(.all)
        }
        .background(Color("bgColors"))
        .onAppear {
            viewModel.startTracking()
        }
        .onDisappear {
            viewModel.stopTracking()
        }
        .onChange(of: viewModel.selectedSatelliteID) { _, _ in
            Task {
                await viewModel.loadCoordinates()
            }
        }
    }
}



#Preview {
    SatelliteTrackerView()
}
let apiKey = "LFPV7E-78BNAT-UCKXDV-5F8T"
