//  ViewController.swift
//  SimpleFilters

//  Created by George Garcia on 4/10/19.
//  Copyright © 2019 George Garcia. All rights reserved.

import UIKit
import CoreImage

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView?
    private var originalImage: UIImage?
    
    @IBAction func applySepiaFilter(_ sender: Any) {
        
        guard let image = imageView?.image else {
            return
        }
        
        imageView?.image = applyFilterTo(image: image, filterEffect: Filter(filterName: "CISepiaTone", filterEffectValue: 0.85, filterEffectValueName: kCIInputIntensityKey))
    }
    
    @IBAction func applyPhotoTransferEffect(_ sender: Any) {
        
        guard let image = imageView?.image else {
            return
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.imageView?.image = self?.applyFilterTo(image: image, filterEffect: Filter(filterName: "CIPhotoEffectProcess", filterEffectValue: nil, filterEffectValueName: kCIInputIntensityKey))
            }
        }
    }
    
    @IBAction func applyNoirEffect(_ sender: Any) {
        
        guard let image = imageView?.image else {
            return
        }
        imageView?.image = applyFilterTo(image: image, filterEffect: Filter(filterName: "CIPhotoEffectNoir", filterEffectValue: nil, filterEffectValueName: nil))
    }
    
    @IBAction func applyBlurEffect(_ sender: Any) {
        
        guard let image = imageView?.image else {
            return
        }
        
        imageView?.image = applyFilterTo(image: image, filterEffect: Filter(filterName: "CIGaussianBlur", filterEffectValue: 8.0, filterEffectValueName: kCIInputRadiusKey))
    }
    
    @IBAction func clearFilters(_ sender: Any) {
        imageView?.image = originalImage
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func applyFilterTo(image: UIImage, filterEffect: Filter) -> UIImage? {
        
        // Got a CGImage from our UIImage, contains an optional CGImage
        // We try to get the graphics context, an openGLContext, by creating one and making sure we can create one
        guard let cgImage = image.cgImage, let openGLContext = EAGLContext(api: .openGLES3) else { return nil }
        
        // creating a Core Image Context, feeding the graphics context here
        let context = CIContext(eaglContext: openGLContext)
        
        let ciImage = CIImage(cgImage: cgImage)
        
        // Created a filter var for the given filter name
        let filter = CIFilter(name: filterEffect.filterName)
        
        // "hey filter, this the image you are going to use to apply filters on
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        // did a check to see if we have an values i.e.  input intensity, Gaussian Blur(radius effect)
        if let filterEffectValue = filterEffect.filterEffectValue,
            let filterEffectValueName = filterEffect.filterEffectValueName {
            
            filter?.setValue(filterEffectValue, forKey: filterEffectValueName)
            
        }
        
        // finally we render the output image
        var filteredImage: UIImage?
        
        // hey filter give me the value for the output image key as a CIImage, then create a CGImage from the output and then finally render it into a UIImage
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage,
            let cgiImageResult = context.createCGImage(output, from: output.extent) {
            filteredImage = UIImage(cgImage: cgiImageResult)
        }
        
        return filteredImage
    }
    
}

