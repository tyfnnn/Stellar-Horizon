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