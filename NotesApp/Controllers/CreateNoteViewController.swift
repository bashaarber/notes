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

class CreateNoteViewController: UIViewController , UITextViewDelegate , UITextFieldDelegate {

    @IBOutlet weak var txtViewText: UITextView!
    @IBOutlet weak var txtTitle: UITextField!
    
    var userEmail: String!
    let db = Firestore.firestore()
    var blurEffectView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTexts()
        
        
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
        SVProgressHUD.show()
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
                    self.dismiss(animated: true) {}
                }
            }

        
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
