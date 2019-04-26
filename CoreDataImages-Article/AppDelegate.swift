//
//  AppDelegate.swift
//  CoreDataImages-Article
//
//  Created by Vadym Bulavin on 4/24/19.
//  Copyright © 2019 Vadim Bulavin. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    static var shared: AppDelegate {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate
        }
        fatalError("App delegate is invalid")
    }
    
    lazy var imageStorage: ImageStorage = {
        do {
            return try ImageStorage(name: "CoreDataImages-Article")
        } catch {
            fatalError("Unresolved error \(error)")
        }
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let image = Image(context: persistentContainer.viewContext)
        let renderer = UIGraphicsImageRenderer(bounds: UIScreen.main.bounds)
        let snapshot = renderer.image { rendererContext in window?.layer.render(in: rendererContext.cgContext) }
        image.image = snapshot
        print(image.image)
        saveContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Image")
        fetchRequest.predicate = NSPredicate(format: "id == %@", image.id!.uuidString)
        
        let fetchedItem = try! persistentContainer.viewContext.fetch(fetchRequest).first as! Image
        print(fetchedItem.image)

        return true
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataImages_Article")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

