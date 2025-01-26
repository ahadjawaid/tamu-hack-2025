//
//  HomeView.swift
//  HackTAMU25App
//
//  Created by tk on 1/25/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Query(filter: #Predicate<Topic> { topic in
        topic.recommended == true
    }) private var recommendedTopics: [Topic]
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Daily Picks")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 20) {
                            ForEach(recommendedTopics) { topic in
                                TopicCard(topic: topic)
                            }
                        }
                        .padding(.bottom, 8)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Popular Categories")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 20) {
                            ForEach(CategoryType.allCases.filter { $0 != .unknown }) { category in
                                NavigationLink {
                                    CategoryView(category: category)
                                } label: {
                                    CategoryCard(category: category)
                                }
                            }
                        }
                        .padding(.bottom, 8)
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(SampleData.shared.modelContainer)
}
