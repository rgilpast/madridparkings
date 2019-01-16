//
//  NetworkingManager.swift
//
//  Created by Rafael Gil Pastor on 22/8/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//


import Foundation

public protocol NetworkingManagerProtocol {

    static func createManager(forBaseURL url: URL) -> NetworkingManagerProtocol
    static func sharedInstance(forBaseURL url: URL) -> NetworkingManagerProtocol
    static func removeInstance(forBaseURL url: URL)
    static func removeAllInstances()

    func getData(fromResource resource: String, headers: [String:String]?, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void)
    func getData(fromURL url: URL, headers: [String:String]?, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void)
}
