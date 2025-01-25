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
        VStack {
            VStack(alignment: .leading) {
                Text("Top picks for you")
                    .font(.headline)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 0.0) {
                        ForEach(recommendedTopics) { topic in
                            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                        }
                    }
                }
                .frame(height: 185)
            }
            
            VStack {
                
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(SampleData.shared.modelContainer)
}
