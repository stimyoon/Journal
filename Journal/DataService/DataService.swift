//
//  DataService.swift
//  PracticeWithChris
//
//  Created by Tim Yoon on 2/8/22.
//

import Foundation
import Combine
import CoreData
import UIKit


protocol EntryDataServiceProtocol {
    func getData() -> AnyPublisher<[Entry], Error>
    func create(entry: Entry)
    func update(entry: Entry)
    func delete(entry: Entry)
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
                entryEntities.map {
                     self.getEntryWithEntryEntity(entity: $0)
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
//        var photoEntities : [PhotoEntity] = entry.photos.map { <#Photo#> in
//            <#code#>
//        }
//        }
//        entity.photos = NSSet(array: entry.)
    }
    
    enum SetEntryValuesError : Error {
        case timestampIsNil
        case dateCreatedIsNil
    }

    enum PhotoEntityError : Error {
        case unableToMakePhotoEntityArray
    }
    
    
    private func convertPhotoEntity_to_Photo(photoEntity: PhotoEntity) -> Photo {
        var photo = Photo()

        photo.id = photoEntity.id ?? UUID().uuidString
        photo.timestamp = photoEntity.timestamp ?? Date()
        guard let imageData = photoEntity.imageData,
              let uiImage = UIImage(data: imageData)
        else {
            return photo
        }

        photo.uiImage = uiImage
        
        return photo
    }

    
    
    private func getEntryWithEntryEntity( entity: EntryEntity) -> Entry {
        var entry = Entry()
        entry.id = entity.id
        entry.title = entity.title ?? ""
        entry.note = entity.note ?? ""
        entry.timestamp = entity.timestamp ?? Date()
        entry.dateCreated = entity.dateCreated ?? Date()
        
        if let photoEntityArray : [PhotoEntity] = entity.photos?.allObjects as? [PhotoEntity] {
            entry.photos = photoEntityArray.map({ PhotoEntity.convertPhotoEntity_to_Photo(photoEntity: $0) })
        } else {
            entry.photos = []
        }
        
        return entry
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
