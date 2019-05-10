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

var csv = "Image size,Number of iterations,Duration in seconds\n"

class CoreDataImageBenchmark: XCTestCase {
    
    typealias DataSample = (operation: String, iterations: Int, duration: TimeInterval)
    
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
    
    var repository: ImageRepository!
    
    override func setUp() {
        super.setUp()
        
        Benchmark.dataPoints = [1]
        Benchmark.iterationsPerDataPoint = 1
        
        do {
            let storage = try ImageStorage(name: "CoreDataImages-Article")
            repository = ImageRepository(container: container, imageStorage: storage)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    override func tearDown() {
        if let url = container.persistentStoreCoordinator.persistentStores.first?.url {
            do {
                try container.persistentStoreCoordinator.destroyPersistentStore(at: url, ofType: NSSQLiteStoreType, options: nil)
            } catch {
                print(error)
            }
        }
        super.tearDown()
    }
    
    override class func tearDown() {
        print(csv)
        super.tearDown()
    }
    
    func test_benchmarkFileSystemStorage() {
        runnerWrite(dataSet: "Image stored in file system",
               write: { _ = self.repository.makeImageStoredInFileSystem($0) })
    }
    
    func test_benchmarkFileSystemStorage_read() {
        runnerWrite(dataSet: "Read image stored in file system",
               write: { _ = self.repository.makeImageStoredInFileSystem($0) })
    }
    
    func test_benchmarkExternalStorage() {
        runnerWrite(dataSet: "Image blob with allowed external storage",
               write: { _ = self.repository.makeExternallyStoredImage($0) })
    }
    
    func test_benchmarkInternalStorage() {
        runnerWrite(dataSet: "Image blob stored in SQLite table",
               write: { _ = self.repository.makeInternallyStoredImage($0) })
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
        
        let load = { (id: NSManagedObjectID) in { read(id) } }
        
        let id = write(.extraSmall)
        measure(operation: "Extra small", prepare: { self.container.viewContext.reset() }, block: load(id))
    }
    
    private func measure(operation: String, prepare: () -> Void = { }, block: () -> Void) {
        var results: [DataSample] = []
        
        for dataPoint in Benchmark.dataPoints {
            prepare()
            let average = Benchmark.measureAverage(dataPoint: dataPoint) {
                block()
            }
            results.append((operation, dataPoint, average))
        }
        
        onSamplesCollected(results)
    }
    
    private func onSamplesCollected(_ results: [DataSample]) {
        for result in results {
            csv += "\(result.operation),\(result.iterations),\(result.duration)\n"
        }
    }
}
