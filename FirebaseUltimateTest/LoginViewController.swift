//
//  LoginViewController.swift
//  FirebaseUltimateTest
//
//  Created by Luis Eduardo Brime Gomez on 6/5/19.
//  Copyright © 2019 Luis Eduardo Brime Gomez. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    

    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var errorLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func login(_ sender: Any) {
        let email = txtEmail.text!
        let password = txtPassword.text!
        
        let domain = getDomain(s: email)
        if domain != "itesm.mx" && domain != "tec.mx" {
            errorLbl.isHidden = false
            errorLbl.text = "El correo no es institucional."
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                self.errorLbl.isHidden = false
                self.errorLbl.text = "Incorrect email or password."
                print(error!)
                return
            }
            self.errorLbl.isHidden = true
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        let email = txtEmail.text!
        let password = txtPassword.text!
        
        let domain = getDomain(s: email)
        if domain != "itesm.mx" && domain != "tec.mx" {
            errorLbl.isHidden = false
            errorLbl.text = "El correo no es institucional."
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if error != nil {
                self.errorLbl.isHidden = false
                self.errorLbl.text = "Error al crear usuario."
            }
            self.errorLbl.isHidden = false
            self.errorLbl.text = "Usuario creado."
        }
    }
    
    private func getDomain(s: String) -> String {
        let r = s.components(separatedBy: "@").last
        return r!
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
