//
//  MPVersionManager.swift
//  MadridParkings
//
//  Created by Rafael Gil Pastor on 16/01/2019.
//  Copyright © 2019 Rafael Gil. All rights reserved.
//

import Foundation

public struct MPVersionManager: MPVersionManagerProtocol {
    
    public var publicParkingsUpdated: Bool {
        get {
            return checkVersionState(of: MPVersionManagerConstants.kPublicParkingsDate)
        }
        set {
            setVersionState(of: MPVersionManagerConstants.kPublicParkingsDate, with: newValue)
        }
    }
    
    public var residentParkingsUpdated: Bool {
        get {
            return checkVersionState(of: MPVersionManagerConstants.kResidentParkingsDate)
        }
        set {
            setVersionState(of: MPVersionManagerConstants.kResidentParkingsDate, with: newValue)
        }
    }
    
    public var vehicleDepositsUpdated: Bool {
        get {
            return checkVersionState(of: MPVersionManagerConstants.kVehicleDepositsDate)
        }
        set {
            setVersionState(of: MPVersionManagerConstants.kVehicleDepositsDate, with: newValue)
        }
    }
    
    private func checkVersionState(of resource: String) -> Bool {
        
        let versionPrefs = UserDefaults.standard
        let timestampVersion = versionPrefs.double(forKey: resource)
        let now = Date().timeIntervalSinceReferenceDate
        let diffSeconds = now - timestampVersion
        return diffSeconds/60/60/24 < MPVersionManagerConstants.kMaxDaysVersionLife
    }

    private func setVersionState(of resource: String, with newValue: Bool) {
        
        let versionPrefs = UserDefaults.standard
        if newValue {
            versionPrefs.set(Date().timeIntervalSinceReferenceDate, forKey: resource)
        } else {
            versionPrefs.removeObject(forKey: resource)
        }
        versionPrefs.synchronize()
    }
}

private struct MPVersionManagerConstants {
    
    public static let kPublicParkingsDate: String = "PublicParkingsDate"
    public static let kResidentParkingsDate: String = "ResidentParkingsDate"
    public static let kVehicleDepositsDate: String = "VehicleDepositsDate"
    public static let kMaxDaysVersionLife: Double = 1
}
