//
//  SampleData.swift
//  CoreDataImages-ArticleTests
//
//  Created by Vadym Bulavin on 5/23/19.
//  Copyright © 2019 Vadim Bulavin. All rights reserved.
//

import UIKit
@testable import CoreDataImages_Article

enum SampleData {
    
    static var images: [UIImage] = []
    
    static func initialize() {
        images = []
        for size in stride(from: 0, to: 40_000, by: 1_000) {
            autoreleasepool {
                print(size)
                let image = UIImage.fromColor(.white, size: CGSize(width: size, height: size))
                images.append(image)
            }
        }
    }
}
