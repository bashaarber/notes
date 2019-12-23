//
//  UpdateViewController.swift
//  NotesApp
//
//  Created by Arber Basha on 19/09/2019.
//  Copyright © 2019 Arber Basha. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import IQKeyboardManagerSwift
import LocalAuthentication

class UpdateViewController: UIViewController , UITextViewDelegate , UITextFieldDelegate{
    
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtViewText: UITextView!
    @IBOutlet weak var lblUpdateNote: UILabel!
    
    var noteDocumentID: String!
    var noteTitle: String!
    var noteText: String!
    var userEmail: String!
    let db = Firestore.firestore()
    var blurEffectView: UIView!
    var darkMode: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createScreenEdgeSwipe()
        setUpTexts()
        txtTitle.text = noteTitle
        txtViewText.text = noteText
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if darkMode == true {
            view.backgroundColor = UIColor.black
            lblUpdateNote.textColor = UIColor.white
            txtViewText.layer.borderWidth = 1.0
            txtViewText.clipsToBounds = true
            txtViewText.layer.cornerRadius = 10
            txtViewText.layer.borderColor = UIColor.white.cgColor
            txtViewText.textColor = UIColor.white
            txtViewText.backgroundColor = UIColor.black
            txtViewText.keyboardAppearance = .dark
            txtTitle.layer.borderWidth = 1.0
            txtTitle.clipsToBounds = true
            txtTitle.layer.cornerRadius = 10
            txtTitle.layer.borderColor = UIColor.white.cgColor
            txtTitle.textColor = UIColor.white
        }
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
    
    func setUpTexts(){
        txtViewText.delegate = self
        txtViewText.layer.borderWidth = 1.0
        txtViewText.clipsToBounds = true
        txtViewText.layer.cornerRadius = 10
        txtViewText.layer.maskedCorners = [.layerMinXMaxYCorner , .layerMaxXMaxYCorner]
        txtTitle.delegate = self
        txtTitle.layer.borderWidth = 1.0
        txtTitle.clipsToBounds = true
        txtTitle.layer.cornerRadius = 10
        txtTitle.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtTitle.resignFirstResponder()
        return true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            txtViewText.resignFirstResponder()
            return false
        }
        return true
    }
    

    @IBAction func btnUpdateTap(_ sender: Any) {
        SVProgressHUD.setDefaultStyle(.dark)
        createCustomBlur()
        SVProgressHUD.show(withStatus: "Updating")
        let title = txtTitle.text!
        let text = txtViewText.text!
        if (title != ""){
            db.collection(userEmail).document(noteDocumentID).updateData([
                "title": title,
                "text": text
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                }
            }
            self.navigationController?.popViewController(animated: true)
        }else{
            self.showErrorWith(message: "Title must have at least one letter")
            blurEffectView.removeFromSuperview()
            SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func btnTrashTap(_ sender: Any) {
          authenticateUser()
    }
    
    func createCustomBlur(){
        let blurEffect = UIBlurEffect(style: .regular) // .extraLight or .dark
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        view.addSubview(blurEffectView)
    }
    
    func createScreenEdgeSwipe(){
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        
        view.addGestureRecognizer(edgePan)
    }
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            SVProgressHUD.setDefaultStyle(.dark)
            SVProgressHUD.show()
            self.navigationController?.popViewController(animated: false)
        }
    }

    func showErrorWith(message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
        self.present(alert, animated: true)
    }
    
    func authenticateUser(){
        let context = LAContext()
        var error: NSError?


        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] success, authenticationError in

                DispatchQueue.main.async {
                    if success {
                        
                        SVProgressHUD.setDefaultStyle(.dark)
                        self.createCustomBlur()
                        SVProgressHUD.show(withStatus: "Deleting")
                        self.db.collection(self.userEmail).document(self.noteDocumentID).delete() { err in
                            if let err = err {
                                print("Error removing document: \(err)")
                            } else {
                            }
                        }
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "Sorry!", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                    }
                }
            }
        }
//        else {
//            let ac = UIAlertController(title: "Touch ID not available", message: "Your device is not configured for Touch ID.", preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .default))
//            present(ac, animated: true)
//        }

    }
    
   
}
