//
//  FilteredImageCell.swift
//  Selfme
//
//  Created by Clayton Cohn on 10/10/16.
//  Copyright © 2016 Radhatter, LLC. All rights reserved.
//

import UIKit
import GLKit

class FilteredImageCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: FilteredImageCell.self)
    
    var eaglcontext: EAGLContext!
    var ciContext: CIContext!
    
    lazy var glkView: GLKView = {
       let view = GLKView(frame: self.contentView.frame, context: self.eaglcontext)
        view.delegate = self
        return view
    }()
    
    var image: CIImage!
    
    override func layoutSubviews() {
        contentView.addSubview(glkView)
        glkView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            glkView.topAnchor.constraint(equalTo: contentView.topAnchor),
            glkView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            glkView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            glkView.leftAnchor.constraint(equalTo: contentView.leftAnchor)
        ])
    }
}

extension FilteredImageCell: GLKViewDelegate {
    func glkView(_ view: GLKView, drawIn rect: CGRect) {
        
        let drawableRectSize = CGSize(width: glkView.drawableWidth, height: glkView.drawableHeight)
        let drawableRect = CGRect(origin: CGPoint(x: 0, y: 0), size: drawableRectSize)
        
        ciContext.draw(image, in: drawableRect, from: image.extent)
    }
}
