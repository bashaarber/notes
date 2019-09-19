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

class UpdateViewController: UIViewController , UITextViewDelegate , UITextFieldDelegate{
    
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtViewText: UITextView!
    
    var noteDocumentID: String!
    var noteTitle: String!
    var noteText: String!
    var userEmail: String!
    let db = Firestore.firestore()
    var blurEffectView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTexts()
        txtTitle.text = noteTitle
        txtViewText.text = noteText
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
    

    @IBAction func btnUpdateTap(_ sender: Any) {
        SVProgressHUD.setDefaultStyle(.dark)
        createCustomBlur()
        SVProgressHUD.show()
        let title = txtTitle.text!
        let text = txtViewText.text!
        db.collection(userEmail).document(noteDocumentID).updateData([
            "title": title,
            "text": text
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func btnTrashTap(_ sender: Any) {
        SVProgressHUD.setDefaultStyle(.dark)
        createCustomBlur()
        SVProgressHUD.show()
        db.collection(userEmail).document(noteDocumentID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func createCustomBlur(){
        let blurEffect = UIBlurEffect(style: .regular) // .extraLight or .dark
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        view.addSubview(blurEffectView)
    }
    
}
