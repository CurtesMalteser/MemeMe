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
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        memeTextFieldAttributes(defaultTopText, textField: topTextField)
        
        memeTextFieldAttributes(defaultBottomText, textField: bottomTextField)
        
        shareButton.isEnabled = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        present(setUpImagePicker(sourceType: .photoLibrary), animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        present(setUpImagePicker(sourceType: .camera), animated: true, completion: nil)
    }
    
    // Function to initialise UIImagePickerController.
    // Added to avoid code duplication.
    func setUpImagePicker( sourceType : UIImagePickerController.SourceType) -> UIImagePickerController{
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        
        return imagePicker
    }
    
    @IBAction func cancelMeme(_ sender: Any) {
        imagePickerView.image = nil
        
        shareButton.isEnabled = false
        
        memeTextFieldAttributes(defaultTopText, textField: topTextField)
        
        memeTextFieldAttributes(defaultBottomText, textField: bottomTextField)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        
        let memedImage =  generateMemedImage()
        
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                // User canceled
                return
            }
            
            // User completed activity
            self.save(memedImage: memedImage)
        }
        
        present(activityViewController, animated: true, completion: nil)
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
        topTooltbar.isHidden = true
        bottomToolbar.isHidden = true
        
        // Change background color to black,
        // so meme doesn't include the white color left from removing toolbars
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        topTooltbar.isHidden = false
        bottomToolbar.isHidden = false
        
        // Change background color back to white
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        return memedImage
    }
    
    func save(memedImage : UIImage) {
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
    }
    
    // UITextField default attributes.
    fileprivate let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -1.0
    ]
    
    // Function to avoid code duplication, since both text field will have same default attributtes.
    
    func memeTextFieldAttributes(_ string : String, textField: UITextField) {
        textField.isEnabled = false
        textField.text = string
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = self
    }
    
}


