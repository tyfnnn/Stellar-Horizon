//
//  TemperatureAnomaly.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 19.03.25.
//

import Foundation

// Model to represent temperature anomaly data point
struct TemperatureAnomaly: Identifiable {
    var id = UUID()
    var date: Date
    var anomaly: Double
    var uncertainty: Double
    var dataType: DataType
    
    enum DataType: String, CaseIterable {
        case air = "Air Temperature"
        case water = "Water Temperature"
    }
}
