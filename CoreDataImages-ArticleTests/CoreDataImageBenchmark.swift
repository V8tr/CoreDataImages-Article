//
//  CoreDataImageBenchmark.swift
//  CoreDataImages-ArticleTests
//
//  Created by Vadym Bulavin on 5/8/19.
//  Copyright © 2019 Vadim Bulavin. All rights reserved.
//

import CoreData
import XCTest
@testable import CoreDataImages_Article

class CoreDataImageBenchmark: XCTestCase {
    
    let container: NSPersistentContainer = {
        let model = NSManagedObjectModel.mergedModel(from: [Bundle(for: CoreDataImageBenchmark.self)])
        let container = NSPersistentContainer(name: "CoreDataImages_Article", managedObjectModel: model!)
        
        let description = NSPersistentStoreDescription()
        description.shouldAddStoreAsynchronously = false
        container.persistentStoreDescriptions = [description]
        
        return container
    }()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        do {
            try container.viewContext.execute(NSBatchDeleteRequest(fetchRequest: Image.fetchRequest()))
            try container.viewContext.execute(NSBatchDeleteRequest(fetchRequest: ImageBlob.fetchRequest()))
            try container.viewContext.execute(NSBatchDeleteRequest(fetchRequest: ImageInternalBlob.fetchRequest()))
        } catch {
            fatalError("Something went wrong")
        }
        
        super.tearDown()
    }
    
    
}
