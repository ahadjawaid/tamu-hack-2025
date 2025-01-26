//
//  CategoryView.swift
//  HackTAMU25App
//
//  Created by tk on 1/25/25.
//

import SwiftUI
import SwiftData

struct CategoryView: View {
    let category: CategoryType
    @Query private var topics: [Topic]
    @State private var searchQuery: String = ""
    
    var filteredTopics: [Topic] {
        let categoryTopics = topics.filter { $0.category == category }
        if searchQuery.isEmpty {
            return categoryTopics
        }
        return categoryTopics.filter {
            $0.title.localizedCaseInsensitiveContains(searchQuery) ||
            $0.subtitle.localizedCaseInsensitiveContains(searchQuery)
        }
    }
    
    var body: some View {
        NavigationStack {
            List(filteredTopics) { topic in
                MusicItem(topic: topic)
            }
            .listStyle(.plain)
            .navigationTitle(category.rawValue)
            .searchable(text: $searchQuery)
        }
        .background(Color.gray.opacity(0.05))
    }
}

#Preview {
    CategoryView(category: .biology)
        .modelContainer(SampleData.shared.modelContainer)
}
