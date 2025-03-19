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