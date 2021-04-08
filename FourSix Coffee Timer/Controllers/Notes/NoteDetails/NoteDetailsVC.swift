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
    @IBOutlet weak var doubleTapHint: UILabel!
    
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
    @IBOutlet weak var coffeeView: RoundedView!
    @IBOutlet weak var coffeeDivider: UIView!
    @IBOutlet weak var coffeeNameLabel: UILabel!
    @IBOutlet weak var roasterLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var roastLevelLabel: UILabel!
    
    @IBOutlet weak var roastDateTextField: DateTextField!
    
    // Notes
    @IBOutlet weak var notesTextView: NotesTextView!
    
    @IBOutlet weak var deleteButton: RoundButton!
    
    var dataManager: DataManager!
    weak var notesCoordinator: NotesCoordinator?
    weak var brewCoordinator: BrewCoordinator?
    var note: NoteMO!
    var isNewNote: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerKeyboardNotifications()
        ratingControl.delegate = self
        configureNavController()
        configureCoffeeView()
        
        isEditing = isNewNote
        setUIEditMode()
        
        configureView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dataManager.saveContext(dataManager.backgroundContext)
    }
    
    private func configureNavController() {
        navigationController?.hideBarShadow(true)
        
        if isNewNote {
            title = "New Note"
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reminder",
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(didTapRemindButton))
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                                               style: .done, target: self,
                                                               action: #selector(didTapCloseButton))
        } else {
            navigationItem.rightBarButtonItem = editButtonItem
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
        dismiss(animated: true)
    }
    
    private func configureCoffeeView() {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(didTapCoffeeView))
        coffeeView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: Edit Mode
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        setUIEditMode()
    }
    
    private func setUIEditMode() {
        let borderStyle: UITextField.BorderStyle = isEditing ? .roundedRect : .none
        
        ratingControl.setToEditMode(isEditing)
        
        grindSettingTextField.isEnabled = isEditing
        grindSettingTextField.borderStyle = borderStyle
        
        waterTempTextField.isEnabled = isEditing
        waterTempTextField.borderStyle = borderStyle
        
        roastDateTextField.isEnabled = isEditing
        roastDateTextField.borderStyle = borderStyle
        
        notesTextView.setToEditMode(isEditing)
        
        // Delete button is hidden if not editing OR if it's a new note
        deleteButton.isHidden = !isEditing || isNewNote
    }
    
    // MARK: Adjust scrollView for keyboard
    
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
    
    // MARK: Update UI with Note
    
    private func configureView() {
        guard note != nil else { fatalError("Note is nil.") }
        
        note.managedObjectContext?.perform {
            self.initializeTempUnitSelector()
            self.updateLabels()
            self.initializeDatePicker()
            self.ratingControl.rating = Int(self.note.rating)
        }
    }
    
    private func initializeDatePicker() {
        if let roastDate = note.roastDate {
            roastDateTextField.datePicker.setDate(roastDate, animated: false)
        }
    }
    
    private func initializeTempUnitSelector() {
        waterTempUnitControl.selectedSegmentIndex = Int(note.tempUnitRawValue)
    }
    
    private func updateLabels() {
        // Session
        dateLabel.text = note.date.stringFromDate(dateStyle: .short, timeStyle: .short)
        drawdownLabel.text = note.session.averageDrawdown.minAndSecString
        totalTimeLabel.text = note.session.totalTime.minAndSecString
        
        // Recipe
        flavorProfileLabel.text = flavorProfileText(from: note.recipe)
        coffeeAmountLabel.text = note.recipe.coffee.clean + "g"
        waterAmountLabel.text = note.recipe.waterTotal.clean + "g"
        poursLabel.text = poursLabelText(from: note.recipe)
        pourIntervalLabel.text = note.recipe.interval.minAndSecString
        grindSettingTextField.text = note.grindSetting
        waterTempTextField.text = setWaterTempTextField(with: note.waterTempC)
        
        // Coffee Details
        updateCoffeePickerLabels()
        roastDateTextField.text = note.roastDate != nil ? note.roastDate!.stringFromDate(dateStyle: .medium, timeStyle: nil) : ""
        
        // Notes
        notesTextView.text = note.text
    }
    
    private func updateCoffeePickerLabels() {
        if note.coffee.name == "" {
            coffeeNameLabel.text = "Select coffee or add new"
            coffeeDivider.isHidden = true
            roasterLabel.isHidden = true
            originLabel.isHidden = true
            roastLevelLabel.isHidden = true
        } else {
            coffeeNameLabel.text = note.coffee.name
            coffeeDivider.isHidden = false
            roasterLabel.isHidden = false
            originLabel.isHidden = false
            roastLevelLabel.isHidden = false
        }
        
        if note.coffee.roaster == "" {
            roasterLabel.text = "Enter coffee roaster"
        } else {
            roasterLabel.text = note.coffee.roaster
        }
        
        if note.coffee.origin == "" {
            originLabel.text = "Enter coffee origin"
        } else {
            originLabel.text = note.coffee.origin
        }
        
        if note.coffee.roastLevel == "" {
            roastLevelLabel.text = "Enter roast level"
        } else {
            roastLevelLabel.text = note.coffee.roastLevel
        }
    }
    
    private func setWaterTempTextField(with cValue: Double) -> String {
        guard cValue != 0 else { return "" }
        
        switch waterTempUnitControl.selectedSegmentIndex {
        case TempUnit.celsius.rawValue:
            return cValue.clean
        case TempUnit.fahrenheit.rawValue:
            return convertTemp(value: cValue, from: .celsius, to: .fahrenheit).clean
        default:
            fatalError("There should never be more than 2 options.")
        }
    }
    
    private func flavorProfileText(from recipe: RecipeMO) -> String {
        guard let balance = Balance(rawValue: Float(recipe.balanceRaw)) else { return "" }
        guard let strength = Strength(rawValue: Int(recipe.strengthRaw)) else { return "" }
        
        let balanceString = String(describing: balance).capitalized
        let strengthString = String(describing: strength).capitalized
        
        return balanceString + " & " + strengthString
    }
    
    private func poursLabelText(from recipe: RecipeMO) -> String {
        let recipePours = recipe.waterPours
        let recipePoursStrings = recipePours.map { $0.clean + "g" }
        
        return recipePoursStrings.joined(separator: " → ")
    }
    
    // MARK: Load Coffee
    
    @objc private func didTapCoffeeView() {
        print("tapped coffee view")
        notesCoordinator?.showCoffeePicker(dataManager: dataManager, delegate: self)
    }
    
    // MARK: Temperature Unit Control
    
    @IBAction func didChangeTempUnit(_ sender: UISegmentedControl) {
        let appState = (sender.selectedSegmentIndex, isEditing)
        
        switch appState {
        // If isEditing is true, changing segment sets the value on the object
        case (TempUnit.celsius.rawValue, true):
            print("Switched to \(TempUnit.celsius), should write")
            note.tempUnitRawValue = Int64(TempUnit.celsius.rawValue)
        case (TempUnit.fahrenheit.rawValue, true):
            print("Switched to \(TempUnit.fahrenheit), should write")
            note.tempUnitRawValue = Int64(TempUnit.fahrenheit.rawValue)
        
        // If isEditing is false, changing segment converts displayed value but doesn't change any stored values on object
        case (TempUnit.celsius.rawValue, false):
            print("Switched to \(TempUnit.celsius), should convert")
            guard let tempValue = Double(waterTempTextField.text!) else { return }
            waterTempTextField.text = convertTemp(value: tempValue, from: .fahrenheit, to: .celsius).clean
        case (TempUnit.fahrenheit.rawValue, false):
            print("Switched to \(TempUnit.fahrenheit), should convert")
            guard let tempValue = Double(waterTempTextField.text!) else { return }
            waterTempTextField.text = convertTemp(value: tempValue, from: .celsius, to: .fahrenheit).clean
        
        default:
            fatalError("There should only be 4 possible states.")
        }
    }
    
    private func convertTemp(value: Double, from inUnit: UnitTemperature, to outUnit: UnitTemperature) -> Double {
        let temperature = Measurement(value: value, unit: inUnit)
        return temperature.converted(to: outUnit).value
    }
    
    private func getCelsiusTemp() -> Double {
        guard let value = Double(waterTempTextField.text!) else { return 0 }
        
        switch waterTempUnitControl.selectedSegmentIndex {
        case TempUnit.celsius.rawValue:
            return value
        case TempUnit.fahrenheit.rawValue:
            return convertTemp(value: value, from: .fahrenheit, to: .celsius)
        default:
            fatalError("There should never be more than 2 options.")
        }
    }
    
    // MARK: Update Note Managed Object
    
    private func getBackgroundNote() -> NoteMO? {
        let objectID = note.objectID
        
        var backgroundNote: NoteMO?
        dataManager.backgroundContext.performAndWait {
            backgroundNote = self.dataManager.backgroundContext.object(with: objectID) as? NoteMO
        }
        
        return backgroundNote
    }
    
    private func updateNote(with textField: UITextField) {
        let text = textField.text ?? ""
        let temp = getCelsiusTemp()
        let roastDate = roastDateTextField.datePicker.date
        
        guard let backgroundNote = getBackgroundNote() else { return }
        
        backgroundNote.managedObjectContext?.perform {
            switch textField {
            case self.grindSettingTextField:
                backgroundNote.grindSetting = text
            case self.waterTempTextField:
                backgroundNote.waterTempC = temp
            case self.roastDateTextField:
                backgroundNote.roastDate = roastDate
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
        guard note.rating != rating else { return }
        guard let backgroundNote = getBackgroundNote() else { return }
        backgroundNote.managedObjectContext?.perform {
            backgroundNote.rating = Int64(rating)
            self.dataManager.save(backgroundNote)
        }
    }
    
    // MARK: Delete Note

    @IBAction func didTapDeleteButton(_ sender: RoundButton) {
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
        print("Deleting note")
        dataManager.delete(note)
        navigationController?.popViewController(animated: true)
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
        guard doubleTapHint.alpha == 0 else { return }
        
        UIView.animate(withDuration: 0.75, delay: 0) {
            self.doubleTapHint.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 0.75, delay: 5) {
                self.doubleTapHint.alpha = 0
            }
        }
    }
    
    func ratingControl(ratingControl: RatingControl, didChangeRating rating: Int) {
        updateNote(with: rating)
    }
}

// MARK: - CoffeePickerDelegate methods

extension NoteDetailsVC: CoffeePickerDelegate {
    func didPickCoffee(_ coffee: CoffeeMO) {
        note.coffee = coffee
        dataManager.saveContext()
        updateCoffeePickerLabels()
    }
}
