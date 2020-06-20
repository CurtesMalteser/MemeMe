//
//  MemeDetailVC.swift
//  MemeMe
//
//  Created by Antonio on 14.06.20.
//  Copyright © 2020 CurtesMalteser. All rights reserved.
//

import UIKit

class MemeDetailVC: UIViewController {
    
    var meme : Meme!
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    override func viewDidLoad() {
        memeImageView.image = meme.memedImage
    }
    
}
