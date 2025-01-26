//
//  TopicCard.swift
//  HackTAMU25App
//
//  Created by tk on 1/25/25.
//

import SwiftUI

struct TopicCard: View {
    let topic: Topic
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            AsyncImage(url: URL(string: topic.imageURL!)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 240, height: 240)
                        .clipped()
                        .cornerRadius(12)
                case .failure:
                    Image(systemName: "photo")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                        .frame(width: 240, height: 200)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                case .empty:
                    ProgressView()
                        .frame(width: 240, height: 200)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                @unknown default:
                    EmptyView()
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(topic.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(topic.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .frame(width: 240)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color(.systemGray4), radius: 5)
        .padding(.vertical, 4)
    }
}
