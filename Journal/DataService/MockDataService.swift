//
//  MockDataService.swift
//  Journal
//
//  Created by Tim Yoon on 2/20/22.
//

import Foundation
import Combine

class MockEntryDataService: EntryDataServiceProtocol {
    @Published var entries : [Entry] = []
    
    func getData() -> AnyPublisher<[Entry], Error> {
        $entries.tryMap({$0}).eraseToAnyPublisher()
    }
    func create(entry: Entry) {
        entries.append(entry)
    }
    func update(entry: Entry) {
        guard let index = entries.firstIndex(where: {$0.id == entry.id})
        else {
            return
        }
        entries[index] = entry
    }
    func delete(entry: Entry) {
        guard let index = entries.firstIndex(where: {$0.id == entry.id})
        else {
            return
        }
        entries.remove(at: index)
    }
    init(){
        self.entries = [
            Entry(title: "first note", note: "This is mock data"),
            Entry(title: "2nd note", note: "This is second mock note")
        ]
    }
}
