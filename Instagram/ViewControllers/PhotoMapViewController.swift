//
//  PhotoMapViewController.swift
//  Instagram
//
//  Created by German Flores on 3/4/18.
//  Copyright © 2018 German Flores. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var window: UIWindow?
    
    @IBOutlet weak var captionField: UITextField!
    @IBOutlet weak var uploadImageView: UIImageView!
    
    var postImage: UIImage! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createImagePicker()
    }
    
    func createImagePicker() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func clear() {
        uploadImageView.image = UIImage(named: "image_placeholder")
        captionField.text = ""
        postImage = nil
    }
    
    @IBAction func uploadImage(_ sender: Any) {
        print("loading images")
        createImagePicker()
    }

    @IBAction func cancelPost(_ sender: Any) {
        clear()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "AuthenticatedViewController")
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        _ = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        self.postImage = editedImage
        
        uploadImageView.image = editedImage
        print("image dismissed")
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func shareButton(_ sender: Any) {
        if postImage == nil {
            presentAlert(msg: "No image chosen", description: "Bruh.. select an image b4 sharing duh")
        } else {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            //post img to parse
            print("img posting to parse...")
            Post.postUserImage(image: postImage, withCaption: captionField.text, withCompletion: { (success: Bool, error: Error?) in
                if success {
                    print("successfully loaded image")
                } else {
                    print("oh no! error occurred while posting image")
                }
                MBProgressHUD.hide(for: self.view, animated: true)
                self.clear()
            })
        }
    }
    
    func presentAlert(msg: String, description: String) {
        let alertController = UIAlertController(title: msg, message: description, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    // Resize image to store to db
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x:0, y:0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
