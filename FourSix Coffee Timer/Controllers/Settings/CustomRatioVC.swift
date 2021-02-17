//
//  CustomRatioVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 7/29/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

class CustomRatioVC: UIViewController, Storyboarded {
    
    private let formatter = NumberFormatter()
    
    var ratioValue: Float?
    weak var coordinator: RatioCoordinator?
    
    @IBOutlet var ratioTextField: UITextField!
    @IBOutlet var popupViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var popupViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        initializeNumberFormatter()
        
        initializeTextField()
    }
    
    fileprivate func initializeNumberFormatter() {
        formatter.numberStyle = .decimal
        formatter.alwaysShowsDecimalSeparator = true
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 1
        formatter.maximumIntegerDigits = 2
    }
    
    fileprivate func initializeTextField() {
        ratioTextField.delegate = self
        if let ratio = formatter.string(for: ratioValue) {
            ratioTextField.placeholder = ratio
        } else {
            ratioTextField.placeholder = "15" + formatter.decimalSeparator + "0"
        }
        ratioTextField.becomeFirstResponder()
    }
    
    @objc private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardHeight = keyboardScreenEndFrame.height
        let viewHeight = self.view.frame.height
        let constraintFromKeyboard = ((viewHeight - keyboardHeight) / 2) - (popupViewHeightConstraint.constant / 2)
        
        popupViewBottomConstraint.constant = keyboardHeight + constraintFromKeyboard
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        guard let ratioString = ratioTextField.text else { return }
        guard let ratioFloat = formatter.number(from: ratioString)?.floatValue else { return }
        
        if 5...20 ~= ratioFloat {
            setRatio(ratioFloat)
        } else {
            let alert = UIAlertController(
                title: "Selected ratio is outside the normal range",
                message: "You're trying to set a ratio of 1:" + ratioString + ". This is unusual for this method. Are you sure you want to continue?",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { [weak self] _ in
                self?.setRatio(ratioFloat)
            }))
            present(alert, animated: true)
        }
    }
    
    func setRatio(_ ratio: Float) {
        UserDefaultsManager.ratio = ratio
        self.dismiss(animated: true) { [weak self] in
            self?.coordinator?.didFinishCustomRatio()
        }
    }
}

extension CustomRatioVC: UITextFieldDelegate {
    // Limits characters of textfield to 2 integers, 1 decimal seperator, and 1 fraction digit
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard ratioTextField.keyboardType == .decimalPad, let currentText = ratioTextField.text, let range = Range(range, in: currentText) else { return true }

        let updatedText = currentText.replacingCharacters(in: range, with: string)
        
        let isNumeric = updatedText.isEmpty || (formatter.number(from: updatedText)?.floatValue != nil)
        
        let decimalSeperator = formatter.decimalSeparator ?? "."
        let isDecimalInserted = updatedText.contains(Character(decimalSeperator))
        
        let characterLimit: Int
        if isDecimalInserted {
            characterLimit = 4
        } else {
            characterLimit = 2
        }
        
        let numberOfDecimalSeparators = updatedText.components(separatedBy: decimalSeperator).count - 1

        let numberOfDecimalDigits: Int
        if let separatorIndex = updatedText.firstIndex(of: Character(decimalSeperator)) {
            numberOfDecimalDigits = updatedText.distance(from: separatorIndex, to: updatedText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }
        
        return isNumeric && numberOfDecimalSeparators <= 1 && numberOfDecimalDigits <= 1 && updatedText.count <= characterLimit
    }
}
