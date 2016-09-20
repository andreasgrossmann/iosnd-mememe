//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Andreas on 27/08/2016.
//  Copyright © 2016 Andreas. All rights reserved.
//

import UIKit
import AVFoundation

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet var topText: UITextField!
    @IBOutlet var bottomText: UITextField!
    @IBOutlet var memeImage: UIImageView!
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var topBar: UIToolbar!
    @IBOutlet var bottomBar: UIToolbar!
    
    // Text field default values
    
    let topTextDefault = "TOP"
    let bottomTextDefault = "BOTTOM"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable share button initially
        
        shareButton.isEnabled = false
        
        // Text style attributes
        
        let centerText = NSMutableParagraphStyle()
        centerText.alignment = .center
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -5.0,
            NSParagraphStyleAttributeName: centerText
        ] as [String : Any]
        
        // Configure text fields
        
        func configureTextFields(_ textField: UITextField) {
            textField.defaultTextAttributes = memeTextAttributes
            textField.delegate = self
        }
        
        configureTextFields(topText)
        configureTextFields(bottomText)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Disable camera button on devices that don't have a camera
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
    
    // Clear textfield when editing begins
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }

    // Keyboard notifications
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name:
            NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Make view slide up when keyboard shows for bottom text and down again when keyboard hides
    
    func keyboardWillShow(_ notification: Notification) {
        if bottomText.isFirstResponder {
            view.frame.origin.y =  getKeyboardHeight(notification) * -1
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if bottomText.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // When an empty string is entered, set textfield to default value
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (topText.text == "") {topText.text = topTextDefault}
        if (bottomText.text == "") {bottomText.text = bottomTextDefault}
    }
    
    // Hide keyboard when return key is pressed
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }

    // Configure image picker
    
    func configureImagePicker(_ source: UIImagePickerControllerSourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        imagePicker.sourceType = source
        
        present(imagePicker, animated: true, completion: nil)
        
    }

    // Pick an existing photo from the device
    
    @IBAction func pickImage(_ sender: AnyObject) {
        
        configureImagePicker(UIImagePickerControllerSourceType.photoLibrary)
        
    }

    // Take a new photo
    
    @IBAction func takePhoto(_ sender: AnyObject) {
        
        configureImagePicker(UIImagePickerControllerSourceType.camera)
    }

    // Formally dismiss view controller when image picking is cancelled
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Place selected image in view
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImage.image = image
            dismiss(animated: true, completion: nil)
        }
        
        shareButton.isEnabled = true // enable share button when image is placed
    }

    // Dismiss this view controller when cancel button is pressed
    
    @IBAction func cancelMeme(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    // Show and hide navigation function
    
    func showHideNav(_ hide: Bool) {
        topBar.isHidden = hide
        bottomBar.isHidden = hide
    }
    
    // Generate Meme
    
    func generateMemedImage() -> UIImage {
        
        // Hide navigation
        showHideNav(true)
        
        // Capture the actual meme
        let actualMeme = AVMakeRect(aspectRatio: memeImage.image!.size, insideRect: memeImage.frame)
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: actualMeme.width,height: actualMeme.height), false, 0)
        view.drawHierarchy(in: CGRect(x: -actualMeme.origin.x, y: -actualMeme.origin.y, width: view.frame.size.width, height: view.frame.size.height), afterScreenUpdates: true)
        
        // Render meme as image
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show navigation
        showHideNav(false)
        
        return memedImage!
    }
    
    // Save Meme function
    
    func saveMeme() {
        let memedImage = generateMemedImage()
        let meme = Meme(topText: self.topText.text, bottomText: self.bottomText.text, originalImage: self.memeImage.image, memedImage: memedImage)
        
        // Add meme to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }

    // Share Meme
    
    @IBAction func shareMeme(_ sender: AnyObject) {
        let memedImage = generateMemedImage()
        let ActivityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        // If action is completed, save Meme and dismiss view controller
        
        ActivityVC.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.saveMeme()
                self.dismiss(animated: true, completion: nil)
            } else if (error != nil) {
                print(error) // TODO: Show the user an error message in version 2.0
            }
        }
        
        present(ActivityVC, animated: true, completion: nil)
    }

}

