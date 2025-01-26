//
//  Topic.swift
//  HackTAMU25App
//
//  Created by tk on 1/25/25.
//

import SwiftUI
import SwiftData

@Model
final class Topic {
    var title: String
    var subtitle: String
    var prompt: String
    var imageURL: Optional<String>
    var genre: Optional<Genre>
    var category: CategoryType
    var userAdded: Bool
    var recommended: Bool
    var dateCreated: Date
    
    init(
        title: String,
        subtitle: String = "",
        prompt: String = "",
        imageURL: Optional<String> = nil,
        genre: Optional<Genre> = nil,
        category: CategoryType = .unknown,
        userAdded: Bool = false,
        recommended: Bool = false,
        date: Date = .now
    ) {
        self.title = title
        self.subtitle = subtitle
        self.prompt = prompt
        self.imageURL = imageURL
        self.genre = genre
        self.category = category
        self.userAdded = userAdded
        self.recommended = recommended
        self.dateCreated = date
    }
}

struct CategoryData {
    let name: String
    let icon: String
}

enum CategoryType: String, CaseIterable, Identifiable, Codable {
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
    
    var color: Color {
        switch self {
            case .biology: return Color(hex: "00D492")         // Fresh green
            case .finance: return Color(hex: "00D3F2")         // Ocean blue
            case .health: return Color(hex: "FF637E")          // Soft red
            case .business: return Color(hex: "A684FF")        // Royal purple
            case .history: return Color(hex: "50A2FF")         // Burnt orange
            case .technology: return Color(hex: "ED6AFF")      // Turquoise
            case .mathematics: return Color(hex: "F1C40F")     // Sunflower yellow
            case .artAndDesign: return Color(hex: "FDC800")    // Pink
            case .psychology: return Color(hex: "94ECF9")      // Dark slate
            case .environmentalScience: return Color(hex: "06DF73") // Forest green
            case .food: return Color(hex: "FF8905")           // Orange
            case .unknown: return Color(hex: "95A5A6")        // Gray
        }
    }
    
    func isEquivalent(to other: CategoryType) -> Bool {
        return self.rawValue == other.rawValue
    }
}

enum Genre: String, CaseIterable, Identifiable, Codable {
    case rock = "Rock"
    case pop = "Pop"
    case jazz = "Jazz"
    case classical = "Classical"
    case country = "Country"
    case hiphop = "Hip-hop"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .rock: return "guitars.fill"
        case .pop: return "music.mic"
        case .jazz: return "music.note.list"
        case .classical: return "pianokeys"
        case .country: return "music.house"
        case .hiphop: return  "music.note"
        }
    }
    
    var color: Color {
         switch self {
         case .rock: return .red
         case .pop: return .purple
         case .jazz: return .blue
         case .classical: return .indigo
         case .country: return .orange
         case .hiphop: return .green
         }
     }
}
