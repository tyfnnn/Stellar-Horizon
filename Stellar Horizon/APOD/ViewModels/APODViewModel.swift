//
//  APODViewModel.swift
//  NASA APOD
//
//  Created by Tayfun Ilker on 06.01.25.
//

import SwiftUI
import Combine

class APODViewModel: ObservableObject {
    @Published var apod: APODResponse?
    @Published var isLoading = false
    @Published var error: Error?
    
    private let apiKey = "dLhdo1rRSlZMpX1Si0g6xjFjNn2BS7cp0Wfhbzti"
    private var cancellables = Set<AnyCancellable>()
    
    func fetchAPOD() {
        isLoading = true
        let urlString = "https://api.nasa.gov/planetary/apod?api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: APODResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error
                }
            } receiveValue: { [weak self] apod in
                self?.apod = apod
            }
            .store(in: &cancellables)
    }
}

