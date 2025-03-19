//
//  TemperatureAnomaly.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 19.03.25.
//

import SwiftUI

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

// View model to handle data loading and processing
@Observable
class TemperatureViewModel {
    var temperatureData: [TemperatureAnomaly] = []
    var selectedType: TemperatureAnomaly.DataType = .air
    var selectedTimeSpan: TimeSpan = .annual
    var isLoading = false
    var minYear: Int = 1950
    var maxYear: Int = 2030
    var yearRange: ClosedRange<Int> = 1950...2024
    
    enum TimeSpan: String, CaseIterable {
        case monthly = "Monthly"
        case annual = "Annual"
    }
    
    // Load data from file
    func loadData() {
        isLoading = true
        temperatureData = []
        
        if let fileURL = Bundle.main.url(forResource: "Land_and_Ocean_complete", withExtension: "txt") {
            do {
                let contents = try String(contentsOf: fileURL, encoding: .utf8)
                let lines = contents.components(separatedBy: .newlines)
                
                // Parse both sections
                parseTemperatureSection(lines: lines,
                                       startMarker: "Global Average Temperature Anomaly with Sea Ice Temperature Inferred from Air Temperatures",
                                       dataType: .air)
                
                parseTemperatureSection(lines: lines,
                                       startMarker: "Global Average Temperature Anomaly with Sea Ice Temperature Inferred from Water Temperatures",
                                       dataType: .water)
                
                // Sort data by date
                temperatureData.sort { $0.date < $1.date }
                
                // Find min and max years
                if let firstDate = temperatureData.first?.date,
                   let lastDate = temperatureData.last?.date {
                    let calendar = Calendar.current
                    minYear = calendar.component(.year, from: firstDate)
                    maxYear = calendar.component(.year, from: lastDate)
                    yearRange = minYear...maxYear
                }
            } catch {
                print("Error reading file: \(error)")
            }
        }
        
        isLoading = false
    }

    private func parseTemperatureSection(lines: [String], startMarker: String, dataType: TemperatureAnomaly.DataType) {
        var foundStartMarker = false
        var foundDataSection = false
        
        for line in lines {
            // Look for the section marker
            if line.contains(startMarker) {
                foundStartMarker = true
                continue
            }
            
            // Find the data section start
            if foundStartMarker && line.contains("Year, Month,") {
                foundDataSection = true
                continue
            }
            
            // Skip lines until we find the data section
            if !foundDataSection {
                continue
            }
            
            // Skip empty lines
            let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.isEmpty || trimmed == " " {
                continue
            }
            
            // If we hit the second data section
            if line.contains("Global Average Temperature Anomaly with Sea Ice Temperature Inferred from") && foundDataSection {
                break
            }
            
            // Parse data line
            parseDataLine(line: line, dataType: dataType)
        }
    }

    private func parseDataLine(line: String, dataType: TemperatureAnomaly.DataType) {
        // Split line by whitespace, handling multiple spaces
        let components = line.split(separator: " ").filter { !$0.isEmpty }
        
        // Check if we have enough components for at least year and month
        guard components.count >= 2 else { return }
        
        // Parse year and month
        guard let year = Int(components[0]),
              let month = Int(components[1]) else { return }
        
        // Create date from year and month
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = 15 // Middle of the month
        
        guard let date = calendar.date(from: dateComponents) else { return }
        
        // This is a comment
        // Parse monthly data
        if components.count >= 4 {
            let monthlyAnomaly = Double(components[2]) ?? 0
            let monthlyUncertainty = Double(components[3]) ?? 0
            
            let monthlyData = TemperatureAnomaly(
                date: date,
                anomaly: monthlyAnomaly,
                uncertainty: monthlyUncertainty,
                dataType: dataType
            )
            temperatureData.append(monthlyData)
        }
        
        // Parse annual data (components 4 and 5)
        if components.count >= 6 {
            var annualDate = date
            // For annual data, we use June 15th of that year
            if month != 6 {
                var annualComponents = calendar.dateComponents([.year], from: date)
                annualComponents.month = 6
                annualComponents.day = 15
                if let newDate = calendar.date(from: annualComponents) {
                    annualDate = newDate
                }
            }
            
            let annualAnomaly = Double(components[4]) ?? 0
            let annualUncertainty = Double(components[5]) ?? 0
            
            // Check if we've already added this annual data point
            let yearExists = temperatureData.contains { item in
                let itemYear = calendar.component(.year, from: item.date)
                let itemMonth = calendar.component(.month, from: item.date)
                return itemYear == year && itemMonth == 6 && item.dataType == dataType
            }
            
            if !yearExists {
                let annualData = TemperatureAnomaly(
                    date: annualDate,
                    anomaly: annualAnomaly,
                    uncertainty: annualUncertainty,
                    dataType: dataType
                )
                temperatureData.append(annualData)
            }
        }
    }
    
    private func parseAirTemperatureData() {
        // This is a simplified version - you would parse the actual file data
        // Sample data points from the file
        let sampleData: [(year: Int, month: Int, anomaly: Double, uncertainty: Double)] = [
            (1950, 1, -0.225, 0.101), (1960, 1, -0.060, 0.057), (1970, 1, 0.063, 0.030),
            (1980, 1, 0.307, 0.039), (1990, 1, 0.464, 0.050), (2000, 1, 0.301, 0.036),
            (2010, 1, 0.735, 0.032), (2020, 1, 1.155, 0.034),
            (1950, 7, -0.025, 0.136), (1960, 7, -0.033, 0.074), (1970, 7, 0.142, 0.035),
            (1980, 7, 0.385, 0.049), (1990, 7, 0.523, 0.050), (2000, 7, 0.303, 0.036),
            (2010, 7, 0.735, 0.032), (2020, 7, 0.845, 0.030)
        ]
        
        // Parse annual data from the file (simplified for example)
        let sampleAnnualData: [(year: Int, anomaly: Double, uncertainty: Double)] = [
            (1950, -0.170, 0.082), (1960, -0.030, 0.055), (1970, -0.095, 0.029),
            (1980, 0.257, 0.032), (1990, 0.405, 0.030), (2000, 0.394, 0.028),
            (2010, 0.685, 0.028), (2020, 0.955, 0.027)
        ]
        
        // Populate monthly data
        for dataPoint in sampleData {
            let calendar = Calendar.current
            var dateComponents = DateComponents()
            dateComponents.year = dataPoint.year
            dateComponents.month = dataPoint.month
            dateComponents.day = 15 // Middle of the month
            
            if let date = calendar.date(from: dateComponents) {
                let temperatureAnomaly = TemperatureAnomaly(
                    date: date,
                    anomaly: dataPoint.anomaly,
                    uncertainty: dataPoint.uncertainty,
                    dataType: .air
                )
                temperatureData.append(temperatureAnomaly)
            }
        }
        
        // Populate annual data
        for dataPoint in sampleAnnualData {
            let calendar = Calendar.current
            var dateComponents = DateComponents()
            dateComponents.year = dataPoint.year
            dateComponents.month = 6  // Middle of the year
            dateComponents.day = 15
            
            if let date = calendar.date(from: dateComponents) {
                let temperatureAnomaly = TemperatureAnomaly(
                    date: date,
                    anomaly: dataPoint.anomaly,
                    uncertainty: dataPoint.uncertainty,
                    dataType: .air
                )
                temperatureData.append(temperatureAnomaly)
            }
        }
    }
    
    private func parseWaterTemperatureData() {
        // Sample water temperature data from the file
        let sampleData: [(year: Int, month: Int, anomaly: Double, uncertainty: Double)] = [
            (1950, 1, -0.252, 0.102), (1960, 1, -0.078, 0.057), (1970, 1, 0.015, 0.031),
            (1980, 1, 0.269, 0.039), (1990, 1, 0.390, 0.030), (2000, 1, 0.267, 0.036),
            (2010, 1, 0.607, 0.032), (2020, 1, 1.059, 0.034),
            (1950, 7, -0.055, 0.117), (1960, 7, -0.046, 0.074), (1970, 7, 0.044, 0.036),
            (1980, 7, 0.348, 0.049), (1990, 7, 0.442, 0.040), (2000, 7, 0.255, 0.036),
            (2010, 7, 0.607, 0.032), (2020, 7, 0.751, 0.030)
        ]
        
        // Annual data
        let sampleAnnualData: [(year: Int, anomaly: Double, uncertainty: Double)] = [
            (1950, -0.137, 0.091), (1960, -0.030, 0.055), (1970, -0.067, 0.030),
            (1980, 0.215, 0.033), (1990, 0.366, 0.030), (2000, 0.347, 0.028),
            (2010, 0.582, 0.028), (2020, 0.798, 0.027)
        ]
        
        // Populate the data (similar to air temperature)
        for dataPoint in sampleData {
            let calendar = Calendar.current
            var dateComponents = DateComponents()
            dateComponents.year = dataPoint.year
            dateComponents.month = dataPoint.month
            dateComponents.day = 15
            
            if let date = calendar.date(from: dateComponents) {
                let temperatureAnomaly = TemperatureAnomaly(
                    date: date,
                    anomaly: dataPoint.anomaly,
                    uncertainty: dataPoint.uncertainty,
                    dataType: .water
                )
                temperatureData.append(temperatureAnomaly)
            }
        }
        
        for dataPoint in sampleAnnualData {
            let calendar = Calendar.current
            var dateComponents = DateComponents()
            dateComponents.year = dataPoint.year
            dateComponents.month = 6
            dateComponents.day = 15
            
            if let date = calendar.date(from: dateComponents) {
                let temperatureAnomaly = TemperatureAnomaly(
                    date: date,
                    anomaly: dataPoint.anomaly,
                    uncertainty: dataPoint.uncertainty,
                    dataType: .water
                )
                temperatureData.append(temperatureAnomaly)
            }
        }
    }
    
    func filteredData() -> [TemperatureAnomaly] {
        let calendar = Calendar.current
        
        // First filter by data type
        let filteredByType = temperatureData.filter { $0.dataType == selectedType }
        
        // Then filter by year range
        let filteredByYear = filteredByType.filter {
            let year = calendar.component(.year, from: $0.date)
            return year >= yearRange.lowerBound && year <= yearRange.upperBound
        }
        
        // Filter by time span
        return filteredByYear.filter { dataPoint in
            let month = calendar.component(.month, from: dataPoint.date)
            
            switch selectedTimeSpan {
            case .monthly:
                // Include all monthly data points
                return true
                
            case .annual:
                // Include only June (mid-year) for annual averages
                return month == 6
            }
        }
    }
}
