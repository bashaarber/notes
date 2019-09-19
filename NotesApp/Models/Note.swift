//
//  Note.swift
//  NotesApp
//
//  Created by Arber Basha on 19/09/2019.
//  Copyright © 2019 Arber Basha. All rights reserved.
//

import UIKit

class Note: NSObject {
    
    var ID: String = ""
    var title: String = ""
    var text: String = ""
    
    init(ID: String, title: String, text: String) {
        self.ID = ID
        self.title = title
        self.text = text
    }
    
}


