//
//  LoginViewController.swift
//  Instagram
//
//  Created by German Flores on 3/4/18.
//  Copyright © 2018 German Flores. All rights reserved.
//

import UIKit
import Parse
import Pastel

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pastelView = PastelView(frame: view.bounds)
        
        // Custom Direction
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        
        // Custom Duration
        pastelView.animationDuration = 3.0
        
        // Custom Color
        pastelView.setColors([UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                              UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
                              UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                              UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)])
        
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onSignIn(_ sender: Any) {
        
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("User log in failed: \(error.localizedDescription)")
            } else {
                print("User logged in successfully")
                // display view controller that needs to shown after successful login
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }

    }
    
    @IBAction func onSignUp(_ sender: Any) {
        //init new user object
        let newUser = PFUser()
        //set user properties
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        
        //call sign up function on the object
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Leggooo, registered successfully!")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    //gives alert for any empty fields
    func emptyFieldAlert() {
        if((usernameField.text?.isEmpty)! || (passwordField.text?.isEmpty)!){
            let alertController = UIAlertController(title: "Username and Password required", message: "Please enter a username or password", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            })
            alertController.addAction(okAction)
        }
    }

}
