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
    
    var categoryTopics: [Topic]  {
        topics.filter({ $0.category == category })
    }
    
    var body: some View {
        NavigationStack {
            List(categoryTopics) { topic in
                MusicItem(topic: topic)
            }
            .listStyle(.plain)
            .navigationTitle(category.rawValue)
        }
        .background(Color.gray.opacity(0.05))
    }
}

#Preview {
    CategoryView(category: .biology)
        .modelContainer(SampleData.shared.modelContainer)
}
