//
//  EntryListView.swift
//  Journal
//
//  Created by Tim Yoon on 2/15/22.
//

import SwiftUI
import Combine

class EntryListVM : ObservableObject {
    @Published var entries : [Entry] = []
    var dataService : EntryDataServiceProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    func create(entry: Entry) {
        dataService.create(entry: entry)
    }
    func update(entry: Entry) {
        dataService.update(entry: entry)
    }
    func delete(at indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        dataService.delete(entry: entries[index])
    }
    
    init(dataService: EntryDataServiceProtocol) {
        self.dataService = dataService
        dataService.getData()
            .sink { error in
                fatalError("Unable to getData: \(error)")
            } receiveValue: { [weak self] entries in
                self?.entries = entries
            }
            .store(in: &cancellables)
    }
}

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
struct EntryEditView : View {
    @Environment(\.dismiss) var dismiss
    @State var entry : Entry
    var completion: (Entry)->()
    
    var body: some View {
        Form{
            TextField("title", text: $entry.title)
            TextEditor(text: $entry.note)
                .lineLimit(nil)
            Button {
                completion(entry)
                dismiss()
            } label: {
                Text("Save").centerHorizontally()
            }
            .buttonStyle(.bordered)
        }
    }
}

struct EntryCellView: View {
    let entry : Entry
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(entry.title).font(.title3)
                Spacer()
                Text(dateString(date: entry.timestamp))
                    .font(.caption)
            }
            Text(entry.note)
        }
    }
    func dateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}
