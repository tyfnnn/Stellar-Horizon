//
//  TemperatureChartView.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 11.03.25.
//

import SwiftUI
import Charts

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

struct TemperatureChartView: View {
    @State private var viewModel = TemperatureViewModel()
    @State private var showUncertainty = true
    
    private var chartTitle: String {
        "Global Temperature Anomaly (\(viewModel.yearRange.lowerBound)-\(viewModel.yearRange.upperBound))"
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading temperature data...")
                } else {
                    VStack(alignment: .leading) {
                        Text(chartTitle)
                            .font(.headline)
                            .padding(.top)
                            .padding(.horizontal)
                        
                        // Main Chart
                        Chart {
                            // Plot the temperature anomaly
                            ForEach(viewModel.filteredData()) { dataPoint in
                                LineMark(
                                    x: .value("Date", dataPoint.date),
                                    y: .value("Anomaly (°C)", dataPoint.anomaly)
                                )
                                .foregroundStyle(viewModel.selectedType == .air ? .red : .blue)
                                .lineStyle(StrokeStyle(lineWidth: 2))
                                
                                // Show uncertainty area if enabled
                                if showUncertainty {
                                    AreaMark(
                                        x: .value("Date", dataPoint.date),
                                        yStart: .value("Lower Bound", dataPoint.anomaly - dataPoint.uncertainty),
                                        yEnd: .value("Upper Bound", dataPoint.anomaly + dataPoint.uncertainty)
                                    )
                                    .foregroundStyle(
                                        viewModel.selectedType == .air ?
                                            .red.opacity(0.2) : .blue.opacity(0.2)
                                    )
                                }
                            }
                            
                            // Add a zero line for reference
                            RuleMark(y: .value("Baseline", 0))
                                .foregroundStyle(.gray.opacity(0.5))
                                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
                        }
                        .chartYAxis {
                            AxisMarks(position: .leading)
                        }
                        .chartXAxis {
                            AxisMarks(values: .stride(by: .year, count: 10)) { _ in
                                AxisGridLine()
                                AxisTick()
                                AxisValueLabel(format: .dateTime.year())
                            }
                        }
                        .frame(height: 300)
                        .padding()
                        
                        // Controls
                        VStack(alignment: .leading, spacing: 10) {
                            // Data type selector
                            Picker("Data Source", selection: $viewModel.selectedType) {
                                ForEach(TemperatureAnomaly.DataType.allCases, id: \.self) { type in
                                    Text(type.rawValue).tag(type)
                                }
                            }
                            .pickerStyle(.segmented)
                            
                            // Time span selector
                            Picker("Time Span", selection: $viewModel.selectedTimeSpan) {
                                ForEach(TemperatureViewModel.TimeSpan.allCases, id: \.self) { span in
                                    Text(span.rawValue).tag(span)
                                }
                            }
                            .pickerStyle(.segmented)
                            
                            // Year range selector
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Year Range")
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                    
                                    Spacer()
                                    
                                    Text("\(viewModel.yearRange.lowerBound) - \(viewModel.yearRange.upperBound)")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(8)
                                }
                                
                                EnhancedRangeSlider(
                                    range: $viewModel.yearRange,
                                    bounds: viewModel.minYear...viewModel.maxYear
                                )
                                .padding(.top, 4)
                            }
                            .padding(.vertical, 12)
                            
                            // Uncertainty toggle
                            Toggle("Show Uncertainty Range", isOn: $showUncertainty)
                                .toggleStyle(SwitchToggleStyle(tint: .blue))
                        }
                        .padding()
                    }
                }
            }
            .background(Color("bgColors"))
            .navigationTitle("Global Temperature Trends")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Refresh") {
                        viewModel.loadData()
                    }
                }
            }
            .onAppear {
                viewModel.loadData()
            }
        }
    }
}

// Enhanced range slider with better iOS styling
struct EnhancedRangeSlider: View {
    @Binding var range: ClosedRange<Int>
    let bounds: ClosedRange<Int>
    @State private var isDraggingLower = false
    @State private var isDraggingUpper = false
    
    private let trackHeight: CGFloat = 4
    private let thumbSize: CGFloat = 28
    private let minThumbDistance: CGFloat = 20
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track
                Capsule()
                    .fill(Color(.systemGray5))
                    .frame(height: trackHeight)
                
                // Active track
                Capsule()
                    .fill(Color.accentColor)
                    .frame(
                        width: max(0, calculateWidth(in: geometry)),
                        height: trackHeight
                    )
                    .offset(x: calculateLowerThumbPosition(in: geometry))
                
                // Year ticks
                ForEach(bounds.lowerBound...bounds.upperBound, id: \.self) { year in
                    if year % 10 == 0 {
                        Tick(year: year, bounds: bounds, geometry: geometry)
                    }
                }
                
                // Lower thumb
                Thumb(
                    position: calculateLowerThumbPosition(in: geometry),
                    isDragging: isDraggingLower,
                    label: "\(range.lowerBound)"
                )
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            isDraggingLower = true
                            updateLowerBound(with: value, in: geometry)
                        }
                        .onEnded { _ in
                            isDraggingLower = false
                        }
                )
                
                // Upper thumb
                Thumb(
                    position: calculateUpperThumbPosition(in: geometry),
                    isDragging: isDraggingUpper,
                    label: "\(range.upperBound)"
                )
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            isDraggingUpper = true
                            updateUpperBound(with: value, in: geometry)
                        }
                        .onEnded { _ in
                            isDraggingUpper = false
                        }
                )
            }
            .frame(height: thumbSize + 20) // Add padding for thumb labels
            .padding(.horizontal, thumbSize/2) // Ensure thumbs don't go outside bounds
        }
        .frame(height: 60)
    }
    
    private func calculateLowerThumbPosition(in geometry: GeometryProxy) -> CGFloat {
        let availableWidth = geometry.size.width - thumbSize
        let percent = CGFloat(range.lowerBound - bounds.lowerBound) / CGFloat(bounds.upperBound - bounds.lowerBound)
        return percent * availableWidth
    }
    
    private func calculateUpperThumbPosition(in geometry: GeometryProxy) -> CGFloat {
        let availableWidth = geometry.size.width - thumbSize
        let percent = CGFloat(range.upperBound - bounds.lowerBound) / CGFloat(bounds.upperBound - bounds.lowerBound)
        return percent * availableWidth
    }
    
    private func calculateWidth(in geometry: GeometryProxy) -> CGFloat {
        calculateUpperThumbPosition(in: geometry) - calculateLowerThumbPosition(in: geometry)
    }
    
    private func updateLowerBound(with gesture: DragGesture.Value, in geometry: GeometryProxy) {
        let availableWidth = geometry.size.width - thumbSize
        let offsetRatio = gesture.location.x / availableWidth
        let newLowerBound = bounds.lowerBound + Int(offsetRatio * CGFloat(bounds.upperBound - bounds.lowerBound))
        
        // Ensure we maintain the minimum distance and stay within bounds
        let clampedLowerBound = max(
            bounds.lowerBound,
            min(newLowerBound, range.upperBound - 1)
        )
        
        if range.upperBound - clampedLowerBound >= 5 { // Minimum 5 year difference
            range = clampedLowerBound...range.upperBound
        }
    }
    
    private func updateUpperBound(with gesture: DragGesture.Value, in geometry: GeometryProxy) {
        let availableWidth = geometry.size.width - thumbSize
        let offsetRatio = gesture.location.x / availableWidth
        let newUpperBound = bounds.lowerBound + Int(offsetRatio * CGFloat(bounds.upperBound - bounds.lowerBound))
        
        // Ensure we maintain the minimum distance and stay within bounds
        let clampedUpperBound = min(
            bounds.upperBound,
            max(newUpperBound, range.lowerBound + 1)
        )
        
        if clampedUpperBound - range.lowerBound >= 5 { // Minimum 5 year difference
            range = range.lowerBound...clampedUpperBound
        }
    }
}

// Thumb component for the range slider
struct Thumb: View {
    let position: CGFloat
    let isDragging: Bool
    let label: String
    private let size: CGFloat = 28
    
    var body: some View {
        ZStack {
            // The thumb itself
            Circle()
                .fill(Color.white)
                .frame(width: size, height: size)
                .shadow(color: isDragging ? .accentColor.opacity(0.4) : .gray.opacity(0.3),
                        radius: isDragging ? 4 : 2,
                        x: 0, y: isDragging ? 2 : 1)
                .overlay(
                    Circle()
                        .stroke(isDragging ? Color.accentColor : Color.gray.opacity(0.5), lineWidth: 2)
                )
                .scaleEffect(isDragging ? 1.1 : 1.0)
                .animation(.spring(response: 0.3), value: isDragging)
                .offset(x: -20)
            
            // The label above the thumb
            Text(label)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color.accentColor)
                .cornerRadius(4)
                .offset(y: -24)
                .opacity(isDragging ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.2), value: isDragging)
        }
        .offset(x: position)
    }
}

// Tick marks for decade labels
struct Tick: View {
    let year: Int
    let bounds: ClosedRange<Int>
    let geometry: GeometryProxy
    
    var body: some View {
        VStack(spacing: 4) {
            Rectangle()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 1, height: 8)
            
            if year % 20 == 0 {
                Text("\(year)")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }
        }
        .offset(x: calculatePosition())
    }
    
    private func calculatePosition() -> CGFloat {
        let totalWidth = geometry.size.width
        let normalizedPosition = CGFloat(year - bounds.lowerBound) / CGFloat(bounds.upperBound - bounds.lowerBound)
        return normalizedPosition * totalWidth
    }
}

// Preview for development
struct TemperatureChartView_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureChartView()
    }
}
