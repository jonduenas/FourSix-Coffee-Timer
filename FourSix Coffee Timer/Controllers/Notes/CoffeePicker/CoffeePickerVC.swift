//
//  CoffeePickerVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 4/7/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit
import CoreData

protocol CoffeePickerDelegate: AnyObject {
    func didPickCoffee(_ coffee: CoffeeMO?)
}

class CoffeePickerVC: UIViewController, Storyboarded {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addNewButton: UIButton!

    let cellIdentifier = "CoffeeCell"

    weak var delegate: CoffeePickerDelegate?
    var currentPicked: CoffeeMO?
    var dataManager: DataManager!
    weak var coordinator: NoteDetailsCoordinator?
    var dataSource: CoffeeDataSource! = nil
    var fetchedResultsController: NSFetchedResultsController<CoffeeMO>! = nil
    var isVisible: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        configureDataSource()
        configureFetchedResultsController()
        fetchCoffees()

        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.largeTitleDisplayMode = .never
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
        let dataSource = CoffeeDataSource(
            tableView: tableView,
            cellProvider: { [weak self] (tableView, indexPath, noteID) -> UITableViewCell? in
                guard let self = self else { return nil }

                let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)

                guard let coffee = try? self.dataManager.mainContext.existingObject(with: noteID) as? CoffeeMO else {
                    fatalError("Managed object should be available")
                }

                cell.textLabel?.text = coffee.name

                if coffee == self.currentPicked {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }

                // Sets custom color for background when cell is selected
                let backgroundView = UIView()
                backgroundView.backgroundColor = UIColor(named: AssetsColor.separator.rawValue)
                cell.selectedBackgroundView = backgroundView

                return cell
            })

        self.dataSource = dataSource
        tableView.dataSource = dataSource
    }

    @IBAction func didTapAddNewButton(_ sender: UIButton) {
        coordinator?.showCoffeeEditor(coffee: nil, dataManager: dataManager)
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
        guard let coffeeObject = try? dataManager.mainContext.existingObject(with: objectID) as? CoffeeMO else {
            fatalError("Object should exist")
        }

        if isEditing {
            coordinator?.showCoffeeEditor(coffee: coffeeObject, dataManager: dataManager)
        } else {
            currentPicked = coffeeObject
            delegate?.didPickCoffee(coffeeObject)
            coordinator?.didFinishCoffeePicker()
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, _) in
            guard let self = self else { return }
            AlertHelper.showDestructiveAlert(title: "Delete Coffee?",
                                             // swiftlint:disable:next line_length
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

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: dataManager.mainContext,
            sectionNameKeyPath: #keyPath(CoffeeMO.roaster),
            cacheName: "coffeeCache")
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
            guard let currentIndex = currentSnapshot.indexOfItem(itemIdentifier),
                  let index = snapshot.indexOfItem(itemIdentifier),
                  index == currentIndex
            else {
                return nil
            }

            // If the existing object doesn't have any updates, skip reloading
            guard let existingObject = try? controller.managedObjectContext.existingObject(with: itemIdentifier),
                  existingObject.isUpdated
            else {
                return nil
            }

            return itemIdentifier
        }
        snapshot.reloadItems(reloadIdentifiers)

        // Not animating difference ensures editing stored Coffee name is updated after changing
        dataSource.apply(snapshot as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>, animatingDifferences: false)
    }
}
