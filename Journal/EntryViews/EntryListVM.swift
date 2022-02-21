//
//  EntryListVM.swift
//  Journal
//
//  Created by Tim Yoon on 2/20/22.
//

import Foundation
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
