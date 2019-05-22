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

var csv = "Image size,Duration in seconds\n"

struct DataSample {
    let operation: String
    let duration: TimeInterval
}

class CoreDataImageBenchmark: XCTestCase {
    
    let container: NSPersistentContainer = {
        // Create CoreData container
        let bundle = Bundle(for: CoreDataImageBenchmark.self)
        let model = NSManagedObjectModel.mergedModel(from: [bundle])
        let container = NSPersistentContainer(name: "CoreDataImages_Article", managedObjectModel: model!)
        
        // Force synchronous initialization
        let description = NSPersistentStoreDescription()
        description.shouldAddStoreAsynchronously = false
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { _, _ in }
        
        return container
    }()
    
    var repository: ImageDAO!
    
    override func setUp() {
        super.setUp()
        
        Benchmark.numberOfIterations = 10
        
        do {
            let storage = try ImageStorage(name: "CoreDataImages-Article")
            repository = ImageDAO(container: container, imageStorage: storage)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    override func tearDown() {
        dropTable()
        super.tearDown()
    }
    
    override class func tearDown() {
        print(csv)
        super.tearDown()
    }
    
    func test_benchmarkWrite_forFileSystemStorage() {
        runnerWrite(dataSet: "[WRITE] Image stored in file system",
                    write: { _ = self.repository.makeImageStoredInFileSystem($0) })
    }
    
    func test_benchmarkWrite_forExternalStorage() {
        runnerWrite(dataSet: "[WRITE] Image blob with allowed external storage",
                    write: { _ = self.repository.makeExternallyStoredImage($0) })
    }
    
    func test_benchmarkWrite_forInternalStorage() {
        runnerWrite(dataSet: "[WRITE] Image blob stored in SQLite table",
                    write: { _ = self.repository.makeInternallyStoredImage($0) })
    }
    
    func test_benchmarkRead_forFileSystemStorage() {
        runnerRead(dataSet: "[READ] Image stored in file system",
                   write: { self.repository.makeImageStoredInFileSystem($0).objectID },
                   read: { _ = self.repository.imageStoredInFileSystem(by: $0) })
    }
    
    func test_benchmarkRead_forExternalStorage() {
        runnerRead(dataSet: "[READ] Image blob with allowed external storage",
                   write: { self.repository.makeExternallyStoredImage($0).objectID },
                   read: { _ = self.repository.externallyStoredImage(by: $0) })
    }
    
    func test_benchmarkRead_forInternalStorage() {
        runnerRead(dataSet: "[READ] Image blob stored in SQLite table",
                   write: { self.repository.makeInternallyStoredImage($0).objectID },
                   read: { _ = self.repository.internallyStoredImage(by: $0) })
    }
    
    // MARK: - Helpers
    
    private func runnerWrite(dataSet: String, write: @escaping (UIImage) -> Void) {
        csv += "\(dataSet)\n"
        
        let save = { (image: UIImage) in { write(image) } }
        
        measure(operation: "Extra small", block: save(.extraSmall))
        measure(operation: "Small", block: save(.small))
        measure(operation: "Medium", block: save(.medium))
        measure(operation: "Large", block: save(.large))
        measure(operation: "Extra Large", block: save(.extraLarge))
    }
    
    private func runnerRead(dataSet: String,
                            write: @escaping (UIImage) -> NSManagedObjectID,
                            read: @escaping (NSManagedObjectID) -> Void) {
        
        csv += "\(dataSet)\n"
        
        var id: NSManagedObjectID!
        
        let prepare = { (image: UIImage) in {
            id = write(image)
            self.container.viewContext.reset()
            }
        }
        
        let load = { { read(id) } }
        
        measure(operation: "Extra small", prepare: prepare(.extraSmall), block: load())
        measure(operation: "Small", prepare: prepare(.small), block: load())
        measure(operation: "Medium", prepare: prepare(.medium), block: load())
        measure(operation: "Large", prepare: prepare(.large), block: load())
        measure(operation: "Extra large", prepare: prepare(.extraLarge), block: load())
    }
    
    private func measure(operation: String, prepare: () -> Void = { }, block: () -> Void) {
        var results: [DataSample] = []
        
        prepare()
        let average = Benchmark.measureAverage(prepare: prepare, block: block)
        results.append(.init(operation: operation, duration: average))
        
        onSamplesCollected(results)
    }
    
    private func onSamplesCollected(_ results: [DataSample]) {
        for result in results {
            csv += "\(result.operation),\(result.duration)\n"
        }
    }
    
    private func dropTable() {
        if let url = container.persistentStoreCoordinator.persistentStores.first?.url {
            do {
                try container.persistentStoreCoordinator.destroyPersistentStore(at: url, ofType: NSSQLiteStoreType, options: nil)
            } catch {
                print(error)
            }
        }
    }
}
