//
//  UIViewControllerExtension.swift
//  MemeMe
//
//  Created by Antonio on 15.06.20.
//  Copyright © 2020 CurtesMalteser. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // Pushes view controller meme detail
    func pushMemeDetail(meme: Meme, storyboard: UIStoryboard?, navigationController: UINavigationController?) {
        
        let detailController = storyboard?.instantiateViewController(withIdentifier: "MemeDetailVC") as! MemeDetailVC
        
        detailController.meme = meme
        
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    // Presents meme editor modally
    func presentMemeEditor(completionHandler: (()->Void)?, storyboard: UIStoryboard?, navigationController: UINavigationController?) {
        let memeEditorController = storyboard?.instantiateViewController(withIdentifier: "MemeEditorVC") as! MemeEditorVC
        
        memeEditorController.completionHandler = completionHandler
        
        navigationController?.present(memeEditorController, animated: true, completion: nil)
    }
}
