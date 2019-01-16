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

@objc public class MPEntity: NSObject, MPEntityProtocol {
    
    public var id: String = ""
    public var title: String?
    public var streetAddress: String?
    public var postalCode: String?
    public var locality: String?
    public var orgDescription: String?
    
    @objc required public init(fromJSON jsonDict: [String : Any]) {
        
        //convert json dictionary param to Swifty JSON
        let json = JSON(jsonDict)
        
        //required properties
        guard let id = json[MPEntityConstants.kIdFieldKey].string else {
            return
        }
        self.id = id
        
        //optional properties
        self.title = json[MPEntityConstants.kTitleFieldKey].string
        self.streetAddress = json[MPEntityConstants.kAddressFieldKey][MPEntityConstants.kStreetAddressFieldKey].string
        self.postalCode = json[MPEntityConstants.kAddressFieldKey][MPEntityConstants.kPostalCodeFieldKey].string
        self.locality = json[MPEntityConstants.kAddressFieldKey][MPEntityConstants.kLocalityFieldKey].string
        self.orgDescription = json[MPEntityConstants.kOrganizationFieldKey][MPEntityConstants.kOrgDescriptionFieldKey].string
    }

    public required init(fromItem item: MPEntityBaseProtocol) {
        
        self.id = item.id
        self.title = item.title
        self.streetAddress = item.streetAddress
        self.locality = item.locality
        self.postalCode = item.postalCode
        self.orgDescription = item.orgDescription
    }
}

private struct MPEntityConstants {
    
    public static let kIdFieldKey = "id"
    public static let kTitleFieldKey = "title"
    public static let kAddressFieldKey = "address"
    public static let kStreetAddressFieldKey = "street-address"
    public static let kPostalCodeFieldKey = "postal-code"
    public static let kLocalityFieldKey = "locality"
    public static let kOrganizationFieldKey = "organization"
    public static let kOrgDescriptionFieldKey = "organization-desc"
}
