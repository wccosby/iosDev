//
//  ViewController.swift
//  Project6b
//
//  Created by William Cosby on 11/24/18.
//  Copyright © 2018 William Cosby. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // these declartions won't do anything yet
        let label1 = UILabel()
        label1.translatesAutoresizingMaskIntoConstraints = false // setting this to false because we will be doing this manually
        label1.backgroundColor = UIColor.red
        label1.text = "THESE"
        label1.sizeToFit()
        
        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.backgroundColor = UIColor.cyan
        label2.text = "ARE"
        label2.sizeToFit()
        
        let label3 = UILabel()
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.backgroundColor = UIColor.yellow
        label3.text = "SOME"
        label3.sizeToFit()
        
        let label4 = UILabel()
        label4.translatesAutoresizingMaskIntoConstraints = false
        label4.backgroundColor = UIColor.green
        label4.text = "AWESOME"
        label4.sizeToFit()
        
        let label5 = UILabel()
        label5.translatesAutoresizingMaskIntoConstraints = false
        label5.backgroundColor = UIColor.orange
        label5.text = "LABELS"
        label5.sizeToFit()
        
        // these add in the views
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(label5)
        
        // dictionary of the labels/subviews
        let viewsDictionary = ["label1": label1, "label2": label2, "label3": label3,
                               "label4": label4, "label5": label5]
        
        // horizontal contraints...telling the labels to go from border to border
//        for label in viewsDictionary.keys {
//            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(label)]|", options: [], metrics: nil, views: viewsDictionary))
//        }
        
        // vertical constraints, the manual way
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1(==88)]-[label2(==88)]-[label3(==88)]-[label4(==88)]-[label5(==88)]-(>=10)-|",options: [], metrics: nil, views: viewsDictionary))
        
        // using metrics to have much better/easier to manage constraints
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1(labelHeight)]-[label2(labelHeight)]-[label3(labelHeight)]-[label4(labelHeight)]-[label5(labelHeight)]-(>=10)-|", options: [], metrics: ["labelHeight": 88], views: viewsDictionary))
        
        // setting a priority on the first label, and then having all other labels adopt its height
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]-(>=10)-|", options: [], metrics: ["labelHeight": 88], views: viewsDictionary))

    
        // FINAL FORM:
        // part of this is we want to set the top anchor of each label to the previous label, model the very first label with an option previous label
        var previous: UILabel?
        for label in viewsDictionary.keys {
            viewsDictionary[label]!.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            viewsDictionary[label]!.heightAnchor.constraint(equalToConstant: 88).isActive = true
            
            if let previous = previous {
                // we have a previous label -- create a height constraint
                viewsDictionary[label]!.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
            }
            // set the previous label to the current one, for the next loop iteration
            previous = viewsDictionary[label]!
        }
        
    }
    
    


}

