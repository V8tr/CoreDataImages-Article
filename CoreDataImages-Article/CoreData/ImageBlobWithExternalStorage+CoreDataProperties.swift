//
//  ImageBlobWithExternalStorage+CoreDataProperties.swift
//  CoreDataImages-ArticleTests
//
//  Created by Vadym Bulavin on 5/10/19.
//  Copyright © 2019 Vadim Bulavin. All rights reserved.
//
//

import Foundation
import CoreData


extension ImageBlobWithExternalStorage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageBlobWithExternalStorage> {
        return NSFetchRequest<ImageBlobWithExternalStorage>(entityName: "ImageBlobWithExternalStorage")
    }

    @NSManaged public var blob: NSData?

}
