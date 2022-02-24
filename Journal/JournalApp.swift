//
//  JournalApp.swift
//  Journal
//
//  Created by Tim Yoon on 2/14/22.
//

import SwiftUI

@main
struct JournalApp: App {
    @StateObject var vm = EntryListVM(dataService: EntryCoreDataService())
    var body: some Scene {
        WindowGroup {
            EntryListView(vm: vm)
        }
    }
}
