//
//  SentMemeDetailViewController.swift
//  MemeMe
//
//  Created by Andreas on 16/09/2016.
//  Copyright © 2016 Andreas. All rights reserved.
//

import UIKit

class SentMemeDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!

    var meme: Meme!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide tab bar
        tabBarController?.tabBar.isHidden = true
        
        // Place meme image
        if let meme = meme {
            imageView!.image = meme.memedImage
        } else {
            print("Something's not right") // Error
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show tab bar
        tabBarController?.tabBar.isHidden = false
    }

}
