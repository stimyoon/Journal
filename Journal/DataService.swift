//
//  DataService.swift
//  PracticeWithChris
//
//  Created by Tim Yoon on 2/8/22.
//

import Foundation
import Combine
import CoreData

struct Entry : Identifiable, Hashable {
    var id : String? = UUID().uuidString
    var dateCreated : Date = Date()
    var timestamp : Date = Date()
    var title = ""
    var note = ""
}
protocol EntryDataServiceProtocol {
    func getData() -> AnyPublisher<[Entry], Error>
    func create(entry: Entry)
    func update(entry: Entry)
    func delete(entry: Entry)
}

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

class EntryCoreDataService : EntryDataServiceProtocol {
    @Published private (set) var entries : [Entry] = []
    @Published private var entryEntities : [EntryEntity] = []
    let manager = PersistenceController.shared
    private var cancellables = Set<AnyCancellable>()

    func fetch() {
        let request = NSFetchRequest<EntryEntity>(entityName: "EntryEntity")
        let sort = [NSSortDescriptor(key: "timestamp", ascending: true)]
        request.sortDescriptors = sort
        do {
            entryEntities = try manager.context.fetch(request)
        } catch let error {
            fatalError("Unable to fetch from coredata: \(error)")
        }
    }
    
    init(){
        fetch()
        $entryEntities
            .map({ entryEntities in
                entryEntities.map { (entryEntity) -> Entry     in
                    var entry = Entry()
                    do {
                        try self.setEntryValues(entry: &entry, entity: entryEntity)
                    } catch let error {
                        fatalError("\(error)")
                    }
                    return entry
                }
            })
            .sink { error in
                fatalError("Unable to sink: \(error)")
            } receiveValue: { [weak self] entries in
                self?.entries = entries
            }
            .store(in: &cancellables)
    }
    
    private func setEntryEntityValues(entity: EntryEntity, entry: Entry) {
        entity.id = entry.id
        entity.title = entry.title
        entity.note = entry.note
        entity.timestamp = entry.timestamp
        entity.dateCreated = entry.dateCreated
    }
    
    enum SetEntryValuesError : Error {
        case timestampIsNil
        case dateCreatedIsNil
    }
    
    private func setEntryValues( entry: inout Entry, entity: EntryEntity) throws {
        entry.id = entity.id
        entry.title = entity.title ?? ""
        entry.note = entity.note ?? ""
        guard let timestamp = entity.timestamp else {
            throw SetEntryValuesError.timestampIsNil
        }
        entry.timestamp = timestamp
        
        guard let dateCreated = entity.dateCreated else {
            throw SetEntryValuesError.dateCreatedIsNil
        }
        entry.dateCreated = dateCreated
    }
    
    func getData() -> AnyPublisher<[Entry], Error> {
        $entries.tryMap({$0}).eraseToAnyPublisher()
    }

    func create(entry: Entry) {
        let entity = EntryEntity(context: manager.context)
        setEntryEntityValues(entity: entity, entry: entry)
        
        manager.save()
        fetch()
    }

    func update(entry: Entry) {
        guard let index = entryEntities.firstIndex(where: {$0.id == entry.id}) else { return }
        let entity = entryEntities[index]
        setEntryEntityValues(entity: entity, entry: entry)
        
        manager.save()
        fetch()
    }

    func delete(entry: Entry) {
        guard let index = entryEntities.firstIndex(where: {$0.id == entry.id}) else { return }
        manager.context.delete(entryEntities[index])
        manager.save()
        fetch()
    }
}
