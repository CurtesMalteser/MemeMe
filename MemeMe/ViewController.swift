//
//  ViewController.swift
//  MemeMe
//
//  Created by Antonio on 02.05.20.
//  Copyright © 2020 CurtesMalteser. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func pickAnImage(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage  {
            imagePickerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            imagePickerView.image = image
        }
        
        picker.dismiss(animated: true, completion:{print("imagePickerController")})
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion:{print("imagePickerControllerDidCancel")})
    }
    
}

