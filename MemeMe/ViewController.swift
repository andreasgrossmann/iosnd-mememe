//
//  ViewController.swift
//  MemeMe
//
//  Created by Andreas on 27/08/2016.
//  Copyright © 2016 Andreas. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var memeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func pickImage(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker:UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Place selected image in the view
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImage.image = image
            dismissViewControllerAnimated(true, completion: nil)
        }
    }

}

