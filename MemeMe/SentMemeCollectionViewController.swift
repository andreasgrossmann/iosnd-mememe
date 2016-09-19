//
//  SentMemeCollectionViewController.swift
//  MemeMe
//
//  Created by Andreas on 9/09/2016.
//  Copyright © 2016 Andreas. All rights reserved.
//

import UIKit

class SentMemeCollectionViewController: UICollectionViewController {

    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Flow layout
        
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView?.reloadData()
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentMemeCollectionCell", for: indexPath) as! SentMemeCollectionViewCell
        let meme = memes[indexPath.item]
        cell.sentMemeCollectionImage.image = meme.originalImage

        
        
        
        // Styles for label text
        
        let textAttributes = [NSStrokeColorAttributeName: UIColor.black,
                              NSForegroundColorAttributeName: UIColor.white,
                              NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!,
                              NSStrokeWidthAttributeName: Float(-5.0)] as [String : Any]
        
        // Set label text to meme text
        
        let attribTextTop = NSAttributedString(string: meme.topText!, attributes: textAttributes)
        let attribTextBottom = NSAttributedString(string: meme.bottomText!, attributes: textAttributes)
        
        cell.sentMemeCollectionTextTop.attributedText = attribTextTop
        cell.sentMemeCollectionTextBottom.attributedText = attribTextBottom
        
        
        
        
        return cell
    }
    
    
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let sentMemeDetail = storyboard!.instantiateViewController(withIdentifier: "SentMemeDetailView") as! SentMemeDetailViewController
        sentMemeDetail.meme = memes[indexPath.row]
        navigationController!.pushViewController(sentMemeDetail, animated: true)
    }
    
    
    

}
