//
//  PhotoFilterController.swift
//  Selfme
//
//  Created by Clayton Cohn on 10/8/16.
//  Copyright © 2016 Radhatter, LLC. All rights reserved.
//

import UIKit

class PhotoFilterController: UIViewController {
    
    private var mainImage: UIImage
    
    init(image: UIImage) {
        self.mainImage = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        let alertController = UIAlertController(
            title: "Strange Things are Afoot",
            message: "This should not show up under any circumstance.\nThe app is looking for a storyboard, and it shouldn't be.",
            preferredStyle: .alert)
        let cancelAction = UIAlertAction(
            title: "Ok",
            style: .cancel,
            handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
