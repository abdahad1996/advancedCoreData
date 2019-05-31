//
//  CoreDataManager.swift
//  AdvancedCoreData
//
//  Created by prog on 5/31/19.
//  Copyright © 2019 prog. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    // initialize coredata stack
    
    
    //setup our coredatamodel and load it into persistent store
    let container:NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { (NSPersistentStoreDescription, Error) in
            if let err = Error {
                fatalError("loading of store failed :\(err)")
            }
        })
        return container

    }()

}
