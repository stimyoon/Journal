//
//  SunSetVM.swift
//  Journal
//
//  Created by Tim Yoon on 2/17/22.
//

import SwiftUI
import CoreData
import Combine

class SunSetVM : ObservableObject {
    @Published var image : Image?
    @Published var photos : [Photo] = []
    @Published var entry : Entry = Entry()
    @Published var showingImagePicker = false
    @Published var inputImage: UIImage?
    var photoEntities : [PhotoEntity] = []
    let imageID = "UpperImage"
    
    let manager = PersistenceController.shared
    
    func loadImage() {
        guard let inputImage = self.inputImage else { return }
        self.image = Image(uiImage: inputImage)
        saveImageToCoreData()
    }
    func saveImageToCoreData(){
        guard let inputImage = inputImage else {
            return
        }
        var index = photoEntities.firstIndex(where: {$0.id == imageID})
        if index == nil {
            let entity = PhotoEntity(context: manager.context)
            entity.id = imageID
            photoEntities.append(entity)
            manager.save()
            index = photoEntities.firstIndex(where: {$0.id == imageID})
        }
        guard let index = index else {
            return
        }
        
        photoEntities[index].imageData = inputImage.jpegData(compressionQuality: 1.0)
        manager.save()
        
    }
    func fetchImageFromCoreData(){
        let request = NSFetchRequest<PhotoEntity>(entityName: "PhotoEntity")
        request.predicate = NSPredicate(format: "id == %@", imageID)
        do {
            photoEntities = try manager.context.fetch(request)
        } catch let error {
            print(error)
        }
        guard let index = photoEntities.firstIndex(where: {$0.id == imageID}),
              let imageData = photoEntities[index].imageData,
              let uiImage = UIImage(data: imageData)
        else { return }
        image = Image(uiImage: uiImage)
    }
    init(){
        fetchImageFromCoreData()
    }
}
