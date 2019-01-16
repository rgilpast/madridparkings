//
//  MPEntity.swift
//  MadridParkings
//
//  Created by Rafael Gil Pastor on 03/01/2019.
//  Copyright © 2019 Rafael Gil. All rights reserved.
//

import Foundation

import UIKit
import CoreData
import Foundation
import SwiftyJSON

public protocol MPEntityProtocolMO:  MPEntityBaseProtocol {
    
    func setValues(fromItem item: MPEntityBaseProtocol)
}

public class MPEntityMO: NSManagedObject, MPEntityProtocolMO {
    
    @NSManaged public var id: String
    @NSManaged public var title: String?
    @NSManaged public var streetAddress: String?
    @NSManaged public var postalCode: String?
    @NSManaged public var orgDescription: String?
    @NSManaged public var locality: String?
    
    public func setValues(fromItem item: MPEntityBaseProtocol) {
        
        self.setValue(item.id, forKey: MPEntityMOConstants.kIdField)
        self.setValue(item.title, forKey: MPEntityMOConstants.kTitleField)
        self.setValue(item.streetAddress, forKey: MPEntityMOConstants.kStreetAddressField)
        self.setValue(item.postalCode, forKey: MPEntityMOConstants.kPostalCodeField)
        self.setValue(item.orgDescription, forKey: MPEntityMOConstants.kOrgDescriptionField)
        self.setValue(item.locality, forKey: MPEntityMOConstants.kLocalityField)
    }
}

private struct MPEntityMOConstants {
    
    static let kIdField: String = "id"
    static let kTitleField: String = "title"
    static let kStreetAddressField: String = "streetAddress"
    static let kPostalCodeField: String = "postalCode"
    static let kOrgDescriptionField: String = "orgDescription"
    static let kLocalityField: String = "locality"
}
