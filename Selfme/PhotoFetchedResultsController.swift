//
//  PhotoFetchedResultsController.swift
//  Selfme
//
//  Created by Clayton Cohn on 10/13/16.
//  Copyright © 2016 Radhatter, LLC. All rights reserved.
//

import UIKit
import CoreData

class PhotoFetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>, NSFetchedResultsControllerDelegate {
    
    let collectionView: UICollectionView
    
    init(fetchRequest: NSFetchRequest<NSFetchRequestResult>, managedObjectContext: NSManagedObjectContext, collectionView: UICollectionView) {
        
        self.collectionView = collectionView
        
        super.init(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        self.delegate = self
        executeFetch()
    }
    
    func executeFetch() {
        do {
            try performFetch()
        } catch let error as NSError {
            let alertController = UIAlertController(
                title: "Error",
                message: "\(error.debugDescription)",
                preferredStyle: .alert)
            let cancelAction = UIAlertAction(
                title: "Ok",
                style: .cancel,
                handler: nil)
            alertController.addAction(cancelAction)
            UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func performFetch(withPredicate predicate: NSPredicate?) {
        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: nil)
        fetchRequest.predicate = predicate
        executeFetch()
    }
    
    //MARK: - NSFetchedResultsControllerDelegate
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.reloadData()
    }
}
