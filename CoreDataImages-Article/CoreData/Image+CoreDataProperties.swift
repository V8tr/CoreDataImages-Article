//
//  Image+CoreDataProperties.swift
//  CoreDataImages-Article
//
//  Created by Vadym Bulavin on 4/26/19.
//  Copyright © 2019 Vadim Bulavin. All rights reserved.
//
//

import UIKit
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var id: UUID?

}
