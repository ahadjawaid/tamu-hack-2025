//
//  HackTAMU25AppApp.swift
//  HackTAMU25App
//
//  Created by tk on 1/25/25.
//

import SwiftUI
import SwiftData

@main
struct HackTAMU25AppApp: App {
//    var sharedModelContainer: ModelContainer = initializeModelContainer()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
//        .modelContainer(SampleData.shared.modelContainer)
    }
}

func initializeModelContainer() -> ModelContainer {
    let schema = Schema([
        Topic.self,
    ])
    
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}
