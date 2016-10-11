//
//  FilteredImageBuilder.swift
//  Selfme
//
//  Created by Clayton Cohn on 10/9/16.
//  Copyright © 2016 Radhatter, LLC. All rights reserved.
//

import Foundation
import CoreImage
import UIKit

final class FilteredImageBuilder {
    
    private struct PhotoFilter {
        
        static let kColorClamp = "CIColorClamp"
        static let kColorControls = "CIColorControls"
        
        static let kInputMinComponents = "inputMinComponents"
        static let kInputMaxComponents = "inputMaxComponents"
        
        static let kPhotoEffectInstant = "CIPhotoEffectInstant"
        static let kPhotoEffectProcess = "CIPhotoEffectProcess"
        static let kPhotoEffectNoir = "CIPhotoEffectNoir"
        static let kSepiaTone = "CISepiaTone"
        
        static func defaultFilters() -> [CIFilter] {
            
            //MARK: - CIColorClamp
            let colorClamp = CIFilter(name: PhotoFilter.kColorClamp)
            colorClamp?.setValue(CIVector(x: 0.2, y: 0.2, z: 0.2, w: 0.2), forKey: PhotoFilter.kInputMinComponents)
            colorClamp?.setValue(CIVector(x: 0.9, y: 0.9, z: 0.9, w: 0.9), forKey: PhotoFilter.kInputMaxComponents)
            
            //MARK: - CIColorClamp
            let colorControls = CIFilter(name: PhotoFilter.kColorControls)
            colorControls?.setValue(0.1, forKey: kCIInputSaturationKey)
            
            //MARK: - CIPhotoEffects
            let photoEffectInstant = CIFilter(name: PhotoFilter.kPhotoEffectInstant)
            let photoEffectProcess = CIFilter(name: PhotoFilter.kPhotoEffectProcess)
            let photoEffectNoir = CIFilter(name: PhotoFilter.kPhotoEffectNoir)
            let sepiaFilter = CIFilter(name: PhotoFilter.kSepiaTone)
            sepiaFilter?.setValue(0.7, forKey: kCIInputIntensityKey)
            
            return [colorClamp!, colorControls!, photoEffectInstant!, photoEffectProcess!, photoEffectNoir!, sepiaFilter!]
        }
    }
    
    private let image: UIImage
    
    private let context: CIContext
    
    init(context: CIContext, image: UIImage) {
        self.context = context
        self.image = image
    }
    
    func imageWithDefaultFilters() -> [CIImage] {
        return image(withFilters: PhotoFilter.defaultFilters())
    }
    
    func image(withFilters filters: [CIFilter]) -> [CIImage] {
        return filters.map {
            image(image: self.image, withFilter: $0)
        }
    }
    
    func image(image: UIImage, withFilter filter: CIFilter) -> CIImage {
        let inputImage = image.ciImage ?? CIImage(image: image)
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        let outputImage = filter.outputImage!
        return outputImage.cropping(to: (inputImage?.extent)!)
    }
    
}

extension UIApplication {
    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {     //This always returns the topmost view controller
        if let nav = base as? UINavigationController { return topViewController(nav.visibleViewController) }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController { return topViewController(selected) }
        }
        if let presented = base?.presentedViewController { return topViewController(presented) }
        return base
    }
}
