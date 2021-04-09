//
//  CoffeePickerVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 4/7/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit
import CoreData

protocol CoffeePickerDelegate: class {
    func didPickCoffee(_ coffee: CoffeeMO?)
}

class CoffeePickerVC: UIViewController, Storyboarded {

    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifier = "CoffeeCell"
    
    weak var delegate: CoffeePickerDelegate?
    var currentPicked: CoffeeMO?
    var dataManager: DataManager!
    weak var notesCoordinator: NotesCoordinator?
    weak var brewCoordinator: BrewCoordinator?
    var dataSource: CoffeeDataSource! = nil
    var fetchedResultsController: NSFetchedResultsController<CoffeeMO>! = nil
    var isVisible: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        configureDataSource()
        configureFetchedResultsController()
        fetchCoffees()
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Coffee", style: .plain, target: self, action: #selector(createNewCoffee))
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isVisible = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isVisible = false
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    private func configureDataSource() {
        let dataSource = CoffeeDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, noteID) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)

            guard let coffee = try? self.dataManager.mainContext.existingObject(with: noteID) as? CoffeeMO else { fatalError("Managed object should be available") }

            cell.textLabel?.text = coffee.name

            return cell
        })
        
        self.dataSource = dataSource
        tableView.dataSource = dataSource
    }
    
    @objc func createNewCoffee() {
        let coffee = Coffee(roaster: "Onyx", name: "Coffee Name", origin: "", roastLevel: "")
        let coffeeMO = dataManager.newCoffeeMO(from: coffee)
        try! dataManager.mainContext.obtainPermanentIDs(for: [coffeeMO])
        dataManager.saveContext()
    }
    
    private func deleteCoffee(at indexPath: IndexPath) {
        guard let objectID = dataSource.itemIdentifier(for: indexPath) else { return }
        guard let object = dataManager.mainContext.object(with: objectID) as? CoffeeMO else { return }
        
        if object == currentPicked {
            delegate?.didPickCoffee(nil)
        }
        
        dataManager.delete(objectID)
    }
}

extension CoffeePickerVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let objectID = dataSource.itemIdentifier(for: indexPath) else { return }
        guard let coffeeObject = try? dataManager.mainContext.existingObject(with: objectID) as? CoffeeMO else { fatalError("Object should exist") }
        
        if isEditing {
            notesCoordinator?.showCoffeeEditor(coffee: coffeeObject, dataManager: dataManager)
        } else {
            delegate?.didPickCoffee(coffeeObject)
            notesCoordinator?.didFinishCoffeePicker()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            AlertHelper.showDestructiveAlert(title: "Delete Coffee?",
                                             message: "Are you sure you want to delete this coffee? It will be removed from any notes and you won't be able to undo.",
                                             destructiveButtonTitle: "Delete",
                                             dismissButtonTitle: "Cancel",
                                             on: self) { _ in
                self.deleteCoffee(at: indexPath)
            }
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [delete])
        
        // Disable delete for full swipe
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
}

extension CoffeePickerVC: NSFetchedResultsControllerDelegate {
    private func configureFetchedResultsController() {
        let request = CoffeeMO.createFetchRequest()
        let sort1 = NSSortDescriptor(key: #keyPath(CoffeeMO.roaster), ascending: true)
        let sort2 = NSSortDescriptor(key: #keyPath(CoffeeMO.name), ascending: true)
        request.sortDescriptors = [sort1, sort2]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: dataManager.mainContext, sectionNameKeyPath: #keyPath(CoffeeMO.roaster), cacheName: "coffeeCache")
        fetchedResultsController.delegate = self
    }
    
    private func fetchCoffees() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error performing fetch - \(error.localizedDescription)")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        guard let dataSource = tableView.dataSource as? CoffeeDataSource else {
            assertionFailure("The data source has not implemented snapshot support while it should")
            return
        }
        
        var snapshot = snapshot as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
        let currentSnapshot = dataSource.snapshot() as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
        
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
        
        dataSource.apply(snapshot as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>, animatingDifferences: false)
    }
}
