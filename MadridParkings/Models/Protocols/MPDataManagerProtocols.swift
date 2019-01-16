//
//  MPOnlineDataManagerProtocol.swift
//  MadridParkings
//
//  Created by Rafael Gil Pastor on 03/01/2019.
//  Copyright © 2019 Rafael Gil. All rights reserved.
//

import Foundation

public typealias MPDataManagerResponse =  @convention(block) ([MPEntityBaseProtocol]?, NSError?) -> Void

@objc public protocol MPOnlineDataManagerProtocol {
    
    func getPublicParkings(onCompletion completion: MPDataManagerResponse?)
    func getResidentParkings(onCompletion completion: MPDataManagerResponse?)
    func getVehicleDeposits(onCompletion completion: MPDataManagerResponse?)
}

@objc public protocol MPOfflineDataManagerProtocol {
    
    func getPublicParkings(onCompletion completion: MPDataManagerResponse?)
    func getResidentParkings(onCompletion completion: MPDataManagerResponse?)
    func getVehicleDeposits(onCompletion completion: MPDataManagerResponse?)
    func savePublicParkings(parkings: [MPPublicParkings]?, onCompletion completion: MPDataManagerResponse?)
    func saveResidentParkings(parkings: [MPResidentParkings]?, onCompletion completion: MPDataManagerResponse?)
    func saveVehicleDeposits(deposits: [MPVehicleDeposits]?, onCompletion completion: MPDataManagerResponse?)
    func erasePublicParkings(onCompletion completion: MPDataManagerResponse?)
    func eraseResidentParkings(onCompletion completion: MPDataManagerResponse?)
    func eraseVehicleDeposits(onCompletion completion: MPDataManagerResponse?)
}
