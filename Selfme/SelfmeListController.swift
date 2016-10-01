//
//  SelfmeListController.swift
//  Selfme
//
//  Created by Clayton Cohn on 10/1/16.
//  Copyright © 2016 Radhatter, LLC. All rights reserved.
//

import UIKit

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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: - UIImagePickerController
    
    override func viewWillLayoutSubviews() {
        view.addSubview(cameraButton)
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cameraButton.leftAnchor.constraint(equalTo: view.leftAnchor),
            cameraButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cameraButton.rightAnchor.constraint(equalTo: view.rightAnchor),
            cameraButton.heightAnchor.constraint(equalToConstant: 56.0)
            ])
    }
    
    //MARK: - Layout

    @objc private func presentImagePickerController() {
        
    }


}

