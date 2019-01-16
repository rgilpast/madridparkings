//
//  MPWebServicesManager.swift
//  MadridParkings
//
//  Created by Rafael Gil Pastor on 26/12/2018.
//  Copyright © 2018 Rafael Gil. All rights reserved.
//

import Foundation
import SwiftyJSON

public typealias UserInfo = [String : Any]

public enum MPWebServicesErrorCode {
    
    case Success(JSON)
    case Undefined(UserInfo?)
    case NoData(UserInfo?)
    case MalformedData(UserInfo?)
    case UnexpectedData(UserInfo?)
    case Internal(UserInfo?)
    case NoHTTPResponse(UserInfo?)
    case InvalidRequest(UserInfo?)
    
    private func undefinedError(withUserInfo userInfo: UserInfo?) -> NSError {
        return NSError(domain: "com.rgp.MPWebServicesErrorCode", code: -1, userInfo: userInfo)
    }
    
    private func noDataError(withUserInfo userInfo: UserInfo?) -> NSError {
        return NSError(domain: "com.rgp.MPWebServicesErrorCode", code: -2, userInfo: userInfo)
    }
    
    private func malformedDataError(withUserInfo userInfo: UserInfo?) -> NSError {
        return NSError(domain: "com.rgp.MPWebServicesErrorCode", code: -3, userInfo: userInfo)
    }
    
    private func unexpectedDataError(withUserInfo userInfo: UserInfo?) -> NSError {
        return NSError(domain: "com.rgp.MPWebServicesErrorCode", code: -4, userInfo: userInfo)
    }
    
    private func internalError(withUserInfo userInfo: UserInfo?) -> NSError {
        return NSError(domain: "com.rgp.MPWebServicesErrorCode", code: -5, userInfo: userInfo)
    }
    
    private func noHTTPResponseError(withUserInfo userInfo: UserInfo?) -> NSError {
        return NSError(domain: "com.rgp.MPWebServicesErrorCode", code: -6, userInfo: userInfo)
    }
    
    private func invalidRequestError(withUserInfo userInfo: UserInfo?) -> NSError {
        return NSError(domain: "com.rgp.MPWebServicesErrorCode", code: -7, userInfo: nil)
    }

    public func toNSError() -> NSError? {
        switch self {
        case .Success(_): return nil
        case .Undefined(let userInfo): return self.undefinedError(withUserInfo: userInfo)
        case .NoData(let userInfo): return self.noDataError(withUserInfo: userInfo)
        case .MalformedData(let userInfo): return self.malformedDataError(withUserInfo: userInfo)
        case .UnexpectedData(let userInfo): return self.unexpectedDataError(withUserInfo: userInfo)
        case .Internal(let userInfo): return self.internalError(withUserInfo: userInfo)
        case .NoHTTPResponse(let userInfo): return self.noHTTPResponseError(withUserInfo: userInfo)
        case .InvalidRequest(let userInfo): return self.invalidRequestError(withUserInfo: userInfo)
        }
    }

    public static func toErrorCode(fromResponse response: URLResponse?, fromData data: Data? , fromError error: Error?) -> MPWebServicesErrorCode {
        
        if error != nil {
            if let nserror = error as NSError? {
                return .Undefined(nserror.userInfo)
                
            } else {
                return .Undefined(nil)
            }
        }
        guard let httpResponse = response as? HTTPURLResponse else {
            return .NoHTTPResponse(nil)
        }
        
        guard  httpResponse.statusCode == 200 else {
            return .InvalidRequest(nil)
        }
        
        guard let data = data else {
            return .NoData(nil)
        }

        return .Success(JSON(data))
    }
}

public enum MPWebServicesResourceType: String {

    case PublicParkings = "202625-0-aparcamientos-publicos.json"
    case ResidentParkins = "202584-0-aparcamientos-residentes.json"
    case VehicleDeposits = "300227-0-grua-depositos.json"
}

@objc public class MPWebServicesManager: NSObject, MPOnlineDataManagerProtocol {
    
    private lazy var nwManager: NetworkingManagerProtocol = {
        
        return AlamoFireManager.createManager(forBaseURL: URL(string: MPWebServicesManagerConstants.kBaseURL)!)
    }()
    
    private func getItems<T: MPEntityProtocol>(fromResource resource: String, ofType type: T.Type, onCompletion completion:MPDataManagerResponse?) {

        self.nwManager.getData(fromResource: resource,
                                           headers:[MPWebServicesManagerConstants.kServicesTokenHeader:MPWebServicesManagerConstants.kServicesTokenValue])
        { (data, response, error) in
            
            let result = MPWebServicesErrorCode.toErrorCode(fromResponse: response, fromData: data, fromError: error)
            switch result {
            case .Success( let jsonData ) :
                guard let graphData = jsonData[MPWebServicesManagerConstants.kGraphField].array else {
                    completion?( nil, MPWebServicesErrorCode.MalformedData(nil).toNSError())
                    return
                }
                completion?(graphData.compactMap({
                    T(fromJSON: $0.dictionaryObject ?? [:])
                }), nil)
                
            default:
                completion?( nil, result.toNSError())
            }
        }
    }
    
    public func getPublicParkings(onCompletion completion: MPDataManagerResponse?) {
        
        self.getItems(fromResource: MPWebServicesResourceType.PublicParkings.rawValue, ofType: MPPublicParkings.self, onCompletion: completion)
    }

    public func getResidentParkings(onCompletion completion: MPDataManagerResponse?) {
        
        self.getItems(fromResource: MPWebServicesResourceType.ResidentParkins.rawValue, ofType: MPResidentParkings.self, onCompletion: completion)
    }

    public func getVehicleDeposits(onCompletion completion: MPDataManagerResponse?) {
        
        self.getItems(fromResource: MPWebServicesResourceType.VehicleDeposits.rawValue, ofType: MPVehicleDeposits.self, onCompletion: completion)
    }
}

private struct MPWebServicesManagerConstants {
    
    public static let kBaseURL = "https://datos.madrid.es/egob/catalogo"
    public static let kServicesTokenHeader = "X-Auth-Token"
    public static let kServicesTokenValue = "c5d17a4f67ab4121bd85432d5b31de18"
    public static let kGraphField = "@graph"
}
