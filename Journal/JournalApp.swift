//
//  JournalApp.swift
//  Journal
//
//  Created by Tim Yoon on 2/14/22.
//

import SwiftUI

@main
struct JournalApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
//            ItemListView()
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
