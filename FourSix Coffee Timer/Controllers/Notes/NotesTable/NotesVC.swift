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
        
        tableView.delegate = self
        configureDataSource()
        configureSnapshots()
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, note) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NoteCell.self), for: indexPath) as! NoteCell
            
            let recipeBalance = "\(note.recipe.balance)"
            let recipeStrength = "\(note.recipe.strength)"
            
            cell.headerLabel.text = "\(recipeBalance.capitalized) & \(recipeStrength.capitalized)"
            cell.subheaderLabel.text = note.date.stringFromDate(dateStyle: .short)
            
            return cell
        })
        
        tableView.dataSource = dataSource
    }
    
    private func configureSnapshots() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Note>()
        
        snapshot.appendSections([0])
        snapshot.appendItems([Note.testNote1, Note.testNote2])
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension NotesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let note = dataSource.itemIdentifier(for: indexPath) else { return }
        coordinator?.showDetails(for: note)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
