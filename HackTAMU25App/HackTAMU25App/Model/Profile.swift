//
//  Profile.swift
//  HackTAMU25App
//
//  Created by tk on 1/25/25.
//

import SwiftUI
import SwiftData

@Model
final class Profile {
    var name: String
    var profileImage: String
    var topics = [Topic]()
    
    var favoriteCategory: Optional<CategoryType> {
        guard !topics.isEmpty else { return nil }
        
        let categoryCounts = Dictionary(grouping: topics, by: { $0.category })
            .mapValues { $0.count }
        
        return categoryCounts
            .max(by: { $0.value < $1.value })?
            .key
    }
    
    
    init(name: String, profileImage: String = "") {
        self.name = name
        self.profileImage = profileImage
    }
}
