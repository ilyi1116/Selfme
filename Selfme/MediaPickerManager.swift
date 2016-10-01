//
//  MediaPickerManager.swift
//  Selfme
//
//  Created by Clayton Cohn on 10/1/16.
//  Copyright © 2016 Radhatter, LLC. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol MediaPickerManagerDelegate: class {
    func mediaPickerManager(manager: MediaPickerManager, didFinishPickingImage image: UIImage)
}

class MediaPickerManager: NSObject {
    
    private let imagePicker = UIImagePickerController()
    private let presentingViewController: UIViewController
    
    weak var delegate: MediaPickerManagerDelegate?
    
    init(withPresentingViewController presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
        super.init()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.cameraDevice = .front
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        imagePicker.mediaTypes = [kUTTypeImage as String]
    }
    
    func presentImagePickerController(animated: Bool) {
        presentingViewController.present(imagePicker, animated: animated, completion: nil)
    }
    
    func dismissImagePickerController(animated: Bool, completion: @escaping (() -> Void)) {
        imagePicker.dismiss(animated: animated, completion: completion)
    }
}

extension MediaPickerManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        delegate?.mediaPickerManager(manager: self, didFinishPickingImage: image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
}
