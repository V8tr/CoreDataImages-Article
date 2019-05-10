//
//  ImageBlobWithInternalStorage+CoreDataProperties.swift
//  CoreDataImages-ArticleTests
//
//  Created by Vadym Bulavin on 5/10/19.
//  Copyright © 2019 Vadim Bulavin. All rights reserved.
//
//

import Foundation
import CoreData


extension ImageBlobWithInternalStorage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageBlobWithInternalStorage> {
        return NSFetchRequest<ImageBlobWithInternalStorage>(entityName: "ImageBlobWithInternalStorage")
    }

    @NSManaged public var blob: NSData?

}
