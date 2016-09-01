//
//  ViewController.swift
//  MemeMe
//
//  Created by Andreas on 27/08/2016.
//  Copyright © 2016 Andreas. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet var topText: UITextField!
    @IBOutlet var bottomText: UITextField!
    @IBOutlet var memeImage: UIImageView!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var topBar: UIToolbar!
    @IBOutlet var bottomBar: UIToolbar!
    
    // Text field default values
    
    let topTextDefault = "TOP"
    let bottomTextDefault = "BOTTOM"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Text style attributes
        
        let centerText = NSMutableParagraphStyle()
        centerText.alignment = .Center
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -5.0,
            NSParagraphStyleAttributeName: centerText
        ]
        
        // Configure text fields
        
        func configureTextFields(textField: UITextField) {
            textField.defaultTextAttributes = memeTextAttributes
            textField.delegate = self
        }
        
        configureTextFields(topText)
        configureTextFields(bottomText)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Disable camera button on devices that don't have a camera
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
    
    // Clear textfield when editing begins
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }

    // Keyboard notifications
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // Make view slide up when keyboard shows for bottom text and down again when keyboard hides
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomText.isFirstResponder() {
            self.view.frame.origin.y =  getKeyboardHeight(notification) * -1
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomText.isFirstResponder() {
            self.view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    // When an empty string is entered, set textfield to default value
    
    func textFieldDidEndEditing(textField: UITextField) {
        if (topText.text == "") {topText.text = topTextDefault}
        if (bottomText.text == "") {bottomText.text = bottomTextDefault}
    }
    
    // Hide keyboard when return key is pressed
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    // Configure image picker
    
    func configureImagePicker(source: UIImagePickerControllerSourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        imagePicker.sourceType = source
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }

    // Pick an existing photo from the device
    
    @IBAction func pickImage(sender: AnyObject) {
        
        configureImagePicker(UIImagePickerControllerSourceType.PhotoLibrary)
        
    }

    // Take a new photo
    
    @IBAction func takePhoto(sender: AnyObject) {
        
        configureImagePicker(UIImagePickerControllerSourceType.Camera)
    }

    // Formally dismiss view controller when image picking is cancelled
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Place selected image in view
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImage.image = image
            dismissViewControllerAnimated(true, completion: nil)
        }
    }

    // Reset canvas when cancel button is pressed
    
    @IBAction func resetCanvas(sender: AnyObject) {
        topText.text = topTextDefault
        bottomText.text = bottomTextDefault
        memeImage.image = nil
    }
    
    // Show and hide navigation function
    
    func showHideNav(hide: Bool) {
        topBar.hidden = hide
        bottomBar.hidden = hide
    }
    
    // Share Meme
    
    @IBAction func shareMeme(sender: AnyObject) {
        let memedImage = generateMemedImage()
        let ActivityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        presentViewController(ActivityVC, animated: true, completion: nil)
    }
    
    // Generate Meme
    
    func generateMemedImage() -> UIImage {
        
        // Hide navigation
        showHideNav(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show navigation
        showHideNav(false)
        
        return memedImage
    }
    
    // Save Meme
    
    func save() {
        let memedImage = generateMemedImage()
        _ = Meme(topText: topText.text, bottomText: bottomText.text, originalImage: memeImage.image, memedImage: memedImage)
    }

}

