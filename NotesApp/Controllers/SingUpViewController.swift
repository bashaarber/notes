//
//  SingUpViewController.swift
//  NotesApp
//
//  Created by Arber Basha on 17/09/2019.
//  Copyright © 2019 Arber Basha. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import IQKeyboardManagerSwift
import SVProgressHUD

class SingUpViewController: UIViewController , UITextFieldDelegate {

    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFieldDelegate()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 70
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func setupTextFieldDelegate(){
        txtEmail.delegate = self
        txtPassword.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
        return true
    }

    @IBAction func btnCreateTap(_ sender: Any) {
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
        SVProgressHUD.show()
        let email = txtEmail.text!
        let password = txtPassword.text!
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if authResult != nil{
                self.dismiss(animated: true) {
                    SVProgressHUD.dismiss()
                }
            }else{
                SVProgressHUD.dismiss()
                self.showErrorWith(message: "Email or Password is Wrong")
            }
        }
    }
    
    @IBAction func btnCloseTap(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    
    func showErrorWith(message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
        self.present(alert, animated: true)
    }
    
}
