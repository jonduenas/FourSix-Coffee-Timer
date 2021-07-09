//
//  DropDownButton.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 7/5/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

protocol DropDownButtonDelegate: AnyObject {
    func dropDownButton(_ dropDownButton: DropDownButton, didSelectIndex index: Int)
}

class DropDownButton: RoundButton {
    let selectedImage = UIImage(systemName: "checkmark")
    var titles: [String] = []
    var selectedTitleIndex = 0
    weak var delegate: DropDownButtonDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        commonInit()
    }

    private func commonInit() {
        if #available(iOS 14.0, *) {
            showsMenuAsPrimaryAction = true
            borderColor = UIColor.gray.withAlphaComponent(0.25)
            borderSize = 0.5
        } else {
            borderColor = UIColor.gray.withAlphaComponent(0.4)
            borderSize = 1.0
        }
    }

    @available(iOS 14.0, *)
    func configureDropDown(title: String, image: UIImage? = nil, identifier: UIMenu.Identifier? = nil, options: UIMenu.Options = []) {
        let actions = menuChildren()

        menu = UIMenu(title: title,
                      image: image,
                      identifier: identifier,
                      options: options,
                      children: actions)
    }

    @available(iOS 14.0, *)
    func menuChildren() -> [UIMenuElement] {
        var actions: [UIAction] = []

        titles.enumerated().forEach { index, title in
            let action = UIAction(title: title) { _ in
                self.selectedTitleIndex = index
                self.delegate?.dropDownButton(self, didSelectIndex: index)
                self.updateSelectedItem()
            }
            actions.append(action)
        }

        actions[selectedTitleIndex].image = selectedImage

        return actions
    }

    private func updateSelectedItem() {
        let title = titles[selectedTitleIndex]
        setTitle(title, for: .normal)

        if #available(iOS 14.0, *) {
            if let currentMenu = menu {
                let newChildren = menuChildren()

                menu = nil
                menu = currentMenu.replacingChildren(newChildren)
            }
        }
    }
}
