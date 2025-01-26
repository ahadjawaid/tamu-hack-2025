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
            MusicItem(topic: topic)
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
