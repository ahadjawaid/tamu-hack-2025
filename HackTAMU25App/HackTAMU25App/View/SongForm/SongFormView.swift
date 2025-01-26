//
//  SongFormView.swift
//  HackTAMU25App
//
//  Created by tk on 1/25/25.
//

import SwiftUI

struct SongFormView: View {
   @State private var topic = ""
   @State private var selectedGenre: Genre = .pop
   
   var body: some View {
       VStack(spacing: 25) {
           Text("Create Your Song")
               .font(.largeTitle.bold())
               .padding(.top, 20)
           
           VStack(alignment: .leading, spacing: 12) {
               Label("TOPIC", systemImage: "sparkles")
                   .font(.subheadline)
                   .fontWeight(.semibold)
               
               TextField("What do you want to learn about?", text: $topic)
                   .padding()
                   .background(
                       RoundedRectangle(cornerRadius: 12)
                           .fill(Color(.systemBackground))
                           .shadow(color: Color(.systemGray4), radius: 8)
                   )
           }
           .padding(.horizontal)
           
           VStack(alignment: .leading, spacing: 15) {
               Label("GENRE", systemImage: "music.note")
                   .font(.subheadline)
                   .fontWeight(.semibold)
                   .padding(.horizontal)
               
               GenreGridView(selectedGenre: $selectedGenre)
           }
           
           Spacer()
           
           Button(action: {}) {
               HStack(spacing: 8) {
                   Image(systemName: "wand.and.stars")
                   Text("Generate")
                       .fontWeight(.semibold)
               }
               .font(.title3)
               .foregroundColor(.white)
               .frame(height: 56)
               .frame(maxWidth: .infinity)
               .background(.accent)
               .clipShape(Capsule())
           }
           .padding(.horizontal, 25)
           .padding(.top, 10)
       }
       .padding(.bottom, 30)
       .padding(.top, 16)
       .background(Color(.systemGroupedBackground))
   }
}

struct GenreGridView: View {
   @Binding var selectedGenre: Genre
   
   let columns = [
       GridItem(.flexible()),
       GridItem(.flexible())
   ]
   
   var body: some View {
       LazyVGrid(columns: columns, spacing: 12) {
           ForEach(Genre.allCases) { genre in
               GenreCard(genre: genre,
                        isSelected: selectedGenre == genre,
                        action: { selectedGenre = genre })
           }
       }
       .padding(.horizontal)
   }
}

struct GenreCard: View {
   let genre: Genre
   let isSelected: Bool
   let action: () -> Void
   
   var body: some View {
       Button(action: action) {
           HStack {
               Image(systemName: genre.icon)
                   .font(.title2)
                   .frame(width: 30)
               
               Text(genre.rawValue)
                   .font(.headline)
               
               Spacer()
               
               if isSelected {
                   Image(systemName: "checkmark.circle.fill")
                       .foregroundColor(genre.color)
               }
           }
           .padding(.horizontal, 16)
           .padding(.vertical, 12)
           .background(
               RoundedRectangle(cornerRadius: 12)
                   .fill(Color(.systemBackground))
                   .shadow(color: isSelected ? genre.color.opacity(0.3) : Color(.systemGray4).opacity(0.3),
                          radius: 8)
           )
       }
       .foregroundColor(isSelected ? genre.color : .primary)
   }
}

#Preview {
    SongFormView()
}
