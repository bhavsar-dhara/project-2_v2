//
//  ViewController.swift
//  MemeMe_v1.0
//
//  Created by Dhara Bhavsar on 2021-08-19.
//  Copyright © 2021 Dhara Bhavsar. All rights reserved.
//

import UIKit

class CreateMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    
    
     // MARK: UI component variables
    @IBOutlet weak var topNavBar: UINavigationBar!
    @IBOutlet weak var share: UIBarItem!
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var camera: UIButton!
    @IBOutlet weak var album: UIButton!
    
    var activeField: UITextField?
    var memedImage: UIImage!
    
    
    
    // MARK: Default constants
    let topDefaultTxt = "TOP"
    let bottomDefaultTxt = "BOTTOM"
    let imagePicker = UIImagePickerController()
    
    
    
    //MARK: Fetch memes from shared model data
    var memes : [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
        
    
    // MARK: Inherent Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Any additional setup after loading the view.
        
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(1),
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: -5.0,
        ]
        
        setTextFieldAttributes(textfield: topTextField, attributes: memeTextAttributes, textVal: topDefaultTxt)
        
        setTextFieldAttributes(textfield: bottomTextField, attributes: memeTextAttributes, textVal: bottomDefaultTxt)
        
        share.isEnabled = false

        // setting the title color when the camera button is disabled
        camera.setTitleColor(UIColor.systemBlue.withAlphaComponent(0.5), for: .disabled)
    }

    func setTextFieldAttributes(textfield: UITextField, attributes: [NSAttributedString.Key: Any], textVal: String) {
        textfield.defaultTextAttributes = attributes
        textfield.textAlignment = .center
        textfield.tintColor = .black
        textfield.delegate = self
        textfield.text = textVal
        view.bringSubviewToFront(textfield)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // disabling the camera button if the device doesn't have a camera, eg. simulator
        camera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        // subscribe to keyboard notifications, to allow the view to raise when necessary
        subscribeToKeyboardNotifications()
        subscribeToKeyboardNotificationsHide()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // unsubscribe to keyboard notifications
        unsubscribeFromKeyboardNotifications()
        subscribeToKeyboardNotificationsHide()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        // testing handle UI on device orientation change
        // print(UIDevice.current.orientation.isLandscape)
    }

    
    
    // MARK: Top Nav Bar methods
    @IBAction func tabBar(_ sender: UIButton) {
        // print("button label = ", sender.titleLabel ?? "No title label")
        if (sender.titleLabel?.text as AnyObject? === "Camera" as AnyObject) {
            launchController(sourceType: .camera)
        } else if (sender.titleLabel?.text as AnyObject? === "Album" as AnyObject) {
            launchController(sourceType: .photoLibrary)
        }
    }
    
    // Combined function to pick an image from an Album or the Camera app
    func launchController(sourceType: UIImagePickerController.SourceType) {
        print("LaunchController sourceType = ", sourceType)
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        // added the ability to crop the image
        imagePicker.allowsEditing = true
        // present(imagePicker, animated: true, completion: nil)
        
        //for iPhone
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            present(imagePicker, animated: true, completion: nil)
        }
        //for iPad
        else if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            // Change Rect as required
            present(imagePicker, animated: true, completion: nil)
            
            if let popOver = imagePicker.popoverPresentationController {
                popOver.permittedArrowDirections = UIPopoverArrowDirection.up
                popOver.sourceView = view
            }
        } else {
            print("Not an iPhone or iPad - Unspecified device")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = image
        }
        share.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func didCancel(_ sender: Any) {
        
    }
    
    
    
    // MARK: Text Field functions
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField.text == topDefaultTxt || textField.text == bottomDefaultTxt) {
            textField.text = ""
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.isEditing) {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    
    
    // MARK: Keyboard subscription functions called on the text fields
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        //Need to calculate keyboard exact size due to Apple suggestions
        var aRect : CGRect = view.frame
        let keyboardHeight = getKeyboardHeight(notification)
        aRect.size.height -= keyboardHeight
        if let activeField = activeField {
            if (!aRect.contains(activeField.frame.origin)){
                view.frame.origin.y = -keyboardHeight
            }
        }
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotificationsHide() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotificationsHide() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        //Once keyboard disappears, restore original positions
        view.frame.origin.y = 0
    }
    
    
    
    // MARK: Save/Share functions
    func save() {
        // Create the meme for saving
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: memedImage!)
        
        // Add it to the memes array on the application delegate
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        topNavBar.isHidden = true
        bottomStackView.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // Show hidden toolbar and navbar
        topNavBar.isHidden = false
        bottomStackView.isHidden = false
        
        return memedImage
    }
     
    @IBAction func shareMeme(_ sender: Any) {
        // generate a memed image
        memedImage = generateMemedImage()
        
        // define an instance of the ActivityViewController
        // pass the ActivityViewController a memedImage as an activity item
        let activityController = UIActivityViewController(activityItems: [memedImage!], applicationActivities: nil)
                    
        // present the ActivityViewController
        present(activityController, animated: true, completion: nil)
        
        if let popOver = activityController.popoverPresentationController {
            popOver.permittedArrowDirections = UIPopoverArrowDirection.up
            popOver.sourceView = view
        }
        
        // call methods with completion item handler
        activityController.completionWithItemsHandler = {
            (_, completed: Bool, _, error: Error?) in
               if completed {
                    print("share completed")
                    // save the create meme as an instance of a custom object
                    self.save()
                    activityController.dismiss(animated: true, completion: nil)
                    return
               } else {
                    print("cancel")
               }
               if let shareError = error {
                    print("error while sharing: \(shareError.localizedDescription)")
               }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        print("Cancel updates")
        // clearing out the image and text updates with the default
        imageView.image = nil
        topTextField.text = topDefaultTxt
        bottomTextField.text = bottomDefaultTxt
    }
}
