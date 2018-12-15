//
//  ViewController.swift
//  Project13
//
//  Created by William Cosby on 12/12/18.
//  Copyright © 2018 William Cosby. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var intensity: UISlider!
    var currentImage: UIImage!
    
    var context: CIContext!
    var currentFilter: CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // getting ready to let the user add an image:
        title = "InstaFilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
    }
    
    ///////////////
    // code to launch the image selector
    ///////////////
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    @IBAction func changeFilter(_ sender: Any) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion",style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur",style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate",style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone",style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion",style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask",style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette",style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func setFilter(action: UIAlertAction) {
        // make sure we have a valid image before continuing!
        guard currentImage != nil else { return }
        currentFilter = CIFilter(name: action.title!)
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    @IBAction func save(_ sender: Any) {
        
    }
    
    ///////////////
    // triggered when the user moves the slider
    ///////////////
    @IBAction func intensityChanged(_ sender: Any) {
        applyProcessing()
    }
    
    ///////////////
    // set the current image to the image selected by the image picker
    ///////////////
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        dismiss(animated: true)
        currentImage = image
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    ///////////////
    // controls the level of the filter
    ///////////////
    func applyProcessing() {
        currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
        
        if let cgimg = context.createCGImage(currentFilter.outputImage!, from: currentFilter.outputImage!.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            imageView.image = processedImage
        }
    }
    
}

