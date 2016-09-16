//
//  SentMemeCollectionViewController.swift
//  MemeMe
//
//  Created by Andreas on 9/09/2016.
//  Copyright © 2016 Andreas. All rights reserved.
//

import UIKit

class SentMemeCollectionViewController: UICollectionViewController {

    
    
    
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentMemeCollectionItem", for: indexPath)
        let meme = memes[indexPath.item]
        let imageView = UIImageView(image: meme.memedImage)
        cell.backgroundView = imageView
        
        return cell
    }
    
    
    

}
