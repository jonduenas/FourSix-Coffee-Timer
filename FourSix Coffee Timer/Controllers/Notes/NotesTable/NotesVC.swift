//
//  NotesVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/17/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class NotesVC: UIViewController, Storyboarded {
    @IBOutlet weak var tableView: UITableView!

    weak var coordinator: NotesCoordinator?
    var dataSource: UITableViewDiffableDataSource<Int, Note>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Resets shadow image so default border is shown
        navigationController?.navigationBar.shadowImage = nil
        
        configureDataSource()
        configureSnapshots()
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, note) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NoteCell.self), for: indexPath) as! NoteCell
            
            cell.headerLabel.text = note.noteText
            cell.subheaderLabel.text = note.date
            
            return cell
        })
        
        tableView.dataSource = dataSource
    }
    
    private func configureSnapshots() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Note>()
        
        snapshot.appendSections([0])
        snapshot.appendItems([Note(id: 1, date: "3/15/2021 - 1:15 PM", rating: 5, noteText: "Sweet & Light"),
                              Note(id: 2, date: "3/16/2021 - 11:15 PM", rating: 3, noteText: "Bright & Neutral")
        ])
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
