//
//  NotesVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/17/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit
import CoreData

class NotesVC: UIViewController, Storyboarded {
    @IBOutlet weak var tableView: UITableView!

    var dataManager: DataManager!
    weak var coordinator: NotesCoordinator?
    var dataSource: UITableViewDiffableDataSource<Int, NSManagedObjectID>!
    var fetchedResultsController: NSFetchedResultsController<NoteMO>! = nil
    var isVisible: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard dataManager != nil else { fatalError("Controller requires DataManager.") }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Note", style: .plain, target: self, action: #selector(createNewNote))
        
        tableView.delegate = self
        configureDataSource()
        configureFetchedResultsController()
        fetchNotes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hideBarShadow(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isVisible = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isVisible = false
    }
    
    private func configureDataSource() {
        let dataSource = UITableViewDiffableDataSource<Int, NSManagedObjectID>(tableView: tableView, cellProvider: { (tableView, indexPath, noteID) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NoteCell.self), for: indexPath) as! NoteCell
            
            guard let note = try? self.dataManager.mainContext.existingObject(with: noteID) as? NoteMO else { fatalError("Managed object should be available") }
            
            guard let balance = Balance(rawValue: Float(note.recipe.balanceRaw)) else { return cell }
            guard let strength = Strength(rawValue: Int(note.recipe.strengthRaw)) else { return cell }

            cell.headerLabel.text = String(describing: balance).capitalized + " & " + String(describing: strength).capitalized
            cell.subheaderLabel.text = note.date.stringFromDate(dateStyle: .short)
            
            return cell
        })
        
        self.dataSource = dataSource
        tableView.dataSource = dataSource
    }
    
    @objc func createNewNote() {
        let backgroundMOC = self.dataManager.backgroundContext
        
        backgroundMOC.perform {
            let note = NoteMO(context: backgroundMOC)
            
            let recipe = RecipeMO(context: backgroundMOC)
            recipe.balanceRaw = Double(Balance.bright.rawValue)
            recipe.strengthRaw = Int64(Strength.strong.rawValue)
            recipe.interval = 30
            recipe.coffee = 25
            recipe.waterTotal = 375
            recipe.waterPours = [50, 70, 60, 60, 60]
            note.recipe = recipe
            
            let session = SessionMO(context: backgroundMOC)
            session.averageDrawdown = 45
            session.totalTime = 360
            note.session = session
            
            let coffee = CoffeeMO(context: backgroundMOC)
            coffee.id = UUID()
            coffee.name = ""
            coffee.origin = ""
            coffee.roastLevel = ""
            coffee.roaster = "Coava"
            note.coffee = coffee
            
            note.date = Date()
            note.grindSetting = ""
            note.rating = 1
            note.roastDate = nil
            note.text = ""
            note.waterTempC = 0
            
            self.dataManager.save(note)
        }
    }
}

extension NotesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let noteID = dataSource.itemIdentifier(for: indexPath) else { return }
        
        coordinator?.showDetails(for: noteID, dataManager: dataManager)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NotesVC: NSFetchedResultsControllerDelegate {
    private func configureFetchedResultsController() {
        let request = NoteMO.createFetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(NoteMO.date), ascending: false)
        request.sortDescriptors = [sort]
        
        request.fetchBatchSize = 15
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: dataManager.mainContext, sectionNameKeyPath: nil, cacheName: "notesCache")
        fetchedResultsController.delegate = self
    }
    
    private func fetchNotes() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error performing fetch - \(error.localizedDescription)")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        guard let dataSource = tableView.dataSource as? UITableViewDiffableDataSource<Int, NSManagedObjectID> else {
            assertionFailure("The data source has not implemented snapshot support while it should")
            return
        }
        
        var snapshot = snapshot as NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>
        let currentSnapshot = dataSource.snapshot() as NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>

        // NSManagedObjectID doesn't change and isn't seen as needing updated. Instead, compare index between snapshots.
        let reloadIdentifiers: [NSManagedObjectID] = snapshot.itemIdentifiers.compactMap { itemIdentifier in
            // If the index of the NSManagedObjectID in the currentSnapshot is the same as the new snapshot, skip reloading
            guard let currentIndex = currentSnapshot.indexOfItem(itemIdentifier), let index = snapshot.indexOfItem(itemIdentifier), index == currentIndex else {
                return nil
            }
            // If the existing object doesn't have any updates, skip reloading
            guard let existingObject = try? controller.managedObjectContext.existingObject(with: itemIdentifier), existingObject.isUpdated else { return nil }
            
            return itemIdentifier
        }
        snapshot.reloadItems(reloadIdentifiers)
        
        // Only animate if there are already cells in the table and the view itself is visible
        let shouldAnimate = tableView.numberOfSections != 0 && isVisible
        dataSource.apply(snapshot as NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>, animatingDifferences: shouldAnimate)
    }
}
