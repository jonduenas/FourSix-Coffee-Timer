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
    var dataSource: DataSource!
    var fetchedResultsController: NSFetchedResultsController<NoteMO>! = nil
    var isVisible: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        guard dataManager != nil else { fatalError("Controller requires DataManager.") }

        tableView.delegate = self
        configureDataSource()
        configureFetchedResultsController()
        fetchNotes()
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
        let dataSource = DataSource(
            tableView: tableView,
            cellProvider: { [weak self] (tableView, indexPath, noteID) -> UITableViewCell? in
                guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: String(describing: NoteCell.self),
                        for: indexPath) as? NoteCell else { return nil }

                guard let note = try? self?.dataManager.mainContext.existingObject(with: noteID) as? NoteMO else {
                    fatalError("Managed object should be available")
                }

                guard let balance = Balance(rawValue: Float(note.recipe.balanceRaw)) else { return cell }
                guard let strength = Strength(rawValue: Int(note.recipe.strengthRaw)) else { return cell }

                cell.monthLabel.text = note.date.stringFromDate(component: .month)
                cell.dayLabel.text = note.date.stringFromDate(component: .day)
                cell.recipeLabel.text = String(describing: balance).capitalized + " & " + String(describing: strength).capitalized
                cell.coffeeLabel.text = note.recipe.coffee.clean + "g"
                cell.waterLabel.text = note.recipe.waterTotal.clean + "g"
                cell.ratingStackView.rating = Int(note.rating)

                return cell
            })

        self.dataSource = dataSource
        tableView.dataSource = dataSource
    }

    private func deleteNote(at indexPath: IndexPath) {
        if let objectID = dataSource.itemIdentifier(for: indexPath) {
            var snapshot = dataSource.snapshot()
            snapshot.deleteItems([objectID])
            dataSource.apply(snapshot) {
                self.dataManager.delete(objectID)
            }
        }
    }
}

extension NotesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let noteID = dataSource.itemIdentifier(for: indexPath) else { return }
        guard let noteObject = try? dataManager.mainContext.existingObject(with: noteID) as? NoteMO else {
            fatalError("Note with noteID not found.")
        }

        coordinator?.showDetails(for: noteObject, dataManager: dataManager)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: Swipe to delete

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, _, _) in
            guard let self = self else { return }
            AlertHelper.showDestructiveAlert(title: "Deleting Note",
                                             message: "Are you sure you want to delete this note? You can't undo it.",
                                             destructiveButtonTitle: "Delete",
                                             dismissButtonTitle: "Cancel",
                                             on: self) { action in
                guard action.style == .destructive else { return }
                self.deleteNote(at: indexPath)
            }
        }

        let configuration = UISwipeActionsConfiguration(actions: [delete])

        // Disable delete for full swipe
        configuration.performsFirstActionWithFullSwipe = false

        return configuration
    }
}

extension NotesVC: NSFetchedResultsControllerDelegate {
    private func configureFetchedResultsController() {
        let request = NoteMO.createFetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(NoteMO.date), ascending: false)
        request.sortDescriptors = [sort]

        request.fetchBatchSize = 15

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: dataManager.mainContext,
            sectionNameKeyPath: nil,
            cacheName: "notesCache"
        )
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
        guard let dataSource = tableView.dataSource as? DataSource else {
            assertionFailure("The data source has not implemented snapshot support while it should")
            return
        }

        var snapshot = snapshot as NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>
        let currentSnapshot = dataSource.snapshot() as NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>

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

        // Only animate if there are already cells in the table and the view itself is visible
        let shouldAnimate = tableView.numberOfSections != 0 && isVisible
        dataSource.apply(snapshot as NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>, animatingDifferences: shouldAnimate)
    }
}
