//
//  Topic.swift
//  HackTAMU25App
//
//  Created by tk on 1/25/25.
//

import Foundation
import SwiftData

struct CategoryData {
    let name: String
    let icon: String
}

@Model
final class Topic {
    var title: String
    var subtitle: String
    var prompt: String
    var imageURL: Optional<String>
    var category: Category
    var userAdded: Bool
    var recommended: Bool
    
    enum Category: String, CaseIterable, Identifiable, Codable {
        case biology = "Biology"
        case finance = "Finance"
        case health = "Health"
        case business = "Business"
        case history = "History"
        case technology = "Technology"
        case mathematics = "Mathematics"
        case artAndDesign = "Art & Design"
        case psychology = "Psychology"
        case environmentalScience = "Environmental Science"
        case food = "Food"
        case unknown = ""

        var id: String { rawValue }

        var icon: String {
            switch self {
                case .biology: return "allergens"
                case .finance: return "dollarsign.circle"
                case .health: return "heart"
                case .business: return "cart"
                case .history: return "pencil.and.scribble"
                case .technology: return "cable.coaxial"
                case .mathematics: return "numbers.rectangle"
                case .artAndDesign: return "paintbrush.pointed"
                case .psychology: return "brain.filled.head.profile"
                case .environmentalScience: return "tree"
                case .food: return "carrot"
                case .unknown: return ""
            }
        }
    }
    
    init(
        title: String,
        subtitle: String = "",
        prompt: String = "",
        imageURL: Optional<String>,
        category: Category = .unknown,
        userAdded: Bool = false,
        recommended: Bool = false
    ) {
        self.title = title
        self.subtitle = subtitle
        self.prompt = prompt
        self.imageURL = imageURL
        self.category = category
        self.userAdded = userAdded
        self.recommended = recommended
    }
}

