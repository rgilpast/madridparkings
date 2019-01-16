//
//  MPVersionManagerProtocol.swift
//  MadridParkings
//
//  Created by Rafael Gil Pastor on 16/01/2019.
//  Copyright © 2019 Rafael Gil. All rights reserved.
//

import Foundation

public protocol MPVersionManagerProtocol {
    
    var publicParkingsUpdated: Bool { get set }
    var residentParkingsUpdated: Bool { get set }
    var vehicleDepositsUpdated: Bool { get set }
}

