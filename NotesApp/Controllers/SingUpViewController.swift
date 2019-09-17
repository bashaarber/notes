//
//  SingUpViewController.swift
//  NotesApp
//
//  Created by Arber Basha on 17/09/2019.
//  Copyright © 2019 Arber Basha. All rights reserved.
//

import UIKit

class SingUpViewController: UIViewController , UITextFieldDelegate {

    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.delegate = self
        txtPassword.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    

    @IBAction func btnCreateTap(_ sender: Any) {
    }
    
    @IBAction func btnCloseTap(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    
}
