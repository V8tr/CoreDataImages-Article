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

var csv = "Image size in bytes,Duration in seconds\n"

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
    
    override class func setUp() {
        Benchmark.numberOfIterations = 1
        SampleData.initialize()
        print("✅ Sample data has been initialized.")
        super.tearDown()
    }
    
    override func setUp() {
        super.setUp()
        
        do {
            let storage = try ImageStorage(name: "CoreDataImages-Article")
            repository = ImageDAO(container: container, imageStorage: storage)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    override func tearDown() {
        container.dropTable()
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
        
        for sampleImage in SampleData.images {
            measure(image: sampleImage, prepare: {}, block: save(sampleImage))
        }
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
        
        for sampleImage in SampleData.images {
            measure(image: sampleImage, prepare: prepare(sampleImage), block: load())
        }
    }
    
    private func measure(image: UIImage, prepare: () -> Void, block: () -> Void) {
        let duration = Benchmark.measureAverage(prepare: prepare, block: block)
        let result = Measurement(sizeInBytes: image.sizeInBytes, duration: duration)
        csv += "\(result.sizeInBytes),\(result.duration)\n"
    }
}

private extension NSPersistentContainer {
    func dropTable() {
        if let url = persistentStoreCoordinator.persistentStores.first?.url {
            do {
                try persistentStoreCoordinator.destroyPersistentStore(at: url, ofType: NSSQLiteStoreType, options: nil)
            } catch {
                print(error)
            }
        }
    }
}
