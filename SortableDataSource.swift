//
//  SortableDataSource.swift
//  Selfme
//
//  Created by Clayton Cohn on 10/15/16.
//  Copyright © 2016 Radhatter, LLC. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol CustomTitleConvertible {
    var title: String { get }
}

extension Tag: CustomTitleConvertible {  }

class SortableDataSource<SortType: CustomTitleConvertible>: NSObject, UITableViewDataSource where SortType: NSManagedObject {
    
    let kReuseIdentifier = "sortableItemCell"
    
    fileprivate let fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>
    fileprivate var allTags: NSMutableArray = []

    var results: [SortType] {
        return fetchedResultsController.fetchedObjects as! [SortType]
    }
    
    init(fetchRequest: NSFetchRequest<NSFetchRequestResult>, managedObjectContext moc: NSManagedObjectContext) {
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        executeFetch()
    }
    
    func executeFetch() {
        do {
            try fetchedResultsController.performFetch()
            setAllTags()
        } catch let error as NSError {
            let alertController = UIAlertController(
                title: "Error",
                message: "\(error.debugDescription)",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "Ok",
                style: .cancel,
                handler: nil)
            alertController.addAction(okAction)
            UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func setAllTags() {
        for (i, _) in fetchedResultsController.fetchedObjects!.enumerated() {
            guard let sortItem = fetchedResultsController.fetchedObjects?[i] as? SortType else { break}
            if !allTags.contains(sortItem.title) {
                allTags.add(sortItem.title)
            }
        }
        print(allTags)
    }
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int { return 2 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return allTags.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: kReuseIdentifier)
        cell.selectionStyle = .none
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            cell.textLabel?.text = "All \(SortType.self)s"
            cell.accessoryType = .checkmark
        case (1, _):
            cell.textLabel?.text = allTags[indexPath.row] as? String
            
        default: break
        }
        return cell
    }
}
