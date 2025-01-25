//
//  SampleData.swift
//  HackTAMU25App
//
//  Created by tk on 1/25/25.
//

import SwiftData

@MainActor
class SampleData {
    static let shared = SampleData()
    
    let modelContainer: ModelContainer
    
    var context: ModelContext {
        modelContainer.mainContext
    }
    
    init() {
        modelContainer = initializeModelContainer()
        
        do {
            insertSampleData()
            try context.save()
        } catch {
            fatalError("Could not initalize ModelContainer Data: \(error)")
        }
    }
    
    private func insertSampleData() {
        for file in files {
            context.insert(file)
        }
    }
}
