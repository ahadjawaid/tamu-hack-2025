//
//  CategoryView.swift
//  HackTAMU25App
//
//  Created by tk on 1/25/25.
//

import SwiftUI
import SwiftData

struct CategoryView: View {
    let selectedCategory: CategoryType
    @Query private var topics: [Topic]
    
    init(category: CategoryType) {
        self.selectedCategory = category
        _topics = Query(filter: #Predicate<Topic> {
            category == $0.category
        })
        
        print(self.topics.count)
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    CategoryView(category: .business)
        .modelContainer(SampleData.shared.modelContainer)
}
