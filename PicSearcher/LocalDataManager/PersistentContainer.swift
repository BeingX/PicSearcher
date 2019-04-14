//
//  PersistentContainer.swift
//  PicSearcher
//
//  Created by 尹啟星 on 2019/4/12.
//  Copyright © 2019 xingxing. All rights reserved.
//

import CoreData

class PersistentContainer: NSPersistentContainer {
    
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
}
