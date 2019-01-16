//
//  URLSessionManager.swift
//
//  Created by Rafael Gil Pastor on 22/8/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation

@objc public class URLSessionManager: NSObject, NetworkingManagerProtocol {
    
    private var baseURL: URL
    private static var managers: [String : NetworkingManagerProtocol] = [ : ]
    
    private init(withBaseURL url: URL) {
        baseURL = url
    }

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
        
        let manager = URLSessionManager(withBaseURL: url)
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
        
        //build request
        var request = URLRequest(url: url)
        
        //set http headers for request (if any)
        if let headers = headers {
            for header in headers {
                request.setValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        
        //do request
        URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
}
