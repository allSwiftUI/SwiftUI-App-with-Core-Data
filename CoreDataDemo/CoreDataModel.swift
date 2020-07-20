// -----------------------------------------------------------------------------
// File: CoreDataModel.swift
// Package: CoreDataDemo
//
// Created by: ALLSWIFTUI on 17-07-20
// Copyright © 2020 allSwiftUI · https://allswiftui.com · @allswiftui
// -----------------------------------------------------------------------------

import CoreData

// MARK: - CoreDataStack
// We wraping the persistent container in a struct and expose the view context as a static property.
// Then we'll be able to access it from both the App, any view in the hierarchy and previews.

struct CoreDataStack {
    
    // MARK: - The Persistent Store Container
    // NSPersistentContainer is responsible for creation and management of the Core Data stack. NSPersistentContainer exposes a managed object model, a managed object context and a persistent store coordinator (the store coordinator and the persistent store) as well as provides many convenience methods when working them, especially when it comes to multithreaded applications.
    public static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Nekos")
        container.loadPersistentStores{ (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            print("Core Data stack has been initialized with: \(storeDescription)")
        }
        return container
    }()
    
    
    // MARK: - The Managed Object Context
    // viewContext is a reference to the managed object context associated with the main queue. It is created automatically during the initialization process and is directly connected to a NSPersistentStoreCoordinator, so it might freeze the application when performing heavy operations.
    // A context is an in-mmemory scratchpad for working with the managed objects.
    // We do all of the work with the Core Data objects within a managed object context.
    // Any changes we make won't affect the underlying data on disk until we call saveContext() on the context.
    static var context: NSManagedObjectContext { persistentContainer.viewContext }
    
    
    // MARK: - Define save for context
    // Responsible for calling the context save method, whenever there have been changes (hasChanges) in the context.
    public static func saveContext () {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
