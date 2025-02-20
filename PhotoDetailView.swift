import SwiftUI

struct PhotoDetailView: View {
    let photo: AstroPhoto
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Image(photo.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 10)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(photo.title)
                        .font(.title)
                        .bold()
                    
                    Text(photo.date)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Text(photo.description)
                        .padding(.top, 8)
                    
                    Text("Credit: \(photo.credit)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.top, 8)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Close") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    PhotoDetailView(photo: AstroPhoto(
        imageName: "sample_image",
        title: "Sample Photo",
        description: "A beautiful cosmic view",
        date: "2024-02-17",
        credit: "NASA/ESA"
    ))
}
