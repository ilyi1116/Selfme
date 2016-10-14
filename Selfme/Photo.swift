//
//  Photo.swift
//  Selfme
//
//  Created by Clayton Cohn on 10/13/16.
//  Copyright © 2016 Radhatter, LLC. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import CoreLocation

class Photo: NSManagedObject {
    static let entityName = "\(Photo.self)"
    
    class func photo(withImage image: UIImage) -> Photo{
        let photo = NSEntityDescription.insertNewObject(forEntityName: Photo.entityName, into: CoreDataController.sharedInstance.managedObjectContext) as! Photo
        photo.date = NSDate().timeIntervalSince1970
        photo.image = UIImageJPEGRepresentation(image, 1.0)! as NSData
        return photo
    }
    
    class func photo(withImage image: UIImage, tags: [String], location: CLLocation?) {
        let photo = Photo.photo(withImage: image)
        photo.addTags(tags: tags)
        photo.addLocation(location: location)
    }
    
    func addTag(withTitle title: String) {
        let tag = Tag.tag(withTitle: title)
        tags.insert(tag)
    }
    
    func addTags(tags: [String]) {
        for tag in tags {
            addTag(withTitle: tag)
        }
    }
    
    func addLocation(location: CLLocation?) {
        if let location = location {
            let photoLocation = Location.location(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.location = photoLocation
        }
    }
    
}

extension Photo {
    @NSManaged var date: TimeInterval
    @NSManaged var image: NSData
    @NSManaged var tags: Set<Tag>
    @NSManaged var location: Location?
}
