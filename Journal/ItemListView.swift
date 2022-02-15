//
//  ItemListView.swift
//  Journal
//
//  Created by Tim Yoon on 2/14/22.
//

import SwiftUI
extension Item {
    var title : String {
        get { title_ ?? "" }
        set { title_ = newValue }
    }
    var note : String {
        get { note_ ?? "" }
        set { note_ = newValue }
    }
}
struct ItemListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)], predicate: nil, animation: .default) var items : FetchedResults<Item>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items){ item in
                    VStack{
                        Text(item.title)
                        Text(item.note)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        ItemEditView(item: createItem(), completion: saveItems)
                    } label: {
                        Label("Add", systemImage: "plus")
                    }

                }
            }
        }
    }
    private func saveItems() {
        withAnimation {
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    private func createItem() -> Item{
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            return newItem
        }
    }
}

struct ItemListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListView()
    }
}
