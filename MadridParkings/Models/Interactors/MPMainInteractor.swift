//
//  MPMainInteractor.swift
//  MadridParkings
//
//  Created by Rafael Gil Pastor on 16/01/2019.
//  Copyright © 2019 Rafael Gil. All rights reserved.
//

import Foundation

@objc public class MPMainInteractor: NSObject, MPMainInteractorProtocol {
    
    private var onlineManager: MPOnlineDataManagerProtocol
    private var offlineManager: MPOfflineDataManagerProtocol?

    private lazy var versionManager: MPVersionManagerProtocol = {
        return MPVersionManager()
    }()
    
    @objc public required init(withOnlineManager onlineManager: MPOnlineDataManagerProtocol, withOfflineManager offlineManager: MPOfflineDataManagerProtocol?) {
        
        self.onlineManager = onlineManager
        self.offlineManager = offlineManager
    }
    
    @objc public func getPublicParkings(onCompletion completion: MPMainInteractorResponse?) {
        
        if self.versionManager.publicParkingsUpdated {
            self.offlineManager?.getPublicParkings(onCompletion: completion)
        } else {
            self.onlineManager.getPublicParkings { (items, error) in
                guard error == nil, let parkings = items as? [MPPublicParkings] else {
                    self.offlineManager?.getPublicParkings(onCompletion: completion)
                    return
                }
                self.offlineManager?.savePublicParkings(parkings: parkings, onCompletion: { (items, error) in
                    self.versionManager.publicParkingsUpdated = (error == nil)
                    completion?(parkings, error)
                })
            }
        }
    }
    
    @objc public func getResidentParkings(onCompletion completion: MPMainInteractorResponse?) {
        
        if self.versionManager.residentParkingsUpdated {
            self.offlineManager?.getResidentParkings(onCompletion: completion)
        } else {
            self.onlineManager.getResidentParkings { (items, error) in
                guard error == nil, let parkings = items as? [MPResidentParkings] else {
                    self.offlineManager?.getResidentParkings(onCompletion: completion)
                    return
                }
                self.offlineManager?.saveResidentParkings(parkings: parkings, onCompletion: { (items, error) in
                    self.versionManager.residentParkingsUpdated = (error == nil)
                    completion?(parkings, error)
                })
            }
        }
    }
    
    @objc public func getVehicleDeposits(onCompletion completion: MPMainInteractorResponse?) {
        
        if self.versionManager.vehicleDepositsUpdated {
            self.offlineManager?.getVehicleDeposits(onCompletion: completion)
        } else {
            self.onlineManager.getVehicleDeposits { (items, error) in
                guard error == nil, let deposits = items as? [MPVehicleDeposits]  else {
                    self.offlineManager?.getVehicleDeposits(onCompletion: completion)
                    return
                }
                self.offlineManager?.saveVehicleDeposits(deposits: deposits, onCompletion: { (items, error) in
                    self.versionManager.vehicleDepositsUpdated = (error == nil)
                    completion?(deposits, error)
                })
            }
        }
    }
}
