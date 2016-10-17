//
//  SelfmeListController.swift
//  Selfme
//
//  Created by Clayton Cohn on 10/1/16.
//  Copyright © 2016 Radhatter, LLC. All rights reserved.
//

import UIKit
import OpenGLES
import CoreData

let kButtonTitle = "Camera"

class SelfmeListController: UIViewController {
    lazy var cameraButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle(kButtonTitle, for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(red: 254/255.0, green: 123/255.0, blue: 135/255.0, alpha: 1.0)
        
        button.addTarget(self, action: #selector(SelfmeListController.presentImagePickerController), for: .touchUpInside)
        
        return button
    }()
    
    lazy var mediaPickerManager: MediaPickerManager = {
        let manager = MediaPickerManager(withPresentingViewController: self)
        manager.delegate = self
        return manager
    }()
    
    lazy var dataSource: PhotoDataSource = {
        return PhotoDataSource(fetchRequest: Photo.allPhotosRequest, collectionView:self.collectionView)
    }()
    
    lazy var collectionView: UICollectionView = {
      let layout = UICollectionViewFlowLayout()
        
        let screenWidth = UIScreen.main.bounds.size.width
        let itemSize = CGSize(width: screenWidth / 3 - 1, height: screenWidth / 3 - 1)
        
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = itemSize
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        
        let zero = CGRect(x: 0, y: 0, width: 0, height: 0)
        let collectionView = UICollectionView(frame: zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        
        return collectionView
    }()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        collectionView.dataSource = dataSource
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - UIImagePickerController
    
    override func viewWillLayoutSubviews() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cameraButton)
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.topAnchor.constraint(equalTo: self.navigationController?.navigationBar.bottomAnchor ?? view.topAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cameraButton.leftAnchor.constraint(equalTo: view.leftAnchor),
            cameraButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cameraButton.rightAnchor.constraint(equalTo: view.rightAnchor),
            cameraButton.heightAnchor.constraint(equalToConstant: 56.0)
            ])
        }
    
    //MARK: - Layout

    @objc func presentImagePickerController() {
        mediaPickerManager.presentImagePickerController(animated: true)
    }
}

//MARK: - MediaPickerManagerDelegate
extension SelfmeListController: MediaPickerManagerDelegate {
    func mediaPickerManager(manager: MediaPickerManager, didFinishPickingImage image: UIImage) {
        
        let eaglContext = EAGLContext(api: .openGLES2)
        let ciContext = CIContext(eaglContext: eaglContext!)
        
        let photoFilterController = PhotoFilterController(context: ciContext, eaglContext: eaglContext!, image: image)
        let navigationController = UINavigationController(rootViewController: photoFilterController)
        manager.dismissImagePickerController(animated: true) { 
            self.present(navigationController, animated: true, completion: nil)
        }
    }
}

//MARK: - Navigation
extension SelfmeListController {
    fileprivate func setupNavBar() {
        let sortTagsButton = UIBarButtonItem(
            title: "Tags",
            style: .plain,
            target: self,
            action: #selector(SelfmeListController.presentSortController))
        navigationItem.setRightBarButtonItems([sortTagsButton], animated: true)
    }
    
    @objc fileprivate func presentSortController() {
        let tagDataSource = SortableDataSource<Tag>(fetchRequest: Tag.allTagsRequest, managedObjectContext: CoreDataController.sharedInstance.managedObjectContext)
        
        let sortItemSelector = SortItemSelector(sortItems: tagDataSource.results)
        
        let sortController = PhotoSortListController(dataSource: tagDataSource, sortItemSelector: sortItemSelector)
        
        sortController.onSortSelection = { checkedItems in
            if !checkedItems.isEmpty {
                var predicates = [NSPredicate]()
                for tag in checkedItems {
                    let predicate = NSPredicate(format: "%K CONTAINS %@", "tags.title", tag.title)
                    predicates.append(predicate)
                }
                let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
                self.dataSource.performFetch(withPredicte: compoundPredicate)
            } else {
                self.dataSource.performFetch(withPredicte: nil)
            }
        }
        
        let navController = UINavigationController(rootViewController: sortController)
        
        present(navController, animated: true, completion: nil)
    }
}
