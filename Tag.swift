//
//  Tag.swift
//  Selfme
//
//  Created by Clayton Cohn on 10/13/16.
//  Copyright © 2016 Radhatter, LLC. All rights reserved.
//

import Foundation
import CoreData

class Tag: NSManagedObject {
    static let entityName = "\(Tag.self)"
    
    static var allTagsRequest: NSFetchRequest<NSFetchRequestResult> = {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Tag.entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        return request
    }()
    
    static var uniqueTagsRequest: NSFetchRequest<NSFetchRequestResult> = {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Tag.entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        request.resultType = .dictionaryResultType
        request.returnsDistinctResults = true
        return request
    }()
    
    class func tag(withTitle title: String) -> Tag {
        let tag = NSEntityDescription.insertNewObject(forEntityName: Tag.entityName, into: CoreDataController.sharedInstance.managedObjectContext) as! Tag
        tag.title = title
        return tag
    }
}

extension Tag {
    @NSManaged var title: String
}
