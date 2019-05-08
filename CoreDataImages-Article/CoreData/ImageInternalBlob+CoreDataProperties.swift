//
//  ImageInternalBlob+CoreDataProperties.swift
//  CoreDataImages-Article
//
//  Created by Vadym Bulavin on 5/8/19.
//  Copyright © 2019 Vadim Bulavin. All rights reserved.
//
//

import Foundation
import CoreData


extension ImageInternalBlob {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageInternalBlob> {
        return NSFetchRequest<ImageInternalBlob>(entityName: "ImageInternalBlob")
    }

    @NSManaged public var blob: NSData?

}
