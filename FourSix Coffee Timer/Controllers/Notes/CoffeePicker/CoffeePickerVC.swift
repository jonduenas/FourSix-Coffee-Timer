//
//  CoffeePickerVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 4/7/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit
import CoreData

class CoffeePickerVC: UIViewController, Storyboarded {

    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifier = "CoffeeCell"
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Coffee", style: .plain, target: self, action: #selector(createNewCoffee))
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
}

extension CoffeePickerVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected row: \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: true)
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
        
        // Only animate if there are already cells in the table and the view itself is visible
        let shouldAnimate = tableView.numberOfSections != 0 && isVisible
        dataSource.apply(snapshot as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>, animatingDifferences: shouldAnimate)
    }
}
