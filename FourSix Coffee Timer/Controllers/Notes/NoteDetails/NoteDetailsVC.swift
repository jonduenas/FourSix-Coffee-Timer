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
    
    var coreDataStack: CoreDataStack!
    weak var coordinator: NotesCoordinator?
    var noteID: NSManagedObjectID?
    var recipe: Recipe? = Recipe.defaultRecipe
    var session: SessionMO?
    var coffeeDetails: CoffeeMO?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerKeyboardNotifications()
        
        navigationController?.hideBarShadow(true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveNote))
        
        if let noteID = noteID {
            let noteObject = coreDataStack.mainContext.object(with: noteID) as! NoteMO
            configureView(with: noteObject)
        }
//        else {
//            guard let recipe = recipe, let session = session else { return }
//            let newNote = Note(recipe: recipe, session: session, date: Date(), rating: 0, noteText: "", coffeeDetails: CoffeeDetails(roaster: "", coffeeName: "", origin: "", roastDate: Date(), roastLevel: ""), grindSetting: "", waterTemp: 0, waterTempUnit: .celsius)
//            note = newNote
//            configureView(with: newNote)
//        }
    }
    
    @objc func saveNote() {
        if let noteID = noteID {
            let derivedContext = coreDataStack.newDerivedContext()
            let testNote = derivedContext.object(with: noteID) as! NoteMO
            
            testNote.grindSetting = grindSettingTextField.text ?? ""
            testNote.rating = Int64(ratingControl.rating)
            testNote.waterTempC = Double(waterTempTextField.text!) ?? 0
            
            testNote.coffee.roaster = roasterNameTextField.text ?? ""
            testNote.coffee.name = coffeeNameTextField.text ?? ""
            testNote.coffee.origin = originTextField.text ?? ""
            testNote.coffee.roastLevel = roastLevelTextField.text ?? ""
            
            testNote.text = notesTextView.text ?? ""
            
            coreDataStack.saveContext(testNote.managedObjectContext!)
        }
    }
    
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func configureView(with note: NoteMO) {
        note.managedObjectContext?.perform {
            self.dateLabel.text = note.date.stringFromDate(dateStyle: .short, timeStyle: .short)
            self.updateLabels(with: note)
            self.initializeDatePicker(with: note)
            self.ratingControl.rating = Int(note.rating)
            self.waterTempUnitControl.selectedSegmentIndex = UserDefaultsManager.tempUnitRawValue
        }
    }
    
    private func initializeDatePicker(with note: NoteMO) {
        roastDateTextField.datePicker(target: self,
                                      selectedDate: note.roastDate,
                                      datePickerMode: .date,
                                      valueChangedSelector: #selector(didChangeDateValue(_:)))
    }
    
    private func updateLabels(with note: NoteMO) {
        // Session
        drawdownLabel.text = note.session.averageDrawdown.minAndSecString
        totalTimeLabel.text = note.session.totalTime.minAndSecString
        
        // Recipe
        flavorProfileLabel.text = flavorProfileText(from: note.recipe)
        coffeeAmountLabel.text = note.recipe.coffee.clean + "g"
        waterAmountLabel.text = note.recipe.waterTotal.amount.clean + "g"
        poursLabel.text = poursLabelText(from: note.recipe)
        pourIntervalLabel.text = note.recipe.interval.minAndSecString
        grindSettingTextField.text = note.grindSetting
        waterTempTextField.text = note.waterTempC != 0 ? note.waterTempC.clean : ""
        
        // Coffee Details
        roasterNameTextField.text = note.coffee.roaster
        coffeeNameTextField.text = note.coffee.name
        originTextField.text = note.coffee.origin
        roastDateTextField.text = note.roastDate != nil ? note.roastDate!.stringFromDate() : ""
        roastLevelTextField.text = note.coffee.roastLevel
        
        // Notes
        notesTextView.text = note.text
    }
    
    private func flavorProfileText(from recipe: RecipeMO) -> String {
        guard let balance = Balance(rawValue: Float(recipe.balanceRaw)) else { return "" }
        guard let strength = Strength(rawValue: Int(recipe.strengthRaw)) else { return "" }
        
        let balanceString = String(describing: balance).capitalized
        let strengthString = String(describing: strength).capitalized
        
        return balanceString + " & " + strengthString
    }
    
    private func poursLabelText(from recipe: RecipeMO) -> String {
        let recipePours = recipe.waterPours?.array as! [WaterMO]
        let recipePoursStrings = recipePours.map { $0.amount.clean + "g" }
        
        return recipePoursStrings.joined(separator: " → ")
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
    
    @objc func didChangeDateValue(_ sender: UIDatePicker) {
        roastDateTextField.text = sender.date.stringFromDate()
    }
    
    @IBAction func didChangeTempUnit(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case TempUnit.celsius.rawValue:
            print("Switched to \(TempUnit.celsius)")
            //note?.waterTempUnit = .celsius
        case TempUnit.fahrenheit.rawValue:
            print("Switched to \(TempUnit.fahrenheit)")
            //note?.waterTempUnit = .fahrenheit
        default:
            fatalError("There should only be 2 segments for this control.")
        }
    }
}

extension NoteDetailsVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
