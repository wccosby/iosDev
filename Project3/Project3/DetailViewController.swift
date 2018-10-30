//
//  DetailViewController.swift
//  HackingWithSwiftProject1
//
//  Created by William Cosby on 10/27/18.
//  Copyright © 2018 William Cosby. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var selectedImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedImage
        
        // enable sharing button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        // these if let statements help us by ensure that if for some reason selectedImage doesn't have a value
        // the whole app doesn't crash because the code in the brackets does not get executed
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareTapped() {
        // UIActivityViewControllor is the iOS method of sharing content with other apps/devices
        let vc = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: [])
        // this will tell iOS where the activity view controller should be anchored (where it appears from)
        // only has an effect on ipad...iphones ignore this and show the content full screen
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
