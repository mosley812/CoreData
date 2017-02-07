//
//  CoreDataController.swift
//  CoreData1
//
//  Created by Ed Mosher on 2/7/17.
//  Copyright © 2017 Ed Mosher. All rights reserved.
//

import Foundation
import CoreData

class CoreDataController {
  
  // Not sure why this was added
  private init() {
  }
  
  // Set up the Managed Object Context
  class func getContext() -> NSManagedObjectContext {
    return CoreDataController.persistentContainer.viewContext
  }
  
  // MARK: - Core Data stack
  static var persistentContainer: NSPersistentContainer = {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    let container = NSPersistentContainer(name: "CoreData1")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  // MARK: - Core Data Saving support
  class func saveContext () {
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

