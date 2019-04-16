//
//  SearchRecordManager.swift
//  PicSearcher
//
//  Created by 尹啟星 on 2019/4/12.
//  Copyright © 2019 xingxing. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SearchRecordManager: NSObject, NSFetchedResultsControllerDelegate {
    static let shared = SearchRecordManager()
    let appDelegate = AppDelegate.applicationDelegate
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<SearchRecord> = {
        let fetchRequest: NSFetchRequest<SearchRecord> = SearchRecord.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    weak var delegate: SearchRecordManagerDelegate?
    override init() {
        super.init()
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
    }
    func object(at indexPath: IndexPath) -> SearchRecord {
        return fetchedResultsController.object(at: indexPath)
    }
    func allRecords() -> [SearchRecord] {
        var records = [SearchRecord]()
        if let fetchedObjects = fetchedResultsController.fetchedObjects {
            records = fetchedObjects
        }
        return records
    }
    func saveRecord(searchKeyWord: String, firstPage: FlickrSearchApiResponseModel.Photos) {
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(firstPage) else {
            return
        }
        let record = SearchRecord(context: appDelegate.persistentContainer.viewContext)
        record.searchkeyWord = searchKeyWord
        record.date = Date()
        record.firstPageJson = jsonData
        appDelegate.persistentContainer.saveContext()
    }
    func removeObject(at indexPath: IndexPath) {
        let record = fetchedResultsController.object(at: indexPath)
        appDelegate.persistentContainer.viewContext.delete(record)
        appDelegate.persistentContainer.saveContext()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.delegate?.recordListDidChange(dataManager: self)
    }
}

protocol SearchRecordManagerDelegate: NSObjectProtocol {
    func recordListDidChange(dataManager: SearchRecordManager)
}
