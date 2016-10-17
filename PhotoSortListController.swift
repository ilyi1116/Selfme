//
//  PhotoSortListController.swift
//  Selfme
//
//  Created by Clayton Cohn on 10/15/16.
//  Copyright © 2016 Radhatter, LLC. All rights reserved.
//

import UIKit
import CoreData

class PhotoSortListController<SortType: CustomTitleConverter>: UITableViewController where SortType: NSManagedObject {
    
    let dataSource: SortableDataSource<SortType>
    let sortItemSelector: SortItemSelector<SortType>
    
    init(dataSource: SortableDataSource<SortType>, sortItemSelector: SortItemSelector<SortType>) {
        self.dataSource = dataSource
        self.sortItemSelector = sortItemSelector
        super.init(style: .grouped)
        
        tableView.dataSource = dataSource
        tableView.delegate = sortItemSelector
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setupNavigation() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(PhotoSortListController.dismissPhotoSortListController))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc fileprivate func dismissPhotoSortListController() {
        dismiss(animated: true, completion: nil)
    }
}

extension PhotoSortListController {
    
}
     
