//
//  CoreDataManager.swift
//
//  Created by Rafael Gil Pastor on 25/12/2018.
//  Copyright © 2018 Rafael Gil. All rights reserved.
//

import Foundation
import CoreData

public enum CoreDataManagerErrors: Int {
    
    case CreationCoordinatorError
    
    public func description() -> (String) {
        switch self {
        case .CreationCoordinatorError:
            return "Unable to get instance for persistent coordinator"
        }
    }
}

public typealias CoreDataManagerCompletion = (Error?) -> Void

public class CoreDataManager {
    
    /// PRIVATE SECTION
    
    private let modelName: String
    
    //The Managed Object Model, created from a .momd file (model) in the main bundle, whose name is fetched from the constructor (modelName)
    private lazy var managedObjectModel: NSManagedObjectModel? = {
        
        guard let urlModel =  Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
            return nil
        }
        return NSManagedObjectModel(contentsOf: urlModel)
    }()
    
    //URL of the Persistent Store of sqlLite type, whose name is fetched from the constructor (modelName).
    //This store must be in the user document´s diretory
    private lazy var persistentStoreURL: URL? = {
        
        let urlsDocuments = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard urlsDocuments.count > 0 else {
            return nil
        }
        return urlsDocuments[0].appendingPathComponent("\(self.modelName).sqlite")
    }()
    
    //The Persistent Store Coordinator. It is created through the managed object model
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {

        guard let managedObjectModel = self.managedObjectModel else {
            return nil
        }
        return NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
    }()

    //An internal Private Manage Object Context that operates directly with the persistennt store coordinator in background queue
    private lazy var privateManagedObjectContext: NSManagedObjectContext = {
        
        // Initialize Managed Object Context
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        // Configure Managed Object Context
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    //Main Managed Object Context that operates in main thread (UI) and it´s created as child of an internal private m.o.c.
    //This main m.o.c. doesn´t operate directly with the persistent coordinator, to avoid operations in the main thread freezes the ui
    private lazy var mainManagedObjectContext: NSManagedObjectContext = {
        // Initialize Managed Object Context
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        // Configure Managed Object Context
        managedObjectContext.parent = self.privateManagedObjectContext
        
        return managedObjectContext
    }()
    
    /// AUXILIARY METHODS
    
    //Add a persistent store whose url is passed as first parameter, to the referenced coordinator in the second parameter.
    //By default the type of store is SQLLite and enables automatic migrations
    private func addPersistentStore(withURL storeURL: URL?, toCoordinator coordinator: NSPersistentStoreCoordinator?) -> (Error?) {
        
        //add persistent store of type SQLLite and with automatic migration
        do {
            let options = [ NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true ]
            try coordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
            
        } catch {
            return error
        }
        
        return nil
    }
    
    //Setup the whole core data stack, with a private managed object context that operates directly with the persistent store coordinator,
    //and a main managed object context as child of the private one, that enables the core data operations in main thread
    //The persistent store has to be a SQLLite database in user document´s directory and its name is the same as the model
    private func setupCoreDataStack(onCompletion completion: CoreDataManagerCompletion?) {
        
        guard let coordinator = self.persistentStoreCoordinator else {
            completion?(NSError(domain: "es.rgp.coredatamanager", code: CoreDataManagerErrors.CreationCoordinatorError.rawValue, userInfo: [NSLocalizedDescriptionKey : CoreDataManagerErrors.CreationCoordinatorError.description()]))
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            guard let self = self else {
                return
            }
            let error = self.addPersistentStore(withURL: self.persistentStoreURL, toCoordinator: coordinator)
            DispatchQueue.main.async {
                completion?(error)
            }
        }
    }
    
    /// CONSTRUCTOR
    
    //constructor with model name passed in as parameter for building of model and store url names. A block is used to inform when core data stack is completed.
    public init(withModelName modelName: String, onCompletion completion: CoreDataManagerCompletion?) {
        
        self.modelName = modelName
        setupCoreDataStack { (error) in
            completion?(error)
        }
    }
}

public extension CoreDataManager {
    
    /// PUBLIC SECTION
    
    //Main managed object context for operations in main thread
    public var mainThreadObjectContext: NSManagedObjectContext  {
        return self.mainManagedObjectContext
    }
    
    //Create and return a new private m.o.c. as child of our main m.o.c.
    //This m.o.c. should be used for background operations
    public func newBackgroundObjectContext() -> (NSManagedObjectContext) {
        
        //create a new private m.o.c. as child of our main m.o.c.
        let childObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        childObjectContext.parent = self.mainManagedObjectContext
        
        return childObjectContext
    }
    
    //Save all changes in then main and private mamaged object contexts
    public func saveChanges(onCompletion completion: CoreDataManagerCompletion?){
        
        //First, push those in main m.o.c. to the internal private m.o.c, and wait for these changes are saved.
        mainManagedObjectContext.performAndWait({
            do {
                if self.mainManagedObjectContext.hasChanges {
                    try self.mainManagedObjectContext.save()
                }
            } catch {
                completion?(error)
            }
        })
        //Push all the changes of the private m.o.c. in the persistent store.
        privateManagedObjectContext.perform({
            do {
                if self.privateManagedObjectContext.hasChanges {
                    try self.privateManagedObjectContext.save()
                    completion?(nil)
                }
            } catch {
                completion?(error)
            }
        })
    }
}
