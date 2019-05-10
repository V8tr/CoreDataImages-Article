//
//  ImageWithFileSystemStorage+CoreDataProperties.swift
//  CoreDataImages-Article
//
//  Created by Vadym Bulavin on 5/10/19.
//  Copyright © 2019 Vadim Bulavin. All rights reserved.
//
//

import Foundation
import CoreData


extension ImageWithFileSystemStorage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageWithFileSystemStorage> {
        return NSFetchRequest<ImageWithFileSystemStorage>(entityName: "ImageWithFileSystemStorage")
    }

    @NSManaged public var id: UUID?

}
