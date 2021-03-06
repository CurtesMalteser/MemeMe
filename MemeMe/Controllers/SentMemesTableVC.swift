//
//  SentMemesTableVC.swift
//  MemeMe
//
//  Created by Antonio on 06.06.20.
//  Copyright © 2020 CurtesMalteser. All rights reserved.
//

import UIKit

class SentMemesTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    @IBOutlet weak var memesTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        memesTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.memeCell)!
        
        let meme = memes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        cell.textLabel?.text = meme.topText
        // FIXME: implementation to show memed image
        cell.imageView?.image = meme.memedImage
        
        // If the cell has a detail label, we will put the evil scheme in.
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = "\(meme.bottomText)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meme = memes[(indexPath as NSIndexPath).row]
        
        pushMemeDetail(meme: meme, storyboard: storyboard, navigationController: navigationController)
        
        
    }
    
    @IBAction func presentMemeEditor(_ sender: Any) {
        presentMemeEditor(completionHandler: {self.memesTableView.reloadData()}, storyboard: storyboard, navigationController: navigationController)
    }
}
