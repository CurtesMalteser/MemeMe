//
//  SentMemesTableVC.swift
//  MemeMe
//
//  Created by Antonio on 06.06.20.
//  Copyright © 2020 CurtesMalteser. All rights reserved.
//

import UIKit

class SentMemesTableVC: UIViewController {
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
}
