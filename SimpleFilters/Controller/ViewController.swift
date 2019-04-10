//  ViewController.swift
//  SimpleFilters

//  Created by George Garcia on 4/10/19.
//  Copyright © 2019 George Garcia. All rights reserved.

import UIKit
import CoreImage

class ViewController: UIViewController {
    
    
    // MARK: IBOutlets
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var sepiaButtonView: UIView!
    @IBOutlet weak var blurButtonView: UIView!
    @IBOutlet weak var noirButtonView: UIView!
    @IBOutlet weak var processEffectView: UIView!
    @IBOutlet weak var resetButtonView: UIView!
    
    
    // MARK: Properties
    private var originalImage: UIImage?
    
    
    // MARK: IBActions
    @IBAction func applySepiaFilter(_ sender: Any) {
        
        guard let image = imageView?.image else {
            return
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.imageView?.image = self?.applyFilterTo(image: image, filterEffect: Filter(filterName: "CISepiaTone", filterEffectValue: 0.85, filterEffectValueName: kCIInputIntensityKey))
            }
       }
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
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.imageView?.image = self?.applyFilterTo(image: image, filterEffect: Filter(filterName: "CIPhotoEffectNoir", filterEffectValue: nil, filterEffectValueName: nil))
            }
        }
    }
    
    @IBAction func applyBlurEffect(_ sender: Any) {
        
        guard let image = imageView?.image else {
            return
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                   self?.imageView?.image = self?.applyFilterTo(image: image, filterEffect: Filter(filterName: "CIGaussianBlur", filterEffectValue: 8.0, filterEffectValueName: kCIInputRadiusKey))
            }
        }
    }
    
    @IBAction func clearFilters(_ sender: Any) {
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.imageView?.image = self?.originalImage
            }
        }
    }
    
    // MARK: View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalImage = imageView?.image
        setupButtonUI()
        
    }
    
    // MARK: Private Methods
    private func applyFilterTo(image: UIImage, filterEffect: Filter) -> UIImage? {
        
        // 1
        guard let cgImage = image.cgImage, let openGLContext = EAGLContext(api: .openGLES3) else { return nil }
        // 2
        let context = CIContext(eaglContext: openGLContext)
        
        let ciImage = CIImage(cgImage: cgImage)
        
        // 3
        let filter = CIFilter(name: filterEffect.filterName)
        
        // 4
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
       // 5
        if let filterEffectValue = filterEffect.filterEffectValue,
            let filterEffectValueName = filterEffect.filterEffectValueName {
            
            filter?.setValue(filterEffectValue, forKey: filterEffectValueName)
        }
        
        // 6
        var filteredImage: UIImage?
        
        // 7
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage,
            let cgiImageResult = context.createCGImage(output, from: output.extent) {
            filteredImage = UIImage(cgImage: cgiImageResult)
        }
        return filteredImage
    }
    
    private func setupButtonUI() {
        
        sepiaButtonView.layer.cornerRadius = 10
        sepiaButtonView.clipsToBounds = true
        
        noirButtonView.layer.cornerRadius = 10
        noirButtonView.clipsToBounds = true
        
        blurButtonView.layer.cornerRadius = 10
        blurButtonView.clipsToBounds = true
        
        processEffectView.layer.cornerRadius = 10
        processEffectView.clipsToBounds = true
        
        resetButtonView.layer.cornerRadius = 10
        resetButtonView.clipsToBounds = true
    }
    
}


// MARK: NOTES


/* | applyFilter Method | (Lines: 114-146)
 
 1) Got a CGImage from our UIImage, contains an optional CGImage
    We try to get the graphics context, an openGLContext,
    by creating one and making sure we can create one
 
 2) Creating a Core Image Context, feeding the graphics context here
 
 3) Created a filter variable for the given filter name

 4) Pretty much saying: "hey filter, this the image
    you are going to use to apply filters on"
 
 5) Check to see if we have an values
     example:  input intensity, Gaussian Blur(radius effect)
 
 6) Finally we render the output image

 7) Saying: "Hey filter! Give me the value for the output image key
    as a CIImage, then create a CGImage from the output and
    then finally render it into a UIImage
*/
