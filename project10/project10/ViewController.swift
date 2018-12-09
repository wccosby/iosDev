//
//  ViewController.swift
//  project10
//
//  Created by William Cosby on 12/4/18.
//  Copyright © 2018 William Cosby. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var people = [Person]() // list of our custom Person data type (its a Class)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // add a button so that people can load pictures in to the app
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
        let defaults = UserDefaults.standard
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPeople) as? [Person] {
                people = decodedPeople ?? [Person]()
            }
        }
    }

    /////////////
    // tell the app how many items to expect in the collection view
    /////////////
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    /////////////
    // tell the app what to expect in each collection view cell
    /////////////
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as! PersonCell
        
        let person = people[indexPath.item] // gets the index of the item we are looking at
        cell.name.text = person.name
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        // some styling
        cell.imageView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        return cell
    }
    
    /////////////
    // rename a person
    /////////////
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
        ac.addTextField() // adds an input field for the user
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel)) // don't need a handler, this will just dismiss
        // using a trailing closure here because we want to take the value input and move it to our app
        ac.addAction(UIAlertAction(title: "Save", style: .default) { [unowned self, ac] _ in
            let newName = ac.textFields![0]
            person.name = newName.text!
            self.save() // save the userDefaults
            self.collectionView?.reloadData()
        })
        
        present(ac, animated: true)
    }
    
    /////////////
    // add a new person to the collection
    /////////////
    @objc func addNewPerson() { // being called from #selector, so need the @objc
        let picker = UIImagePickerController()
        picker.allowsEditing = true // allow user to crop the photos
        picker.delegate = self // inheriting from UIImagePickerControllerDelegate and UINavigationControllerDelegate
        present(picker, animated: true)
    }
    
    /////////////
    // need to implement this delegate method that is inherited from UIImagePickerControllerDelegate
    // this method will, extract image from dictionary, generate unique filename for it, convert it to JPEG and then write it to disk, dismiss the view controller
    /////////////
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // get a reference to the original image
        guard let image = info[.originalImage] as? UIImage else {return} // make sure what is being passed is an image
        
        let imageName = UUID().uuidString // create the unique name
        
        // get the path to the documents directory and add the filename to the path so we can save the image
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        // write the image to disk
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        self.save() // saving for UserDefaults
        collectionView?.reloadData()
        
        dismiss(animated: true)
    }
    
    /////////////
    // get the location of the Documents directory in the app
    /////////////
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    //////////////
    // code to save data to UserDefaults
    // this method will be called anytime we update a person's name or image
    // converts the array of people into a Data object that can be stored in the UserDefaults
    //////////////
    func save() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false) { // saving the people array in UserDefaults
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "People")
        }
    }
}

