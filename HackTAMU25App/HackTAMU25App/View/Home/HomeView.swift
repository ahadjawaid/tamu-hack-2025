//
//  HomeView.swift
//  HackTAMU25App
//
//  Created by tk on 1/25/25.
//

import SwiftUI

struct HomeView: View {
    @Environment()
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(categoryName)
                    .font(.headline)
                    .padding(.leading, 15.0)
                    .padding(.top, 5)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 0.0) {
                        ForEach(landmarks) { landmark in
                            NavigationLink {
                                LandmarkDetail(landmark: landmark)
                            } label: {
                                CategoryItem(landmark: landmark)
                            }
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
