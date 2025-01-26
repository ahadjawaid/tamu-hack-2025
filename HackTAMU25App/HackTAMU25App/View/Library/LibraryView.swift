import SwiftUI
import SwiftData

import SwiftUI
import SwiftData

struct LibraryView: View {
    @Query(filter: #Predicate<Topic> { topic in
        topic.userAdded == true
    }) private var userTopics: [Topic]
    
    var body: some View {
        List(userTopics) { topic in
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
                       
                       if let genre = topic.genre?.rawValue {
                           Text(genre)
                               .font(.subheadline)
                               .foregroundColor(topic.genre?.color ?? .gray)
                       }
                   }
                   
                   Spacer()
                   
                   Image(systemName: "play.circle.fill")
                       .font(.title)
                       .foregroundColor(.gray)
               }
               .padding(.vertical, 12)
           }
           .buttonStyle(ScaleButtonStyle())
           .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
           .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        
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
