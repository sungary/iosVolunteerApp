//
//  DataController.swift
//  CollectorApp
//
//  Created by Gary Sun on 1/16/23.
//

import Foundation
import CoreData

class DataConteroller: ObservableObject {
    let container = NSPersistentContainer(name: "Listing")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
