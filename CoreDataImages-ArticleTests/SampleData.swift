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
        images = stride(from: 0, to: 1_000_000, by: 1_000).map {
            print($0)
            UIImage.fromColor(.white, size: CGSize(width: $0, height: $0))
        }
    }
}
