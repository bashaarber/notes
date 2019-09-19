//
//  CreateNoteViewController.swift
//  NotesApp
//
//  Created by Arber Basha on 18/09/2019.
//  Copyright © 2019 Arber Basha. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import IQKeyboardManagerSwift

class CreateNoteViewController: UIViewController , UITextViewDelegate , UITextFieldDelegate {

    @IBOutlet weak var txtViewText: UITextView!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var lblCreateNote: UILabel!
    
    var userEmail: String!
    let db = Firestore.firestore()
    var blurEffectView: UIView!
    var darkMode: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTexts()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if darkMode == true{
            view.backgroundColor = UIColor.black
            lblCreateNote.textColor = UIColor.white
            txtViewText.layer.borderWidth = 1.0
            txtViewText.clipsToBounds = true
            txtViewText.layer.cornerRadius = 10
            txtViewText.layer.borderColor = UIColor.white.cgColor
            txtViewText.textColor = UIColor.white
            txtViewText.backgroundColor = UIColor.black
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
        txtTitle.delegate = self
        txtTitle.layer.borderWidth = 1.0
        txtTitle.clipsToBounds = true
        txtTitle.layer.cornerRadius = 10
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

    @IBAction func btnCreateNotesTap(_ sender: Any) {
        SVProgressHUD.setDefaultStyle(.dark)
        createCustomBlur()
        SVProgressHUD.show(withStatus: "Creating")
            let title = self.txtTitle.text!
            let text = self.txtViewText.text!
            var ref: DocumentReference? = nil
            ref = self.db.collection(self.userEmail).addDocument(data: [
                "title": title,
                "text": text
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                }
            }
        self.dismiss(animated: true) {}

        
    }
    
    
    @IBAction func btnTrashTap(_ sender: Any) {
        SVProgressHUD.setDefaultStyle(.dark)
        createCustomBlur()
        SVProgressHUD.show()
        self.dismiss(animated: true) {
        }
    }
    
    func createCustomBlur(){
        let blurEffect = UIBlurEffect(style: .regular) // .extraLight or .dark
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        view.addSubview(blurEffectView)
    }
    
    

}

