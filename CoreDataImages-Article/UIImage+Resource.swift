//
//  UIImage+Resource.swift
//  CoreDataImages-Article
//
//  Created by Vadym Bulavin on 5/8/19.
//  Copyright © 2019 Vadim Bulavin. All rights reserved.
//

import UIKit

extension UIImage {
    
    static let extraSmall = image(fromFile: "extra-small")
    static let small = image(fromFile: "small")
    static let medium = image(fromFile: "medium")
    static let large = image(fromFile: "large")
    static let extraLarge = image(fromFile: "extra-large")
    
    private static func image(fromFile name: String) -> UIImage {
        if let path = Bundle.main.path(forResource: name, ofType: "png"),
            let image = UIImage(contentsOfFile: path) {
            return image
        }
        fatalError("Programmer error if image is missing.")
    }
}

