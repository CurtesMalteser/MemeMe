//
//  ViewController.swift
//  MemeMe
//
//  Created by Antonio on 02.05.20.
//  Copyright © 2020 CurtesMalteser. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var topTooltbar: UIToolbar!
    
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    let defaultTopText = "top".uppercased()
    var topText : String = ""
    
    let defaultBottomText = "bottom".uppercased()
    var bottomText : String = ""
    
    // Variable will assigned to selected text field (topTextField or bottomTextField) to check if keyboard is overlapping it on
    var selectedTextField : UITextField = UITextField()
    
    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        topTextField.memeTextFieldAttributes(defaultTopText, textFieldDelegate: self)
        
        bottomTextField.memeTextFieldAttributes(defaultBottomText, textFieldDelegate: self)
        
        shareButton.isEnabled = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeToKeyboardNotifications()
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelMeme(_ sender: Any) {
        imagePickerView.image = nil
        
        shareButton.isEnabled = false
        
        topTextField.memeTextFieldAttributes(defaultTopText, textFieldDelegate: self)
        
        bottomTextField.memeTextFieldAttributes(defaultBottomText, textFieldDelegate: self)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        save()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage  {
            imagePickerView.image = image
            shareButton.isEnabled = true
            topTextField.isEnabled = true
            bottomTextField.isEnabled = true
        }
        
        picker.dismiss(animated: true, completion:nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion:nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextField = textField
        let text = textField.text
        if text == defaultTopText || text == defaultBottomText {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /* Moves the UI up, if the keyboard covers the select text field, else nothing happens.
     It will be used to calculate the number of pixels that are overlapping and apply move the UI
     by subtracting this value from origin on y axis. */
    @objc func keyboardWillShow(_ notification: Notification) {
        
        let userInfo = notification.userInfo
        
        let keyboardSize = (userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        if  keyboardSize.intersects(self.selectedTextField.frame) {
            view.frame.origin.y = -keyboardSize.height
        }
        
    }
    
    // Moves the UI back to default position when keyboard hides.
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func generateMemedImage() -> UIImage {

        // Hide toolbar and navbar
        self.topTooltbar.isHidden = true
        self.bottomToolbar.isHidden = true

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // Show toolbar and navbar
        self.topTooltbar.isHidden = false
        self.bottomToolbar.isHidden = false

        return memedImage
    }
    
    func save() {
            // Create the meme
            let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        
        let activityViewController = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}

// UITextField default attributes.
fileprivate let memeTextAttributes: [NSAttributedString.Key: Any] = [
    NSAttributedString.Key.strokeColor: UIColor.black,
    NSAttributedString.Key.foregroundColor: UIColor.white,
    NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    NSAttributedString.Key.strokeWidth: -1.0
]

// Extension UITextField function to avoid code duplication, since both text field will have same default attributtes.
fileprivate extension UITextField {
    func memeTextFieldAttributes(_ string : String, textFieldDelegate: UITextFieldDelegate) {
        isEnabled = false
        text = string
        defaultTextAttributes = memeTextAttributes
        textAlignment = .center
        delegate = textFieldDelegate
    }
    
}

