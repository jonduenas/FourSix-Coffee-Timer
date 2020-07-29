//
//  CustomRatioVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 7/29/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

class CustomRatioVC: UIViewController, UITextFieldDelegate {

    var ratioValue: Float?
    weak var delegate: RatioVC?
    
    @IBOutlet var ratioTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ratioTextField.delegate = self
        ratioTextField.placeholder = "\(ratioValue ?? 15.0)"
        ratioTextField.becomeFirstResponder()
    }
    
    // Limits character count of textfield to 4
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = ratioTextField.text ?? ""
        
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 4
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        guard let ratioFloat = Float(ratioTextField.text!) else { return }
        
        if 5...20 ~= ratioFloat {
            setRatio(ratioFloat)
        } else {
            let alert = UIAlertController(title: "Selected ratio is outside the normal range", message: "You're trying to set a ratio of 1:" + ratioFloat.clean + ". This is unusual for this method. Are you sure you want to continue?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { [weak self] _ in
                self?.setRatio(ratioFloat)
            }))
            present(alert, animated: true)
        }
    }
    
    func setRatio(_ ratio: Float) {
        guard let delegate = delegate else { return }
        delegate.ratioValue = ratio
        delegate.updateCustomRatio()
        self.dismiss(animated: true) {
            delegate.navigationController?.popViewController(animated: true)
        }
    }
}
