//
//  ImageRepository.swift
//  CoreDataImages-Article
//
//  Created by Vadym Bulavin on 5/8/19.
//  Copyright © 2019 Vadim Bulavin. All rights reserved.
//

import CoreData
import class UIKit.UIImage

class ImageRepository {
    private let container: NSPersistentContainer
    private let imageStorage: ImageStorage

    init(container: NSPersistentContainer, imageStorage: ImageStorage) {
        self.container = container
        self.imageStorage = imageStorage
    }

    func makeImage() -> Image {
        let image = Image(context: container.viewContext)
        image.storage = imageStorage
        image.image = UIImage.iphoneXSMax
        saveContext()
        return image
    }
    
    func makeImageBlob() -> ImageBlob {
        let image = ImageBlob(context: container.viewContext)
        image.blob = UIImage.iphoneXSMax.toData() as NSData?
        saveContext()
        return image
    }
    
    func makeInternallyStoredImage() -> ImageInternalBlob {
        let image = ImageInternalBlob(context: container.viewContext)
        image.blob = UIImage.iphoneXSMax.toData() as NSData?
        saveContext()
        return image
    }
    
    func image(by id: NSManagedObjectID) -> Image {
        let image = container.viewContext.object(with: id) as! Image
        image.storage = imageStorage
        return image
    }
    
    func imageBlob(by id: NSManagedObjectID) -> ImageBlob {
        return container.viewContext.object(with: id) as! ImageBlob
    }
    
    func internallyStoredImage(by id: NSManagedObjectID) -> ImageInternalBlob {
        return container.viewContext.object(with: id) as! ImageInternalBlob
    }

    private func saveContext() {
        try! container.viewContext.save()
    }
}
