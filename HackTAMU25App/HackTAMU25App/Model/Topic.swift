//
//  Topic.swift
//  HackTAMU25App
//
//  Created by tk on 1/25/25.
//

import Foundation
import SwiftData

enum Category: String, CaseIterable, Identifiable {
    case unknown = ""
    
    var id: String { rawValue }
}

@Model
final class Topic {
    var title: String
    var subtitle: String
    var prompt: String
    var imageURL: Optional<String>
    var userAdded: Bool
    var category: Category
    
    init(
        title: String,
        subtitle: String = "",
        prompt: String = "",
        imageURL: Optional<String>,
        userAdded: Bool = false,
        category: Category = .unknown
    ) {
        self.title = title
        self.subtitle = subtitle
        self.prompt = prompt
        self.imageURL = imageURL
    }
}

