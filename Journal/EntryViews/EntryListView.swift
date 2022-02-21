//
//  EntryListView.swift
//  Journal
//
//  Created by Tim Yoon on 2/15/22.
//

import SwiftUI
import Combine



struct EntryListView: View {
    @StateObject var vm = EntryListVM(dataService: EntryCoreDataService())
    @State var entry = Entry()
    
    var body: some View {
        NavigationView{
            List{
                ForEach(vm.entries) { entry in
                    NavigationLink {
                        EntryEditView(entry: entry, completion: vm.update)
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
                        EntryEditView(entry: Entry(), completion: vm.create)
                    } label: {
                        Label("Save", systemImage: "plus")
                    }
                    
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
        }
    }
}

struct EntryListView_Previews: PreviewProvider {
    static var previews: some View {
        EntryListView()
    }
}
