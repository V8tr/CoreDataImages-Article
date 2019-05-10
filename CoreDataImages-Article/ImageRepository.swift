//
//  ImageRepository.swift
//  CoreDataImages-Article
//
//  Created by Vadym Bulavin on 5/8/19.
//  Copyright © 2019 Vadim Bulavin. All rights reserved.
//

import CoreData
import class UIKit.UIImage

/// Saves and loads images from CoreData.
class ImageRepository {
    private let container: NSPersistentContainer
    private let imageStorage: ImageStorage

    init(container: NSPersistentContainer, imageStorage: ImageStorage) {
        self.container = container
        self.imageStorage = imageStorage
    }

    func makeImageStoredInFileSystem(_ bitmap: UIImage) -> ImageWithFileSystemStorage {
        let image = insert(ImageWithFileSystemStorage.self, into: container.viewContext)
        image.storage = imageStorage
        image.image = bitmap
        saveContext()
        return image
    }
    
    func makeExternallyStoredImage(_ bitmap: UIImage) -> ImageBlobWithExternalStorage {
        let image = insert(ImageBlobWithExternalStorage.self, into: container.viewContext)
        image.blob = bitmap.toData() as NSData?
        saveContext()
        return image
    }
    
    func makeInternallyStoredImage(_ bitmap: UIImage) -> ImageBlobWithInternalStorage {
        let image = insert(ImageBlobWithInternalStorage.self, into: container.viewContext)
        image.blob = bitmap.toData() as NSData?
        saveContext()
        return image
    }
    
    func imageStoredInFileSystem(by id: NSManagedObjectID) -> ImageWithFileSystemStorage {
        let image = container.viewContext.object(with: id) as! ImageWithFileSystemStorage
        image.storage = imageStorage
        return image
    }
    
    func externallyStoredImage(by id: NSManagedObjectID) -> ImageBlobWithExternalStorage {
        return container.viewContext.object(with: id) as! ImageBlobWithExternalStorage
    }
    
    func internallyStoredImage(by id: NSManagedObjectID) -> ImageBlobWithInternalStorage {
        return container.viewContext.object(with: id) as! ImageBlobWithInternalStorage
    }

    private func saveContext() {
        try! container.viewContext.save()
    }
    
    private func insert<T>(_ type: T.Type, into context: NSManagedObjectContext) -> T {
        return NSEntityDescription.insertNewObject(forEntityName: String(describing: T.self), into: context) as! T
    }
}
