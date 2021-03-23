//
//  NoteDetailsVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/17/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class NoteDetailsVC: UIViewController, Storyboarded {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ratingStackView: RatingControl!
    
    // Session
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
    
    // Coffee Details
    @IBOutlet weak var roasterNameTextField: UITextField!
    @IBOutlet weak var coffeeNameTextField: UITextField!
    @IBOutlet weak var originTextField: UITextField!
    @IBOutlet weak var roastDateTextField: UITextField!
    @IBOutlet weak var roastLevelTextField: UITextField!
    
    // Notes
    @IBOutlet weak var notesTextView: NotesTextView!
    
    weak var coordinator: NotesCoordinator?
    var note: Note?
    var recipe: Recipe?
    var session: Session?
    var coffeeDetails: CoffeeDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerKeyboardNotifications()
        ratingStackView.rating = 4
        if let note = note {
            updateLabels(with: note)
        } else {
            guard let recipe = recipe, let session = session else { return }
            let newNote = Note(recipe: recipe, session: session, date: "\(Date())", rating: 0, noteText: "", coffeeDetails: CoffeeDetails(roaster: "", coffeeName: "", origin: "", roastDate: Date(), roastLevel: ""), grindSetting: "", waterTemp: 0)
            updateLabels(with: newNote)
        }
    }
    
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func updateLabels(with note: Note) {
        // Session
        drawdownLabel.text = note.session.averageDrawdown.minAndSecString
        totalTimeLabel.text = note.session.totalTime.minAndSecString
        
        // Recipe
        flavorProfileLabel.text = flavorProfileText(from: note.recipe)
        coffeeAmountLabel.text = note.recipe.coffee.clean + "g"
        waterAmountLabel.text = note.recipe.waterTotal.clean + "g"
        poursLabel.text = poursLabelText(from: note.recipe)
        pourIntervalLabel.text = note.recipe.interval.minAndSecString
        grindSettingTextField.text = note.grindSetting
        waterTempTextField.text = note.waterTemp.clean
        
        // Coffee Details
        roasterNameTextField.text = note.coffeeDetails.roaster
        coffeeNameTextField.text = note.coffeeDetails.coffeeName
        originTextField.text = note.coffeeDetails.origin
        roastDateTextField.text = "\(note.coffeeDetails.roastDate)"
        roastLevelTextField.text = note.coffeeDetails.roastLevel
        
        // Notes
        notesTextView.text = note.noteText
    }
    
    private func flavorProfileText(from recipe: Recipe) -> String {
        let recipeBalance = "\(recipe.balance)"
        let recipeStrength = "\(recipe.strength)"
        
        return "\(recipeBalance.capitalized) & \(recipeStrength.capitalized)"
    }
    
    private func poursLabelText(from recipe: Recipe) -> String {
        let recipePours = recipe.waterPours
        let recipePoursStrings = recipePours.map { $0.clean + "g" }
        
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
}
