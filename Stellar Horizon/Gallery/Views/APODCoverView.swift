//
//  APODCoverView.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 21.02.25.
//

import SwiftUI

struct APODCoverView: View {
    let namespace: Namespace.ID
    @State private var apodData: APODResponse?
    @State private var isLoading = true
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Group {
                if let apodData = apodData {
                    if apodData.mediaType == "video" {
                        // Placeholder for video thumbnails
                        Image(systemName: "play.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: .infinity, height: 200)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black)
                    } else {
                        AsyncImage(url: URL(string: apodData.url)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            HStack {
                                Spacer()
                                LoaderView()
                                Spacer()
                            }
                        }
                    }
                } else if isLoading {
                    LoaderView()
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                }
            }
//            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 5)
            .matchedGeometryEffect(id: "APOD", in: namespace)
            
            VStack {
                Spacer()
                LinearGradient(
                    gradient: Gradient(colors: [.clear, .black.opacity(1)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
//                .frame(width: .infinity, height: 200)
            }
            
            VStack(alignment: .leading) {
                Text("NASA")
                    .font(.exo2(fontStyle: .caption))
                    .padding(.horizontal, 1)
                    .bold()
                    .clipShape(Capsule())
                
                Text("Picture of the Day")
                    .font(.exo2(fontStyle: .headline, fontWeight: .thin))
                    .padding(.bottom, 4)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            .foregroundStyle(.white)
            .padding(8)
        }
        .task {
            await fetchAPOD()
        }
    }
    
    private func fetchAPOD() async {
        isLoading = true
        defer { isLoading = false }
        
        guard let url = URL(string: "https://api.nasa.gov/planetary/apod?api_key=\(apiKeyNASA)") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            apodData = try JSONDecoder().decode(APODResponse.self, from: data)
        } catch {
            print("Error fetching APOD: \(error)")
        }
    }
}


struct APODCoverView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        APODCoverView(namespace: namespace)
    }
}
