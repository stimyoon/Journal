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

//class PersonCoreDataService : PersonDataServiceProtocol {
//    @Published private (set) var persons : [Person] = []
//    @Published private var personEntities : [PersonEntity] = []
//    let manager = PersistenceController.shared
//    private var cancellables = Set<AnyCancellable>()
//
//    func fetch() {
//        let request = NSFetchRequest<PersonEntity>(entityName: "PersonEntity")
//        let sort = [NSSortDescriptor(key: "lastName", ascending: true),
//                    NSSortDescriptor(key: "firstName", ascending: true)
//                    ]
//        request.sortDescriptors = sort
//        do {
//            personEntities = try manager.context.fetch(request)
//        } catch let error {
//            fatalError("Unable to fetch from coredata: \(error)")
//        }
//    }
//    init(){
//        fetch()
//        $personEntities
//            .map({ personEntities in
//                personEntities.map { (personEntity) -> Person     in
//                    var person = Person()
//                    person.id = personEntity.id
//                    person.firstName = personEntity.firstName ?? ""
//                    person.lastName = personEntity.lastName ?? ""
//                    person.healthEntries = personEntity.healthEntities?.allObjects as? [HealthEntry] ?? []
//                    return person
//                }
//            })
//            .sink { error in
//                fatalError("Unable to sink: \(error)")
//            } receiveValue: { [weak self] persons in
//                self?.persons = persons
//            }
//            .store(in: &cancellables)
//    }
//
//    func getData() -> AnyPublisher<[Person], Error> {
//        $persons.tryMap({$0}).eraseToAnyPublisher()
//    }
//
//    func create(person: Person) {
//        let entity = PersonEntity(context: manager.context)
//        entity.id = person.id
//        entity.firstName = person.firstName
//        entity.lastName = person.lastName
//        entity.healthEntities = NSSet(array: person.healthEntries)
//        manager.save()
//        fetch()
//    }
//
//    func update(person: Person) {
//        guard let index = persons.firstIndex(where: {$0.id == person.id}) else { return }
//        let entity = personEntities[index]
//        entity.id = person.id
//        entity.firstName = person.firstName
//        entity.lastName = person.lastName
//        entity.healthEntities = NSSet(array: person.healthEntries)
//        manager.save()
//        fetch()
//    }
//
//    func delete(person: Person) {
//        guard let index = persons.firstIndex(where: {$0.id == person.id}) else { return }
//        manager.context.delete(personEntities[index])
//        manager.save()
//        fetch()
//    }
//}
//
//class PersonRepository : ObservableObject {
//    @Published var persons : [Person] = []
//    var dataService : PersonDataServiceProtocol
//
//    private var cancellables = Set<AnyCancellable>()
//
//    func create(person: Person) {
//        dataService.create(person: person)
//    }
//    func update(person: Person) {
//        dataService.update(person: person)
//    }
//    func delete(at offsets: IndexSet) {
//        guard let index = offsets.first else { return }
//        dataService.delete(person: persons[index])
//    }
//
//    init(dataService: PersonDataServiceProtocol){
//        self.dataService = dataService
//        dataService.getData()
//            .sink { error in
//                fatalError("Could not get data from DataService: \(error)")
//            } receiveValue: { [weak self] persons in
//                self?.persons = persons
//            }
//            .store(in: &cancellables)
//    }
//}
