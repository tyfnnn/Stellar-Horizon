//
//  TemperatureChartView.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 11.03.25.
//

import SwiftUI
import Charts

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





// Preview for development
struct TemperatureChartView_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureChartView()
    }
}
