//
//  SentMemeTableViewController.swift
//  MemeMe
//
//  Created by Andreas on 9/09/2016.
//  Copyright © 2016 Andreas. All rights reserved.
//

import UIKit

class SentMemeTableViewController: UITableViewController {


    
    
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set table row height
        tableView.rowHeight = 100.0
        
        // Remove separator lines on table
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentMemeTableCell", for: indexPath) as! SentMemeTableViewCell
        let meme = memes[indexPath.row]
//        cell.sentMemeTableImage.contentMode = UIViewContentMode.scaleAspectFill
        cell.sentMemeTableImage!.image = meme.originalImage
        
        
        
        
        
        
        // Styles for label text
        
        let textAttributes = [NSStrokeColorAttributeName: UIColor.black,
                              NSForegroundColorAttributeName: UIColor.white,
                              NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!,
                              NSStrokeWidthAttributeName: Float(-5.0)] as [String : Any]
        
        // Set label text to meme text
        
        let attribTextTop = NSAttributedString(string: meme.topText!, attributes: textAttributes)
        let attribTextBottom = NSAttributedString(string: meme.bottomText!, attributes: textAttributes)
        
        cell.sentMemeTableTextTop.attributedText = attribTextTop
        cell.sentMemeTableTextBottom.attributedText = attribTextBottom
        
        
        
        
        
        
        cell.sentMemeTableLabel?.text = meme.topText! + " " + meme.bottomText!
        
        return cell
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sentMemeDetail = storyboard!.instantiateViewController(withIdentifier: "SentMemeDetailView") as! SentMemeDetailViewController
        sentMemeDetail.meme = memes[indexPath.row]
        navigationController!.pushViewController(sentMemeDetail, animated: true)
    }
    
    
    
    


}
