//
//  ImageWithFileSystemStorage+CoreDataClass.swift
//  CoreDataImages-Article
//
//  Created by Vadym Bulavin on 5/10/19.
//  Copyright © 2019 Vadim Bulavin. All rights reserved.
//
//

import UIKit
import CoreData

@objc(ImageWithFileSystemStorage)
public class ImageWithFileSystemStorage: NSManagedObject {
    lazy var image: UIImage? = {
        if let id = id?.uuidString {
            return try? storage?.image(forKey: id)
        }
        return nil
    }()
    
    var storage: ImageStorage?
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID()
    }
    
    override public func didSave() {
        super.didSave()
        
        if let image = image, let id = id?.uuidString {
            try? storage?.setImage(image, forKey: id)
        }
    }
}
