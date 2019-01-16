//
//  PersistenceManagerProtocol.swift
//  MadridParkings
//
//  Created by Rafael Gil Pastor on 13/01/2019.
//  Copyright © 2019 Rafael Gil. All rights reserved.
//

import Foundation

public protocol PersistenceManagerProtocol {

    associatedtype T
    
    //read and return the all items of type T from the specified resource
    func getItems(fromResource resource: String, completion: @escaping (_ items: [T]?, _ error: Error?) -> Void)
    //save all items of type T passed in the received array in the specified resource
    func saveItems(inResource resource: String, items: [T], completion: @escaping ( _ error: Error?) -> Void)
    //save all items of type T fromm the specified resource
    func eraseItems(fromResource resource: String, completion: @escaping ( _ error: Error?) -> Void)
    
    //NOTE: uriBase will be the model name for databases, or url base for files
    //NOTE: the resource will be the entity name for databases or the file name for files
}
