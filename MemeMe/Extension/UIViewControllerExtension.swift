//
//  UIViewControllerExtension.swift
//  MemeMe
//
//  Created by Antonio on 15.06.20.
//  Copyright © 2020 CurtesMalteser. All rights reserved.
//

import UIKit

extension UIViewController {
     func presentMemeEditor(storyboard: UIStoryboard?, navigationController: UINavigationController?, completionHandler: (()->Void)?) {
        let memeEditorController = storyboard?.instantiateViewController(withIdentifier: "MemeEditorVC") as! MemeEditorVC
        
        memeEditorController.completionHandler = completionHandler
        
        navigationController?.present(memeEditorController, animated: true, completion: nil)
    }
}
