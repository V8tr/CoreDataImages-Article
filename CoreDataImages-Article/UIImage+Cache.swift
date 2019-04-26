//
//  UIImage+Cache.swift
//  CoreDataImages-Article
//
//  Created by Vadym Bulavin on 4/25/19.
//  Copyright © 2019 Vadim Bulavin. All rights reserved.
//

import UIKit

extension UIImage {
    
    var hasAlpha: Bool {
        let result: Bool
        
        guard let alpha = cgImage?.alphaInfo else {
            return false
        }
        
        switch alpha {
        case .none, .noneSkipFirst, .noneSkipLast:
            result = false
        default:
            result = true
        }
        
        return result
    }
    
    func toData() -> Data? {
        return hasAlpha ? pngData() : jpegData(compressionQuality: 1.0)
    }
}
