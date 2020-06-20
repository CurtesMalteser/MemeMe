//
//  SentMemesCollectionVC.swift
//  MemeMe
//
//  Created by Antonio on 06.06.20.
//  Copyright © 2020 CurtesMalteser. All rights reserved.
//

import UIKit
import Foundation

class SentMemesCollectionVC: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var memesCollectionView: UICollectionView!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        memesCollectionView.reloadData()
    }
    
    // measures the width of the view passed as param and divides it by the number of cells per row
    func setCollectionViewCellDimensions(_ view: UIView) {
        
        let space : CGFloat = 3
        let numberOfItemsPerRow : CGFloat = 3
        
        let dimension = (view.frame.size.width - (space * (numberOfItemsPerRow - 1))) / numberOfItemsPerRow
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionViewCellDimensions(view)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.memeCollectionViewCell, for: indexPath) as! MemeCollectionViewCell
        
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        cell.memeImageView?.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let meme = memes[(indexPath as NSIndexPath).row]
        
        pushMemeDetail(meme: meme, storyboard: storyboard, navigationController: navigationController)
    }
    
    @IBAction func presentMemeEditor(_ sender: Any) {
        presentMemeEditor(completionHandler: {self.memesCollectionView.reloadData()}, storyboard: storyboard, navigationController: navigationController)
    }
    
}
