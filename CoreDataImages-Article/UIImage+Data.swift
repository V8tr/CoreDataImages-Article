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
    
    var sizeInBytes: Int {
        if let data = toData() {
            return data.count
        } else {
            return 0
        }
    }
    
    var sizeInMB: Double {
        return Double(sizeInBytes) / 1_000_000
    }
}
