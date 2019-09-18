//
//  MainViewController.swift
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

class MainViewController: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var handle: Auth!
    
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
    

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
        return true
    }
    func setupTextFieldDelegate(){
        txtEmail.delegate = self
        txtPassword.delegate = self
    }
     
    @IBAction func btnLoginTap(_ sender: Any) {
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
        SVProgressHUD.show()
        let email = txtEmail.text!
        let password = txtPassword.text!
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            if let usr = user {
                let authUser = usr.user
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "notesListVC") as! NotesListViewController
                vc.user = authUser
                self?.navigationController?.pushViewController(vc, animated: true)
                SVProgressHUD.dismiss()
            }else{
                self?.showErrorWith(message: "Email or Password is wrong")
                SVProgressHUD.dismiss()
            }
        }

    }

    @IBAction func btnSingUpTap(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "singupCV") as! SingUpViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    func showErrorWith(message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    
}
