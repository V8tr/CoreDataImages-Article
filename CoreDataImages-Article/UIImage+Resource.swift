//
//  UIImage+Resource.swift
//  CoreDataImages-Article
//
//  Created by Vadym Bulavin on 5/8/19.
//  Copyright © 2019 Vadim Bulavin. All rights reserved.
//

import UIKit

extension UIImage {

    static var iphoneXSMax: UIImage {
        if let path = Bundle.main.path(forResource: "iPhone-XS-Max-Portrait-Space-Gray", ofType: "png"),
            let image = UIImage(contentsOfFile: path) {
            return image
        }
        fatalError("Programmer error if image is missing.")
    }
}
