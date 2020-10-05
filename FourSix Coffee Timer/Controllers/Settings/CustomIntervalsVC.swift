//
//  CustomIntervalsVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 10/5/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

class CustomIntervalsVC: UIViewController {

    private let formatter = NumberFormatter()
    
    var intervalValue: Int?
    weak var delegate: SettingsVC?
    
    @IBOutlet weak var intervalTextField: UITextField!
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
        formatter.numberStyle = .none
        formatter.maximumIntegerDigits = 3
    }
    
    fileprivate func initializeTextField() {
        intervalTextField.delegate = self
        
        if let interval = formatter.string(for: intervalValue) {
            intervalTextField.placeholder = interval + "s"
        } else {
            intervalTextField.placeholder = "45s"
        }
        
        intervalTextField.becomeFirstResponder()
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        guard let intervalString = intervalTextField.text else { return }
        
        guard let intervalInt = formatter.number(from: intervalString)?.intValue else { return }
        
        guard let delegate = delegate else { return }
        delegate.stepInterval = intervalInt
        delegate.tableView.reloadData()
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardHeight = keyboardScreenEndFrame.height
        let viewHeight = self.view.frame.height
        let constraintFromKeyboard = ((viewHeight - keyboardHeight) / 2) - (popupViewHeightConstraint.constant / 2)
        
        popupViewBottomConstraint.constant = keyboardHeight + constraintFromKeyboard
    }
}

extension CustomIntervalsVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard intervalTextField.keyboardType == .numberPad, let currentText = intervalTextField.text, let range = Range(range, in: currentText) else { return true }

        let updatedText = currentText.replacingCharacters(in: range, with: string)
        
        let isNumeric = updatedText.isEmpty || (formatter.number(from: updatedText)?.floatValue != nil)
        
        let characterLimit = 3
        
        return isNumeric && updatedText.count <= characterLimit
    }
}
