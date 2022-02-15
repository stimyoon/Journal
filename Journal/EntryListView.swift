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
    @StateObject var vm = EntryListVM(dataService: MockEntryDataService())
    @State var entry = Entry()
    
    var body: some View {
        NavigationView{
            List{
                ForEach(vm.entries) { entry in
                    VStack(alignment: .leading){
                        Text(entry.title)
                        Text(entry.note)
                    }
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
