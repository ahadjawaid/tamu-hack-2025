//
//  CategoryCard.swift
//  HackTAMU25App
//
//  Created by tk on 1/25/25.
//

import SwiftUI

struct CategoryCard: View {
    let category: CategoryType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(category.color.opacity(0.1))
                    .frame(width: 160, height: 160)
                
                VStack(spacing: 12) {
                    Image(systemName: category.icon)
                        .foregroundColor(category.color)
                        .font(.system(size: 32))
                        .fontWeight(.medium)
                    
                    Text(category.rawValue)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(category.color)
                }
            }
            .clipped()
        }
        .frame(width: 160)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color(.systemGray4), radius: 2)
        .padding(.vertical, 4)
    }
}

#Preview {
    CategoryCard(category: .finance)
}
