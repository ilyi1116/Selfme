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
    class func tag(withTitle title: String) -> Tag {
        let tag = NSEntityDescription.insertNewObject(forEntityName: Tag.entityName, into: CoreDataController.sharedInstance.managedObjectContext) as! Tag
        tag.title = title
        return tag
    }
}

extension Tag {
    @NSManaged var title: String
}
