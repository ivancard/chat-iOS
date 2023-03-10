//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var infoLabel: UILabel!

    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextfield.text,
           let password = passwordTextfield.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    self.infoLabel.text = error.localizedDescription
                    self.animate()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.infoLabel.text = ""
                        self.animate()
                    }

                } else {
                    //Navigate to chatVC
                    self.performSegue(withIdentifier: Constants.registerSegue, sender: self)
                }
            }
        }
    }

    func animate(){
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}
