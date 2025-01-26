//
//  LibraryView.swift
//  HackTAMU25App
//
//  Created by tk on 1/25/25.
//

import SwiftUI
import SwiftData

struct LibraryView: View {
    @Query(filter: #Predicate<Topic> { topic in
        topic.userAdded == true
    }) private var userTopics: [Topic]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("My Songs")
                    .font(.title2)
                    .fontWeight(.bold)
                
                ForEach(userTopics) { topic in
                    HStack {
                        
                    }
                }
                
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct GenreIcon: View {
    let genre: String
    
    var body: some View {
        let iconName: String
        switch genre.lowercased() {
        case "rock":
            iconName = "guitar.fill"
        case "pop":
            iconName = "music.mic"
        case "jazz":
            iconName = "saxophone.fill"
        case "classical":
            iconName = "music.note"
        case "hip-hop":
            iconName = "headphones"
        default:
            iconName = "music.note"
        }
        
        return Image(systemName: iconName)
            .resizable()
            .scaledToFit()
            .foregroundColor(.blue)
    }
}

#Preview {
    LibraryView()
        .modelContainer(SampleData.shared.modelContainer)
}
