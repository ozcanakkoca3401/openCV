//
//  MainVC.swift
//  SegueExample
//
//  Created by Michael Teter on 2016-09-14.
//  Copyright © 2016 Michael Teter. All rights reserved.
//

import UIKit

class MainVC: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    var img: UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let theInfo:NSDictionary = info as NSDictionary
        if let image = theInfo.object(forKey: UIImagePickerControllerOriginalImage) as? UIImage {
            imageView.image = image
            img = image
            
        } else{
            print("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
        
        
        let otherVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewControllerID") as! ViewController
        otherVC.img = img
        self.present(otherVC, animated: true, completion: nil)
    }
    
    
    @IBAction func gallery(_ sender: AnyObject) {
        let image = UIImagePickerController();
        image.delegate = self;
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary;
        image.allowsEditing = true;
        self.present(image, animated: true, completion: nil)
    }
    
    @IBAction func camera(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else {
            print("camera yok")
        }
    }
    
}

