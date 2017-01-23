//
//  ViewController.swift
//  openCViOS
//https://www.youtube.com/watch?v=Qx4GIKOwhD0
//  Created by ozcan akkoca on 12/11/2016.
//  Copyright © 2016 ozcan akkoca. All rights reserved.
// https://turbofuture.com/cell-phones/Access-Photo-Camera-and-Library-in-Swift
// https://www.youtube.com/watch?v=13ySrky_5D0
//https://www.veasoftware.com/posts/uipageviewcontroller-in-swift-xcode-62-ios-82-tutorial

import UIKit
import Foundation
import iCarousel

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, iCarouselDelegate, iCarouselDataSource {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var DisplayView: iCarousel!
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    var img: UIImage!
    
    
    var filterArray: NSMutableArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("calisti");
        
        //imageArray = ["aa.jpeg","aa.jpeg","aa.jpeg","aa.jpeg","aa.jpeg","aa.jpeg","aa.jpeg","aa.jpeg","aa.jpeg","aa.jpeg","aa.jpeg","aa.jpeg"];
        
        filterArray = ["kontrastgerme","esikleme","negatif","GammaCorrection","logaritma","BitWise","histogram","ortalama","medyan","laplace","sobel","gaussNoise","saltpapper","rgbToHsiAndHistogram", "AddGaussianNoise","Canny", "erode", "dilate", "kapama", "acma", "prewitt", "gaussBlur", "Resmi Çevirme"];
        
        
        DisplayView.type = iCarouselType.linear
        //DisplayVi
        // DisplayView.isWrapEnabled
        DisplayView.reloadData()
        
        imageView.image = img
        
        self.navBar.title = "Word of Byte"
        
        
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView
    {
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        label.center = CGPoint(x: 0, y: 25)
        label.textAlignment = .center
        label.text = "\(filterArray.object(at: index))"
        label.backgroundColor = UIColor.white
        tempView.addSubview(label)
        return tempView
        
        /*var imageView: UIImageView
         if (view == nil)
         {
         imageView = UIImageView(frame:CGRect(x:0, y:0, width:50, height:50))
         imageView.contentMode = .scaleAspectFit
         }
         else
         {
         imageView = view as! UIImageView;
         }
         imageView.image = UIImage(named: "\(imageArray.object(at: index))")
         
         return imageView */
        
    }
    
    
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return filterArray.count
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.1
        }
        
        if(option == .wrap) {
            return 0
        }
        
        return value
    }
    
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        imageView.image =  CPP_Wrapper.makeGrayImage(img, number: Int32(index));
        self.navBar.title = "\(filterArray.object(at: index))"
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func saveImage(_ sender: Any) {
        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.6)
        let compressedJPGImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
        
        let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
        }
        
        
        // Add the actions
        alertController.addAction(okAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func grayImage(_ sender: Any) {
        CPP_Wrapper().helloCPPWrapper("World")
        imageView.image = img;  //CPP_Wrapper.makeGrayImage(imageView.image, number: 0);
        
    }
}

