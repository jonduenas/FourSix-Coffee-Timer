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
    @IBOutlet weak var roasterNameTextField: UITextField!
    @IBOutlet weak var coffeeNameTextField: UITextField!
    @IBOutlet weak var originTextField: UITextField!
    @IBOutlet weak var roastDateTextField: UITextField!
    @IBOutlet weak var roastLevelTextField: UITextField!
    
    // Notes
    @IBOutlet weak var notesTextView: NotesTextView!
    
    @IBOutlet weak var deleteButton: RoundButton!
    
    var dataManager: DataManager!
    weak var coordinator: NotesCoordinator?
    var noteID: NSManagedObjectID?
    var note: NoteMO!
    var recipe: Recipe? = Recipe.defaultRecipe
    var session: SessionMO?
    var coffeeDetails: CoffeeMO?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerKeyboardNotifications()
        ratingControl.delegate = self
        configureNavController()
        setUIEditMode()
        
        if let noteID = noteID {
            note = dataManager.mainContext.object(with: noteID) as? NoteMO
            configureView()
        }
//        else {
//            guard let recipe = recipe, let session = session else { return }
//            let newNote = Note(recipe: recipe, session: session, date: Date(), rating: 0, noteText: "", coffeeDetails: CoffeeDetails(roaster: "", coffeeName: "", origin: "", roastDate: Date(), roastLevel: ""), grindSetting: "", waterTemp: 0, waterTempUnit: .celsius)
//            note = newNote
//            configureView(with: newNote)
//        }
    }
    
    private func configureNavController() {
        navigationController?.hideBarShadow(true)
        navigationItem.rightBarButtonItem = editButtonItem
        // TODO: Remove setting tint color and move it to global setting
        navigationController?.navigationBar.tintColor = UIColor(named: AssetsColor.accent.rawValue)
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
        
        roasterNameTextField.isEnabled = isEditing
        roasterNameTextField.borderStyle = borderStyle
        
        coffeeNameTextField.isEnabled = isEditing
        coffeeNameTextField.borderStyle = borderStyle
        
        originTextField.isEnabled = isEditing
        originTextField.borderStyle = borderStyle
        
        roastDateTextField.isEnabled = isEditing
        roastDateTextField.borderStyle = borderStyle
        
        roastLevelTextField.isEnabled = isEditing
        roastLevelTextField.borderStyle = borderStyle
        
        notesTextView.setToEditMode(isEditing)
        
        deleteButton.isHidden = !isEditing
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
        roastDateTextField.datePicker(target: self,
                                      selectedDate: note.roastDate,
                                      datePickerMode: .date,
                                      valueChangedSelector: #selector(didChangeDateValue(_:)))
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
        roasterNameTextField.text = note.coffee.roaster
        coffeeNameTextField.text = note.coffee.name
        originTextField.text = note.coffee.origin
        roastDateTextField.text = note.roastDate != nil ? note.roastDate!.stringFromDate(dateStyle: .medium, timeStyle: nil) : ""
        roastLevelTextField.text = note.coffee.roastLevel
        
        // Notes
        notesTextView.text = note.text
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
    
    // MARK: DatePicker delegate methods
    
    @objc func didChangeDateValue(_ sender: UIDatePicker) {
        roastDateTextField.text = sender.date.stringFromDate(dateStyle: .medium, timeStyle: nil)
    }
    
    // MARK: Temperature Unit Control
    
    @IBAction func didChangeTempUnit(_ sender: UISegmentedControl) {
        let appState = (sender.selectedSegmentIndex, isEditing)
        
        switch appState {
        // If isEditing is true, changing segment sets the value on the object
        case (TempUnit.celsius.rawValue, true):
            print("Switched to \(TempUnit.celsius), should write")
            //note?.waterTempUnit = .celsius
        case (TempUnit.fahrenheit.rawValue, true):
            print("Switched to \(TempUnit.fahrenheit), should write")
            //note?.waterTempUnit = .fahrenheit
        
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
        
        guard let backgroundNote = getBackgroundNote() else { return }
        
        backgroundNote.managedObjectContext?.perform {
            switch textField {
            case self.grindSettingTextField:
                backgroundNote.grindSetting = text
            case self.waterTempTextField:
                backgroundNote.waterTempC = self.getCelsiusTemp()
            case self.roasterNameTextField:
                backgroundNote.coffee.roaster = text
            case self.coffeeNameTextField:
                backgroundNote.coffee.name = text
            case self.originTextField:
                backgroundNote.coffee.origin = text
            case self.roastDateTextField:
                print(text)
                // TODO: Subclass UITextField and add function for extracting Date instead of string text
            case self.roastLevelTextField:
                backgroundNote.coffee.roastLevel = text
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
    // TODO: Finish configuring delete button
    @IBAction func didTapDeleteButton(_ sender: RoundButton) {
        let ac = UIAlertController(title: "Deleting Note...",
                                   message: "Are you sure you want to delete this note? You can't undo it.",
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deleteNote()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    private func deleteNote() {
        print("Deleting note")
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

// MARK: - RatingControl delegate methods

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
