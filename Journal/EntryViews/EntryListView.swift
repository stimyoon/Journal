//
//  EntryListView.swift
//  Journal
//
//  Created by Tim Yoon on 2/15/22.
//

import SwiftUI
import Combine



struct EntryListView: View {
    @ObservedObject var vm : EntryListVM
    
    @State var entry = Entry()
    
    var body: some View {
        NavigationView{
            List{
                ForEach(vm.entries) { entry in
                    NavigationLink {
                        EntryEditView(vm: vm, entry: entry, completion: vm.update)
                    } label: {
                        EntryCellView(entry: entry)
                    }
                }
                .onDelete(perform: vm.delete)
            }
            .listStyle(.plain)
            .navigationTitle("Journal Entries")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink {
                        EntryEditView(vm: vm, entry: Entry(), completion: vm.create)
                    } label: {
                        Label("Save", systemImage: "plus")
                    }
                    
                }
            }
        }
    }
}

struct EntryListView_Previews: PreviewProvider {
    static var previews: some View {
        EntryListView(vm: EntryListVM(dataService: MockEntryDataService()))
    }
}
