//
//  PhotoDataSource.swift
//  Selfme
//
//  Created by Clayton Cohn on 10/13/16.
//  Copyright © 2016 Radhatter, LLC. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class PhotoDataSource: NSObject {
    let collectionView: UICollectionView
    let managedObjectContext = CoreDataController.sharedInstance.managedObjectContext
    
    let fetchedResultsController: PhotoFetchedResultsController
    
    init(fetchRequest: NSFetchRequest<NSFetchRequestResult>, collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.fetchedResultsController = PhotoFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, collectionView: self.collectionView)
        
        super.init()
    }
    
    func performFetch(withPredicte predicate: NSPredicate?) {
        self.fetchedResultsController.performFetch(withPredicate: predicate)
        collectionView.reloadData()
    }
}

//MARK: - UICollectionViewDataSource
extension PhotoDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else { return 0 }
        return section.numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as! PhotoCell
        
        let photo = fetchedResultsController.object(at: indexPath) as! Photo
        
        cell.imageView.image = photo.photoImage
        
        return cell
    }
}
