//
//  Optional+Ext.swift
//  CoreDataImages-Article
//
//  Created by Vadym Bulavin on 5/10/19.
//  Copyright © 2019 Vadim Bulavin. All rights reserved.
//

import Foundation

extension Optional {
    
    func unwrapOrThrow(_ error: Error) throws -> Wrapped {
        if let value = self {
            return value
        } else {
            throw error
        }
    }
}
