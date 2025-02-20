//
//  SatelliteModel.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 20.02.25.
//

import Foundation

struct SatellitePosition: Codable {
    let satlatitude: Double
    let satlongitude: Double
    let timestamp: Int
}

struct SatelliteResponse: Codable {
    let info: SatelliteInfo
    let positions: [SatellitePosition]
}

struct SatelliteInfo: Codable {
    let satid: Int
    let satname: String
}

struct Satellite: Identifiable {
    let id: Int
    let name: String
    
    static let available: [Satellite] = [
        Satellite(id: 25544, name: "ISS"),
        Satellite(id: 20580, name: "Hubble")
    ]
}
