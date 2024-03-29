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
    
    var blurEffectView: UIView!
    var handle: Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFieldDelegate()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        SVProgressHUD.dismiss()
        view.isUserInteractionEnabled = true
        deleteText()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 80
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func deleteText(){
        txtEmail.text = ""
        txtPassword.text = ""
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
        view.isUserInteractionEnabled = false
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
                vc.logedUser = authUser
                self?.navigationController?.pushViewController(vc, animated: true)
                SVProgressHUD.dismiss()
            }else{
                self?.showErrorWith(message: "Email or Password is wrong")
                SVProgressHUD.dismiss()
                self?.view.isUserInteractionEnabled = true
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
    
    func createCustomBlur(){
        let blurEffect = UIBlurEffect(style: .regular) // .extraLight or .dark
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        view.addSubview(blurEffectView)
    }
    
    
}
