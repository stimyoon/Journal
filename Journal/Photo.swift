//
//  Photo.swift
//  Journal
//
//  Created by Tim Yoon on 2/16/22.
//

import SwiftUI
import Combine
import CoreData

struct Photo : Identifiable {
    var id: String = UUID().uuidString
    var timestamp : Date = Date()
    var uiImage : UIImage?
    var image : Image? {
        guard let uiImage = self.uiImage else { return nil }
        return Image(uiImage: uiImage)
    }
}

protocol PhotoDataServiceProtocol {
    func getData() -> AnyPublisher<[PhotoEntity], Error>
    func create(photo: Photo)
    func update(photo: Photo)
    func delete(photo: Photo)
}

//class PhotoCoreDataService : ObservableObject, PhotoDataServiceProtocol {
//    @Published private (set) var photos : [Photo] = []
//    @Published private var photoEntities : [PhotoEntity] = []
//    let manager = PersistenceController.shared
//    private var cancellables = Set<AnyCancellable>()
//    
//    init() {
//        fetch()
//        $photoEntities.map { photoEntities in
//            photoEntities.map { <#PhotoEntity#> in
//                <#code#>
//            }
//        }
//    }
//    func getPhotoFromPhotoEntity( photoEntity: PhotoEntity ) throws -> Photo {
//        var photo = Photo()
//        photo.id = photoEntity.id
//        guard let imageData = photoEntity.imageData else {
//            
//        }
//        photo.uiImage = photoEntity
//        return photo
//    }
//    func fetch() {
//        let request = NSFetchRequest<PhotoEntity>(entityName: "PhotoEntity")
//        let sort = [NSSortDescriptor(key: "timestamp", ascending: true)]
//        request.sortDescriptors = sort
//        
//        do {
//            photoEntities = try manager.context.fetch(request)
//        } catch let error {
//            fatalError("Unable to fetch from CoreData. \(error)")
//        }
//    }
//    func getData() -> AnyPublisher<[PhotoEntity], Error> {
//        <#code#>
//    }
//    
//    func create(photo: Photo) {
//        <#code#>
//    }
//    
//    func update(photo: Photo) {
//        <#code#>
//    }
//    
//    func delete(photo: Photo) {
//        <#code#>
//    }
//}
