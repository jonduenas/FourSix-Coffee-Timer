//
//  NoteDetailsVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/17/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit
import CoreData

class NoteDetailsVC: UIViewController, Storyboarded {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var longTapHint: UILabel!
    
    // Session
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var drawdownLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    // Recipe
    @IBOutlet weak var flavorProfileLabel: UILabel!
    @IBOutlet weak var coffeeAmountLabel: UILabel!
    @IBOutlet weak var waterAmountLabel: UILabel!
    @IBOutlet weak var poursLabel: UILabel!
    @IBOutlet weak var pourIntervalLabel: UILabel!
    @IBOutlet weak var grindSettingTextField: UITextField!
    @IBOutlet weak var waterTempTextField: UITextField!
    @IBOutlet weak var waterTempUnitControl: UISegmentedControl!
    
    // Coffee Details
    @IBOutlet weak var coffeePickerView: CoffeePickerView!
    @IBOutlet weak var datePickerView: DatePickerView!
    
    // Notes
    @IBOutlet weak var notesTextView: NotesTextView!
    
    var dataManager: DataManager!
    weak var coordinator: NoteDetailsCoordinator?
    var note: NoteMO?
    var isNewNote: Bool = false
    var hintIsAnimating: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerKeyboardNotifications()
        registerMOCChangeNotification()
        ratingControl.delegate = self
        datePickerView.delegate = self
        configureNavController()
        configureCoffeePickerView()
        configureView()
    }
    
    private func configureNavController() {
        navigationItem.largeTitleDisplayMode = .never
        
        if isNewNote {
            title = "New Note"
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bell"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(didTapRemindButton))
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                                               style: .done, target: self,
                                                               action: #selector(didTapCloseButton))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapTrashButton))
        }
    }
    
    @objc private func didTapRemindButton() {
        AlertHelper.showCancellableAlert(title: "Set Reminder",
                                         message: "Judging the flavor of your coffee is best after it's cooled a little. Would you like a reminder in 5 minutes to come back and rate this cup?",
                                         confirmButtonTitle: "Remind me",
                                         dismissButtonTitle: "Cancel",
                                         on: self,
                                         cancelHandler: nil) { _ in
            print("Set reminder")
            // TODO: Add local push notification for reminding user to update note
        }
    }
    
    @objc private func didTapCloseButton() {
        dismiss(animated: true) {
            self.coordinator?.didFinishDetails()
            AppStoreReviewManager.requestReviewIfAppropriate()
        }
    }
    
    @objc private func didTapTrashButton() {
        showDeleteAlert()
    }
    
    private func configureCoffeePickerView() {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(didTapCoffeeView))
        coffeePickerView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: Update UI with Note
    
    private func configureView() {
        guard let note = note else { fatalError("Note is nil.") }
        
        self.initializeTempUnitSelector()
        self.updateLabels()
        self.ratingControl.rating = Int(note.rating)
    }
    
    private func initializeTempUnitSelector() {
        waterTempUnitControl.selectedSegmentIndex = Int(note?.tempUnitRawValue ?? 0)
    }
    
    private func updateLabels() {
        // Session
        dateLabel.text = note?.date.stringFromDate(dateStyle: .short, timeStyle: .short)
        drawdownLabel.text = note?.session.averageDrawdown.minAndSecString
        totalTimeLabel.text = note?.session.totalTime.minAndSecString
        
        // Recipe
        flavorProfileLabel.text = flavorProfileText(from: note?.recipe)
        coffeeAmountLabel.text = (note?.recipe.coffee.clean ?? "0") + "g"
        waterAmountLabel.text = (note?.recipe.waterTotal.clean ?? "0") + "g"
        poursLabel.text = poursLabelText(from: note?.recipe)
        pourIntervalLabel.text = note?.recipe.interval.minAndSecString
        grindSettingTextField.text = note?.grindSetting
        waterTempTextField.text = setWaterTempTextField(with: note?.waterTempC)
        
        // Coffee Details
        coffeePickerView.coffee = note?.coffee
        datePickerView.isHidden = note?.coffee == nil
        if let roastDate = note?.roastDate {
            datePickerView.setDate(roastDate)
        } else if let previousRoastDate = note?.coffee?.previousRoastDate {
            datePickerView.setDate(previousRoastDate)
        }
        
        // Notes
        notesTextView.text = note?.text
    }
    
    private func setWaterTempTextField(with cValue: Double?) -> String {
        guard let cValue = cValue, cValue != 0 else { return "" }
        
        switch waterTempUnitControl.selectedSegmentIndex {
        case TempUnit.celsius.rawValue:
            return cValue.clean
        case TempUnit.fahrenheit.rawValue:
            return convertTemp(value: cValue, from: .celsius, to: .fahrenheit).clean
        default:
            fatalError("There should never be more than 2 options.")
        }
    }
    
    private func flavorProfileText(from recipe: RecipeMO?) -> String {
        guard let balance = Balance(rawValue: Float(recipe!.balanceRaw)) else { return "" }
        guard let strength = Strength(rawValue: Int(recipe!.strengthRaw)) else { return "" }
        
        let balanceString = String(describing: balance).capitalized
        let strengthString = String(describing: strength).capitalized
        
        return balanceString + " & " + strengthString
    }
    
    private func poursLabelText(from recipe: RecipeMO?) -> String {
        guard let recipePours = recipe?.waterPours else { return "" }
        let recipePoursStrings = recipePours.map { $0.clean + "g" }
        
        return recipePoursStrings.joined(separator: " → ")
    }
    
    // MARK: Coffee Picker
    
    @objc private func didTapCoffeeView() {
        guard let note = note else { return }
        
        coordinator?.showCoffeePicker(currentPicked: note.coffee, dataManager: dataManager, delegate: self)
    }
    
    // MARK: Temperature Unit Control
    
    @IBAction func didChangeTempUnit(_ sender: UISegmentedControl) {
        guard let selectedUnit = TempUnit(rawValue: sender.selectedSegmentIndex) else { return }
        
        note?.tempUnitRawValue = Int64(selectedUnit.rawValue)
    }
    
    private func convertTemp(value: Double, from inUnit: UnitTemperature, to outUnit: UnitTemperature) -> Double {
        let temperature = Measurement(value: value, unit: inUnit)
        return temperature.converted(to: outUnit).value
    }
    
    private func getCelsiusTemp() -> Double {
        guard let value = Double(waterTempTextField.text!), let selectedUnit = TempUnit(rawValue: waterTempUnitControl.selectedSegmentIndex) else { return 0 }
        
        switch selectedUnit {
        case .celsius:
            return value
        case .fahrenheit:
            return convertTemp(value: value, from: .fahrenheit, to: .celsius)
        }
    }
    
    // MARK: Update Note Managed Object
    
    private func getBackgroundNote() -> NoteMO? {
        guard let objectID = note?.objectID else { return nil }
        
        var backgroundNote: NoteMO?
        dataManager.backgroundContext.performAndWait {
            backgroundNote = self.dataManager.backgroundContext.object(with: objectID) as? NoteMO
        }
        
        return backgroundNote
    }
    
    private func updateNote(with textField: UITextField) {
        let text = textField.text ?? ""
        let temp = getCelsiusTemp()
        
        guard let backgroundNote = getBackgroundNote() else { return }
        
        backgroundNote.managedObjectContext?.perform {
            switch textField {
            case self.grindSettingTextField:
                backgroundNote.grindSetting = text
            case self.waterTempTextField:
                backgroundNote.waterTempC = temp
            default:
                print("Not a valid text field")
                return
            }
            
            self.dataManager.save(backgroundNote)
        }
    }
    
    private func updateNote(with textView: UITextView) {
        guard textView == notesTextView else { return }
        let text = textView.text ?? ""
        guard let backgroundNote = getBackgroundNote() else { return }
        
        backgroundNote.managedObjectContext?.perform {
            backgroundNote.text = text
            self.dataManager.save(backgroundNote)
        }
    }
    
    private func updateNote(with rating: Int) {
        guard let note = note, note.rating != rating else { return }
        guard let backgroundNote = getBackgroundNote() else { return }
        backgroundNote.managedObjectContext?.perform {
            backgroundNote.rating = Int64(rating)
            self.dataManager.save(backgroundNote)
        }
    }
    
    // MARK: Delete Note
    
    private func showDeleteAlert() {
        AlertHelper.showDestructiveAlert(title: "Deleting Note",
                                          message: "Are you sure you want to delete this note? You can't undo it.",
                                          destructiveButtonTitle: "Delete",
                                          dismissButtonTitle: "Cancel",
                                          on: self) { action in
            guard action.style == .destructive else { return }
            self.deleteNote()
        }
    }
    
    private func deleteNote() {
        guard let note = note else { return }
        dataManager.delete(note)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Adjust scrollView for keyboard

extension NoteDetailsVC {
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0,
                                                   left: 0,
                                                   bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom - (tabBarController?.tabBar.frame.height ?? 0) + 10,
                                                   right: 0)
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
        
        if notesTextView.isFirstResponder {
            scrollView.scrollRectToVisible(notesTextView.frame, animated: true)
        }
    }
}

// MARK: - Update CoffeePickerView
// Updates CoffeePickerView labels when CoffeeMO object is edited and it's the currently selected and displayed coffee

extension NoteDetailsVC {
    private func registerMOCChangeNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidChange(notification:)), name: .NSManagedObjectContextObjectsDidChange, object: dataManager.mainContext)
    }
    
    @objc func contextDidChange(notification: Notification) {
        guard let updatedObjects = notification.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject> else { return }
        guard let coffee = note?.coffee else { return }
        
        if updatedObjects.contains(coffee) {
            coffeePickerView.updateCoffeeLabels()
        }
    }
}

// MARK: - UITextField and UITextView delegate methods

extension NoteDetailsVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateNote(with: textField)
    }
}

extension NoteDetailsVC: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        updateNote(with: textView)
    }
}

// MARK: - RatingControlDelegate methods

extension NoteDetailsVC: RatingControlDelegate {
    func ratingControlShouldShowHint(ratingControl: RatingControl) {
        guard longTapHint.alpha == 0, !hintIsAnimating else { return }
        
        hintIsAnimating = true
        
        UIView.animate(withDuration: 0.75, delay: 0) {
            self.longTapHint.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 0.75, delay: 5) {
                self.longTapHint.alpha = 0
            } completion: { _ in
                self.hintIsAnimating = false
            }
        }
    }
    
    func ratingControl(ratingControl: RatingControl, didChangeRating rating: Int) {
        updateNote(with: rating)
    }
}

// MARK: - CoffeePickerDelegate methods

extension NoteDetailsVC: CoffeePickerDelegate {
    func didPickCoffee(_ coffee: CoffeeMO?) {
        note?.coffee = coffee
        dataManager.saveContext()
        coffeePickerView.coffee = coffee
        datePickerView.setDate(coffee?.previousRoastDate ?? Date())
        
        if coffee == nil {
            // If the user deletes the currently picked coffee without picking another new one
            datePickerView.isHidden = true
            note?.roastDate = nil
        } else {
            // Makes sure the datePickerView is visible when a coffee is selected
            datePickerView.isHidden = false
        }
    }
}

// MARK: - DatePickerViewDelegate methods

extension NoteDetailsVC: DatePickerViewDelegate {
    func didChangePickerVisibility(_ datePickerView: DatePickerView) {
        view.layoutIfNeeded()
    }
    
    func datePickerView(_ datePickerView: DatePickerView, didChangeToDate date: Date?) {
        guard note?.coffee != nil, note?.roastDate != date else { return }
        note?.roastDate = date
        note?.coffee?.previousRoastDate = date
        dataManager.saveContext()
    }
}
