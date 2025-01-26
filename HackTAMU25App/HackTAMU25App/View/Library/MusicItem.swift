//
//  MusicItem.swift
//  HackTAMU25App
//
//  Created by tk on 1/26/25.
//

import SwiftUI

struct MusicItem: View {
    let topic: Topic
    @State private var displayPlayer: Bool = false
    
    var body: some View {
        Button(action: {
            displayPlayer.toggle()
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
        .fullScreenCover(isPresented: $displayPlayer) {
            PlayerView(topic: topic)
        }
    }
}

#Preview {
    MusicItem(topic: SampleData.shared.topic)
}

