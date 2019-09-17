//
//  MainViewController.swift
//  NotesApp
//
//  Created by Arber Basha on 17/09/2019.
//  Copyright © 2019 Arber Basha. All rights reserved.
//

import UIKit

class MainViewController: UIViewController , UITextFieldDelegate {
    
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
        return true
    }
     
    @IBAction func btnLoginTap(_ sender: Any) {

    }

    @IBAction func btnSingUpTap(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "singupCV") as! SingUpViewController
        self.present(vc, animated: true, completion: nil)
    }
    
}
