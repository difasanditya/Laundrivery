//
//  SignInVC.swift
//  Laundrivery
//
//  Created by Difa Sanditya Alifian on 03/12/17.
//  Copyright © 2017 Difa Sanditya Alifian. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class SignInVC: UIViewController {
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBAction func signInDidTapped(_ sender: Any) {
        guard
            let email = emailTF.text, email != "",
            let password = passwordTF.text, password != ""
            else {
                AlertController.showAlert(self, title: "Missing Information", message: "Please fill out all fields")
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            guard
                error == nil
                else {
                    AlertController.showAlert(self, title: "Error", message: error!.localizedDescription)
                    return
            }
            
            guard
                let users = user
                else {
                    return
            }
            
            DatabaseService.shared.profile.child(users.uid).observe(.value, with: { (snapshot) in
                print(snapshot)
                guard let snapDict = snapshot.value as? [String: Any] else {return}
                let userData = UserData(user: users, dict: snapDict)
                DatabaseService.shared.addUser(user: userData!)
            })
            
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
