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

    let coreDataStack = CoreDataStack()
    weak var coordinator: NotesCoordinator?
    var dataSource: UITableViewDiffableDataSource<Int, NSManagedObjectID>!
    var fetchedResultsController: NSFetchedResultsController<NoteMO>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Resets shadow image so default border is shown
        navigationController?.navigationBar.shadowImage = nil
        
        //createNewNote()
        
        tableView.delegate = self
        configureDataSource()
        configureFetchedResultsController()
        fetchNotes()
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, noteID) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NoteCell.self), for: indexPath) as! NoteCell
            
            let note = self.coreDataStack.mainContext.object(with: noteID) as! NoteMO
            
            let balance = Balance(rawValue: Float(note.recipe.balanceRaw))
            let strength = Strength(rawValue: Int(note.recipe.strengthRaw))

            cell.headerLabel.text = String(describing: balance).capitalized + " & " + String(describing: strength).capitalized
            cell.subheaderLabel.text = note.date.stringFromDate(dateStyle: .short)
            
            return cell
        })
        
        tableView.dataSource = dataSource
    }
    
//    private func configureSnapshots() {
//        var snapshot = NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>()
//
//
//
//        snapshot.appendSections([0])
//        snapshot.appendItems([note])
//
//        dataSource.apply(snapshot, animatingDifferences: false)
//    }
    
    func createNewNote() {
        let note = NoteMO(context: coreDataStack.mainContext)
        
        let recipe = RecipeMO(context: coreDataStack.mainContext)
        recipe.balanceRaw = Double(Balance.bright.rawValue)
        recipe.strengthRaw = Int64(Strength.strong.rawValue)
        recipe.interval = 30
        recipe.coffee = 25
        let waterTotal = WaterMO(context: coreDataStack.mainContext)
        waterTotal.amount = 375
        recipe.waterTotal = waterTotal
        let waterPour = WaterMO(context: coreDataStack.mainContext)
        waterPour.amount = 65
        let waterArray = Array(repeating: waterPour, count: 6)
        waterArray.forEach { recipe.addToWaterPours($0) }
        note.recipe = recipe
        
        let session = SessionMO(context: coreDataStack.mainContext)
        session.averageDrawdown = 45
        session.totalTime = 360
        note.session = session
        
        let coffee = CoffeeMO(context: coreDataStack.mainContext)
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
        note.waterTemp = 0
        
        coreDataStack.saveContext()
    }
}

extension NotesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let noteID = dataSource.itemIdentifier(for: indexPath) else { return }
        
        coordinator?.showDetails(for: noteID)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NotesVC: NSFetchedResultsControllerDelegate {
    private func configureFetchedResultsController() {
        let request: NSFetchRequest<NoteMO> = NoteMO.fetchRequest()
        
        request.sortDescriptors = []
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreDataStack.mainContext, sectionNameKeyPath: nil, cacheName: nil)
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
        
        let reloadIdentifiers: [NSManagedObjectID] = snapshot.itemIdentifiers.compactMap { itemIdentifier in
            guard let currentIndex = currentSnapshot.indexOfItem(itemIdentifier), let index = snapshot.indexOfItem(itemIdentifier), index == currentIndex else {
                return nil
            }
            guard let existingObject = try? controller.managedObjectContext.existingObject(with: itemIdentifier), existingObject.isUpdated else { return nil }
            return itemIdentifier
        }
        snapshot.reloadItems(reloadIdentifiers)
        
        let shouldAnimate = tableView.numberOfSections != 0
        dataSource.apply(snapshot as NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>, animatingDifferences: shouldAnimate)
    }
}
