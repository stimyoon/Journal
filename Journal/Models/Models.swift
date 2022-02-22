//
//  Photo.swift
//  Journal
//
//  Created by Tim Yoon on 2/16/22.
//

import SwiftUI

struct Photo : Identifiable {
    var id: String = UUID().uuidString
    var title: String = ""
    var timestamp : Date = Date()
    var uiImage : UIImage?
    var image : Image? {
        guard let uiImage = self.uiImage else { return nil }
        return Image(uiImage: uiImage)
    }
    static let mockData : [Photo] = [
        Photo(title: "Lady with flower", uiImage: UIImage(named: "Image1")),
        Photo(title: "balloons", uiImage: UIImage(named: "Image2")),
        Photo(title: "blank", uiImage: nil)
    ]
}

struct Entry : Identifiable {
    var id : String? = UUID().uuidString
    var dateCreated : Date = Date()
    var timestamp : Date = Date()
    var title = ""
    var note = ""
    var photos : [Photo] = []
}

extension PhotoEntity {
    static func convertPhotoEntity_to_Photo(photoEntity: PhotoEntity) -> Photo {
        var photo = Photo()
        photo.id = photoEntity.id ?? UUID().uuidString
        photo.title = photoEntity.title ?? ""
        photo.timestamp = photoEntity.timestamp ?? Date()
        if let imageData = photoEntity.imageData {
            photo.uiImage = UIImage(data: imageData)
        }
        return photo
    }
    func setEntityValue(photo: Photo) {
        self.id = photo.id
        self.timestamp = photo.timestamp
        self.title = photo.title
        self.imageData = photo.uiImage?.jpegData(compressionQuality: 1.0)
    }
}

extension EntryEntity {
    func setPhotoValues(photos: [Photo]) {
        
    }
}
