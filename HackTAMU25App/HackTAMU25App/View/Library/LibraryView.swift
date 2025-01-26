import SwiftUI
import SwiftData

struct LibraryView: View {
    @Query(filter: #Predicate<Topic> { topic in
        topic.userAdded == true
    }) private var userTopics: [Topic]
    @State private var searchText = ""
    
    var filteredTopics: [Topic] {
        if searchText.isEmpty {
            return userTopics
        }
        return userTopics.filter { topic in
            topic.title.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        List(filteredTopics) { topic in
            MusicItem(topic: topic)
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
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
