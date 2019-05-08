//
//  ImageBlob+CoreDataProperties.swift
//  CoreDataImages-Article
//
//  Created by Vadym Bulavin on 5/8/19.
//  Copyright © 2019 Vadim Bulavin. All rights reserved.
//
//

import Foundation
import CoreData


extension ImageBlob {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageBlob> {
        return NSFetchRequest<ImageBlob>(entityName: "ImageBlob")
    }

    @NSManaged public var blob: NSData?

}
