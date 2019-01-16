//
//  MPEntity.swift
//  MadridParkings
//
//  Created by Rafael Gil Pastor on 30/12/2018.
//  Copyright © 2018 Rafael Gil. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

@objc public protocol MPEntityBaseProtocol {
    
    var id: String { get set }
    var title: String? { get set}
    var streetAddress: String? { get set }
    var postalCode: String? { get set }
    var orgDescription: String? { get set }
    var locality: String? { get set }
}

@objc public protocol MPEntityProtocol: class, MPEntityBaseProtocol {
    
    init(fromJSON jsonDict: [String : Any])
    init(fromItem item: MPEntityBaseProtocol)
}
