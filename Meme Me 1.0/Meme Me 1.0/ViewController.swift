//
//  ViewController.swift
//  Meme Me 1.0
//
//  Created by Chris Zink on 5/11/18.
//  Copyright © 2018 Happy Pappy's Apps. All rights reserved.
//

import UIKit


class MemeMeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    var imagePicker = UIImagePickerController()
    var memeMeTextFields = [UITextField]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        topTextField.delegate = self
        bottomTextField.delegate = self
        shareButton.isEnabled = false
        textFieldPreferences(topTextField)
        textFieldPreferences(bottomTextField)
        cameraCheck()
        NotificationCenter.default.addObserver(self, selector: #selector(MemeMeViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MemeMeViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    
    
//Check for Camera

    func cameraCheck() {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    
// UITextField Preferences and functions
    let memeTextAttributed: [String: Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -4.0,]
    
    
    func textFieldPreferences( _ textField:UITextField) {
        textField.delegate = self
        textField.textAlignment = .center
        textField.backgroundColor = UIColor.clear
        textField.defaultTextAttributes = memeTextAttributed

        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       textField.text = ""
    }
    
// Keyboard Functions
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder {
                self.view.frame.origin.y -= getKeyboardHeight(notification: notification)
    
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        
        return true
    }
    
// Generating the Meme
    
    func generateMemedImage() -> UIImage {
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as?
            
            UIImage {
            
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
            shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    



    
//Sharing the Meme
    
    
    func save() {
        
        let meme = Meme (topText: topTextField.text, bottomText: bottomTextField.text, originalImage: imageView.image, memedImage: generateMemedImage())

    }
    
    func share() {
        let memeToShare = generateMemedImage()
        
        let activityController = UIActivityViewController(activityItems: [memeToShare as Any], applicationActivities: nil)
        activityController.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if completed {
                self.save()
            }
        }
        self.present(activityController, animated: true, completion: nil)
        
    }

    
// Code for Buttons
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        
        share()
        
    }

    @IBAction func albumButtonPressed(_ sender: Any) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
      
        
    }

}


