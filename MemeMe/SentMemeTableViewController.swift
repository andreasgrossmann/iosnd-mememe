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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentMemeTableCell", for: indexPath)
        let meme = memes[indexPath.row]
        cell.imageView!.image = meme.originalImage
        cell.textLabel?.text = meme.topText! + " " + meme.bottomText!
        
        return cell
    }
    
    
    
    


}
