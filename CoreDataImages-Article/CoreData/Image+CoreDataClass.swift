//
//  Image+CoreDataClass.swift
//  CoreDataImages-Article
//
//  Created by Vadym Bulavin on 4/24/19.
//  Copyright © 2019 Vadim Bulavin. All rights reserved.
//
//

import UIKit
import CoreData

@objc(Image)
public class Image: NSManagedObject {
    
    lazy var image: UIImage? = {
        if let id = id?.uuidString {
            return try? AppDelegate.shared.imageStorage.image(forKey: id)
        }
        return nil
    }()
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID()
    }
    
    override public func didSave() {
        super.didSave()
        
        if let image = image, let id = id?.uuidString {
            try? AppDelegate.shared.imageStorage.setImage(image, forKey: id)
        }
    }
}
