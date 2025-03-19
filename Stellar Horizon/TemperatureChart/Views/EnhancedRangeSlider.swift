//
//  EnhancedRangeSlider.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 19.03.25.
//

import SwiftUI

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

