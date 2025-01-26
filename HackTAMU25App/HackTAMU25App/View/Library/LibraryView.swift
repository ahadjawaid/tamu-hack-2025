import SwiftUI
import SwiftData

struct LibraryView: View {
    @Query(filter: #Predicate<Topic> { topic in
        topic.userAdded == true
    }) private var userTopics: [Topic]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(userTopics) { topic in
                    Button(action: {
                        // Add your playback action here
                    }) {
                        HStack(spacing: 16) {
                            // Icon with background
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(topic.genre?.color.opacity(0.15) ?? .gray.opacity(0.15))
                                    .frame(width: 48, height: 48)
                                
                                Image(systemName: topic.genre?.icon ?? "music.note")
                                    .font(.title)
                                    .foregroundColor(topic.genre?.color ?? .gray)
                            }
                            
                            // Title and genre
                            VStack(alignment: .leading, spacing: 4) {
                                Text(topic.title)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                if let genre = topic.genre?.rawValue {
                                    Text(genre)
                                        .font(.subheadline)
                                        .foregroundColor(topic.genre?.color ?? .gray)
                                }
                            }
                            
                            Spacer()
                            
                            // Play button
                            Image(systemName: "play.circle.fill")
                                .font(.title)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                        )
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
            }
        }
    }
}

// Custom button style for interactive feedback
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

#Preview {
    LibraryView()
        .modelContainer(SampleData.shared.modelContainer)
}
