//
//  MPMainInteractorProtocol.swift
//  MadridParkings
//
//  Created by Rafael Gil Pastor on 16/01/2019.
//  Copyright © 2019 Rafael Gil. All rights reserved.
//

import Foundation

public typealias MPMainInteractorResponse =  @convention(block) ([MPEntityBaseProtocol]?, NSError?) -> Void

@objc public protocol MPMainInteractorProtocol: class {
    
    init(withOnlineManager onlineManager: MPOnlineDataManagerProtocol, withOfflineManager offlineManager: MPOfflineDataManagerProtocol?)
    
    func getPublicParkings(onCompletion completion: MPMainInteractorResponse?)
    func getResidentParkings(onCompletion completion: MPMainInteractorResponse?)
    func getVehicleDeposits(onCompletion completion: MPMainInteractorResponse?)
}
