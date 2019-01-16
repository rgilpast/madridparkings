//
//  AlamoFireManager.swift
//
//  Created by Rafael Gil Pastor on 28/12/18.
//  Copyright © 2018 Rafael Gil. All rights reserved.
//

import Foundation
import Alamofire

@objc public class AlamoFireManager: SessionDelegate, NetworkingManagerProtocol {
    
    private var baseURL: URL
    private static var managers: [String : NetworkingManagerProtocol] = [ : ]
    
    private init(withBaseURL url: URL) {
        
        baseURL = url
    }

    private lazy var sessionManager: SessionManager = {
    
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            self.baseURL.host ?? self.baseURL.absoluteString: .disableEvaluation
        ]
    
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        
        return SessionManager(
            configuration: configuration,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
    }()
        
    public static func sharedInstance(forBaseURL url: URL) -> NetworkingManagerProtocol {
        
        let urlString = url.absoluteString
        guard let manager = managers[urlString] else {
            let newManager = createManager(forBaseURL: url)
            managers[urlString] = newManager
            return newManager
        }
        return manager
    }
    
    public static func createManager(forBaseURL url: URL) -> NetworkingManagerProtocol {
        
        let manager = AlamoFireManager(withBaseURL: url)
        return manager
    }
    
    public static func removeInstance(forBaseURL url: URL) {
        
        managers.removeValue(forKey: url.absoluteString)
    }
    
    public static func removeAllInstances() {
        
        managers.removeAll()
    }
    
    public func getData(fromResource resource: String, headers: [String:String]?, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        
        if let urlRequest: URL = URL(string: baseURL.absoluteString + "/\(resource)") {
            
            getData(fromURL: urlRequest, headers: headers, completion: completion)
        }
    }
    
    public func getData(fromURL url: URL, headers: [String:String]?, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        
        print("Get data from: \(url.absoluteString)")
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseData { (response) in
            
            completion(response.data, response.response, response.result.error)
        }
    }
}
