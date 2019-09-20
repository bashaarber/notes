//
//  NotesListViewController.swift
//  NotesApp
//
//  Created by Arber Basha on 17/09/2019.
//  Copyright © 2019 Arber Basha. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD
import Motion

class NotesListViewController: UIViewController , UICollectionViewDataSource , UICollectionViewDelegate {


    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var txtNotesList: UILabel!
    @IBOutlet weak var btnDarkMode: UIButton!
    
    var logedUser: User!
    var notesArray: [Note] = []
    var blurEffectView: UIView!
    var darkMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewSetUp()
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.show()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let savedMode = UserDefaults.standard.bool(forKey: "darkMode")
        if savedMode == true {
        darkMode = savedMode
        UITextField.appearance().keyboardAppearance = .dark
        self.txtNotesList.textColor = UIColor.white
        view.backgroundColor = UIColor.black
        self.btnDarkMode.tintColor = UIColor.white
        self.collectionView.backgroundColor = UIColor.black
        }
        notesArray = []
        createCustomBlur()
        getCurrentUser()
        readData()
    }
   
    @IBAction func btnLogOutTap(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popViewController(animated: true)
            UserDefaults.standard.set(false, forKey: "darkMode")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func collectionViewSetUp(){
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func readData(){
        let db = Firestore.firestore()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            db.collection(self.logedUser.email!).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let documentID = document.documentID
                        let title = document.data()["title"] as! String
                        let text = document.data()["text"] as! String
                        self.notesArray.append(Note(ID: documentID, title: title, text: text))
                    }
                    self.collectionView.reloadData()
                    self.blurEffectView.removeFromSuperview()
                    SVProgressHUD.dismiss()
                }
            }
        }
        
    }
    
    @IBAction func btnCreateNotesTap(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "createNotesVC") as! CreateNoteViewController
        vc.userEmail = logedUser.email
        vc.darkMode = darkMode
        self.present(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notesArray.count
    }
    

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotesCollectionViewCell", for: indexPath) as! NotesCollectionViewCell
        if darkMode == true {
            cell.layer.borderColor = UIColor.white.cgColor
            cell.txtTitle.textColor = UIColor.white
            cell.textView.textColor = UIColor.white
        }else{
            cell.layer.borderColor = UIColor.black.cgColor
            cell.txtTitle.textColor = UIColor.black
            cell.textView.textColor = UIColor.black
        }
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        cell.isUserInteractionEnabled = true

        let note = notesArray[indexPath.row]
        
        cell.txtTitle.text = note.title
        cell.textView.text = note.text
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let note = notesArray[indexPath.row]
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "updateVC") as! UpdateViewController
        vc.noteDocumentID = note.ID
        vc.noteTitle = note.title
        vc.noteText = note.text
        vc.userEmail = logedUser.email
        vc.darkMode = darkMode
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getCurrentUser(){
        let user = Auth.auth().currentUser
        if let usr = user {
            self.logedUser = usr
        }
    }
    func createCustomBlur(){
        let blurEffect = UIBlurEffect(style: .regular) // .extraLight or .dark
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        view.addSubview(blurEffectView)
    }
    
    
    @IBAction func btnDarkModeTap(_ sender: Any) {
        if darkMode == false{
            darkMode = true
            UserDefaults.standard.set(true, forKey: "darkMode")
            UITextField.appearance().keyboardAppearance = .dark
            self.txtNotesList.textColor = UIColor.white
            view.backgroundColor = UIColor.black
            self.btnDarkMode.tintColor = UIColor.white
            self.collectionView.backgroundColor = UIColor.black
            self.viewDidLoad()
            self.viewWillAppear(true)
        }else{
            darkMode = false
            UserDefaults.standard.set(false, forKey: "darkMode")
            UITextField.appearance().keyboardAppearance = .light
            self.txtNotesList.textColor = UIColor.black
            view.backgroundColor = UIColor.white
            self.btnDarkMode.tintColor = UIColor.black
            self.collectionView.backgroundColor = UIColor.white
            self.viewDidLoad()
            self.viewWillAppear(true)
        }

    }

}


