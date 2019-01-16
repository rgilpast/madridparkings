//
//  MPDatabaseManager.swift
//  MadridParkings
//
//  Created by Rafael Gil Pastor on 13/01/2019.
//  Copyright © 2019 Rafael Gil. All rights reserved.
//

import Foundation
import CoreData

public enum MPDatabaseManagerError: Int {
    
    case DatabaseNotInitiated
    case ErrorFetchingItems
    case ErrorSavingItems
    case ErrorDeletingItems
    case NoItemsReceived
    
    public func toNSError() -> NSError {
        
        switch self {
        case .DatabaseNotInitiated:
            return NSError(domain: "es.rgp.madridparkings.mpdatabasemanager", code: MPDatabaseManagerError.DatabaseNotInitiated.rawValue, userInfo: [NSLocalizedDescriptionKey : "Database is not initiated properly"])
        case .ErrorFetchingItems:
            return NSError(domain: "es.rgp.madridparkings.mpdatabasemanager", code: MPDatabaseManagerError.ErrorFetchingItems.rawValue, userInfo: [NSLocalizedDescriptionKey : "Error fetching items"])
        case .ErrorSavingItems:
            return NSError(domain: "es.rgp.madridparkings.mpdatabasemanager", code: MPDatabaseManagerError.ErrorSavingItems.rawValue, userInfo: [NSLocalizedDescriptionKey : "Error saving items"])
        case .ErrorDeletingItems:
            return NSError(domain: "es.rgp.madridparkings.mpdatabasemanager", code: MPDatabaseManagerError.ErrorDeletingItems.rawValue, userInfo: [NSLocalizedDescriptionKey : "Error deleting items"])
        case .NoItemsReceived:
            return NSError(domain: "es.rgp.madridparkings.mpdatabasemanager", code: MPDatabaseManagerError.NoItemsReceived.rawValue, userInfo: [NSLocalizedDescriptionKey : "No items received to complete operation"])
        }
    }
}

@objc public class MPDatabaseManager: NSObject, PersistenceManagerProtocol {

    public typealias T = MPEntityBaseProtocol
    
    private var manager: CoreDataManager?

    private func sharedInstanceManager(completion: @escaping (_ error: Error?) -> Void) {
        
        guard let _ = self.manager else {
            self.manager = CoreDataManager(withModelName: MPDatabaseManagerConstants.kDatabaseName, onCompletion: completion)
            return
        }
        completion(nil)
    }

    public func getItems(fromResource resource: String, completion: @escaping (_ items: [T]?, _ error: Error?) -> Void) {
        
        self.sharedInstanceManager { [weak self] (error) in
            
            guard let manager = self?.manager else {
                completion(nil, MPDatabaseManagerError.DatabaseNotInitiated.toNSError())
                return
            }
            
            let moc = manager.mainThreadObjectContext
            moc.perform {
                self?.getAllItems(inContext: moc, fromResource: resource, completion: completion)
            }
        }
    }
    
    public func eraseItems(fromResource resource: String, completion: @escaping ( _ error: Error?) -> Void) {
       
        self.sharedInstanceManager { [weak self] (error) in

            guard let manager = self?.manager else {
                completion(MPDatabaseManagerError.DatabaseNotInitiated.toNSError())
                return
            }
            
            let moc = manager.newBackgroundObjectContext()
            moc.perform {
                
                self?.deleteAllItems(inContext: moc, fromResource: resource, completion: { (error) in
                    guard error == nil else {
                        completion(error)
                        return
                    }
                    //save all changes (deletions) on database
                    manager.saveChanges(onCompletion: { (error) in
                        completion(error)
                    })
                })
            }
        }
    }
    
    public func saveItems(inResource resource: String, items: [T], completion: @escaping ( _ error: Error?) -> Void) {
       
        self.sharedInstanceManager { [weak self] (error) in
            
            guard let manager = self?.manager else {
                completion(MPDatabaseManagerError.DatabaseNotInitiated.toNSError())
                return
            }
            
            let moc = manager.newBackgroundObjectContext()
            moc.perform {
                //delete all existent items before save the received ones. This operation doesn´t update existent items
                self?.deleteAllItems(inContext: moc, fromResource: resource, completion: { (error) in
                    
                    guard error == nil else {
                        completion(error)
                        return
                    }
                    self?.insert(items: items, inContext: moc, inResource: resource, completion: { (error) in
                        guard error == nil else {
                            completion(error)
                            return
                        }
                        //save all changes (deletions and insertions) on database
                        manager.saveChanges(onCompletion: { (error) in
                            completion(error)
                        })
                    })
                })
            }
        }
    }
}

private extension MPDatabaseManager {
    
    private func insert(items: [T], inContext context: NSManagedObjectContext, inResource resource: String, completion: @escaping (_ error: Error?) -> Void) {

        //insert the received items in the resource (database entity)
        for item in items {
            if let newItem = NSEntityDescription.insertNewObject(forEntityName: resource, into: context) as? MPEntityMO {
                newItem.setValues(fromItem: item)
            } else {
                completion(MPDatabaseManagerError.ErrorSavingItems.toNSError())
                return
            }
        }
        do {
            //save item insertions in the context
            try context.save()
            completion(nil)
        }
        catch { completion(MPDatabaseManagerError.ErrorSavingItems.toNSError()) }
    }
    
    private func deleteAllItems(inContext context: NSManagedObjectContext, fromResource resource: String, completion: @escaping (_ error: Error?) -> Void) {
        
        self.getAllItems(inContext: context, fromResource: resource, completion: { (items, error) in
            
            guard error == nil else {
                completion(error)
                return
            }
            guard let items = items else {
                completion(nil)
                return
            }
            for item in items {
                context.delete(item)
            }
            do {
                try context.save()
                completion(nil)
            } catch {
                completion(MPDatabaseManagerError.ErrorDeletingItems.toNSError())
            }
        })
    }
    
    private func getAllItems(inContext context: NSManagedObjectContext, fromResource resource: String, completion: @escaping (_ items: [MPEntityMO]?, _ error: Error?) -> Void) {
        
        var fetchedEntities: [MPEntityMO]?
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: resource)
        do {
            fetchedEntities = try context.fetch(fetchReq) as? [MPEntityMO]
            completion(fetchedEntities, nil)
        } catch {
            completion(nil, MPDatabaseManagerError.ErrorFetchingItems.toNSError())
        }
    }
}

@objc extension MPDatabaseManager: MPOfflineDataManagerProtocol {
    
    @nonobjc private func getItems(ofType type: MPEntityProtocol.Type, fromResource resource: String,onCompletion completion: (([MPEntityProtocol]?, NSError?) -> Void)?) {

        self.getItems(fromResource: resource) { (items, error) in
            
            guard error == nil else {
                completion?(nil, MPDatabaseManagerError.ErrorFetchingItems.toNSError())
                return
            }
            let mappedItems = items?.map({ (item) -> MPEntityProtocol in
                return type.init(fromItem: item)
            })
            completion?(mappedItems, nil)
        }
    }

    @nonobjc private func saveItems(items: [MPEntityProtocol]?, inResource resource: String, onCompletion completion: (([MPEntityProtocol]?, NSError?) -> Void)?) {
        
        guard let items = items else {
            completion?(nil, MPDatabaseManagerError.NoItemsReceived.toNSError())
            return
        }
        self.saveItems(inResource: resource, items: items) { (error) in
            completion?(nil, error as NSError?)
        }
    }

    @nonobjc private func eraseItems(inResource resource: String, onCompletion completion: (([MPEntityProtocol]?, NSError?) -> Void)?) {
        
        self.eraseItems(fromResource: resource) { (error) in
            completion?(nil, error as NSError?)
        }
    }

    public func getPublicParkings(onCompletion completion: MPDataManagerResponse?) {
        
        self.getItems(ofType: MPPublicParkings.self, fromResource: MPDatabaseManagerConstants.kPublicParkingsEntityName, onCompletion: completion)
    }
    
    public func getResidentParkings(onCompletion completion: MPDataManagerResponse?) {
        
        self.getItems(ofType: MPResidentParkings.self, fromResource: MPDatabaseManagerConstants.kResidentParkingsEntityName, onCompletion: completion)
    }
    
    public func getVehicleDeposits(onCompletion completion: MPDataManagerResponse?) {
        
        self.getItems(ofType: MPVehicleDeposits.self, fromResource: MPDatabaseManagerConstants.kVehicleDepositsEntityName, onCompletion: completion)
    }
    
    public func savePublicParkings(parkings: [MPPublicParkings]?, onCompletion completion: MPDataManagerResponse?) {
        
        self.saveItems(items: parkings, inResource: MPDatabaseManagerConstants.kPublicParkingsEntityName, onCompletion: completion)
    }
    
    public func saveResidentParkings(parkings: [MPResidentParkings]?, onCompletion completion: MPDataManagerResponse?) {
        
        self.saveItems(items: parkings, inResource: MPDatabaseManagerConstants.kResidentParkingsEntityName, onCompletion: completion)
    }
    
    public func saveVehicleDeposits(deposits: [MPVehicleDeposits]?, onCompletion completion: MPDataManagerResponse?) {
        
        self.saveItems(items: deposits, inResource: MPDatabaseManagerConstants.kVehicleDepositsEntityName, onCompletion: completion)
    }
    
    public func erasePublicParkings(onCompletion completion: MPDataManagerResponse?) {
        self.eraseItems(inResource: MPDatabaseManagerConstants.kPublicParkingsEntityName, onCompletion: completion)
    }
    
    public func eraseResidentParkings(onCompletion completion: MPDataManagerResponse?) {
        self.eraseItems(inResource: MPDatabaseManagerConstants.kResidentParkingsEntityName, onCompletion: completion)
    }
    
    public func eraseVehicleDeposits(onCompletion completion: MPDataManagerResponse?) {
        self.eraseItems(inResource: MPDatabaseManagerConstants.kVehicleDepositsEntityName, onCompletion: completion)
    }
}

private struct MPDatabaseManagerConstants {
    
    public static let kDatabaseName = "MadridParkings"
    public static let kPublicParkingsEntityName = "MPPublicParkingsMO"
    public static let kResidentParkingsEntityName = "MPResidentsParkingsMO"
    public static let kVehicleDepositsEntityName = "MPVehicleDepositsMO"
}
