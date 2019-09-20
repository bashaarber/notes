//
//  NotesNavigationController.swift
//  NotesApp
//
//  Created by Arber Basha on 20/09/2019.
//  Copyright © 2019 Arber Basha. All rights reserved.
//

import UIKit
import Motion

class NotesNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        isMotionEnabled = true
        motionNavigationTransitionType = .zoom
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
