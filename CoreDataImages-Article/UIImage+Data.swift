//
//  UIImage+Data.swift
//  CoreDataImages-Article
//
//  Created by Vadym Bulavin on 5/22/19.
//  Copyright © 2019 Vadim Bulavin. All rights reserved.
//

import UIKit

extension UIImage {
    
    func toData() -> Data? {
        return pngData()
    }
}
