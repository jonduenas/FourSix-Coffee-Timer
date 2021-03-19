//
//  NoteDetailsVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/17/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class NoteDetailsVC: UIViewController, Storyboarded {
    weak var coordinator: NotesCoordinator?
    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(note?.date)
    }
}
