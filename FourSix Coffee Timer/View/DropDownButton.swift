//
//  DropDownButton.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 7/5/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class DropDownButton: RoundButton {
    let selectedImage = UIImage(systemName: "checkmark")
    var titles: [String] = []
    var selectedTitleIndex = 0

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
    func configureDropDown(title: String, image: UIImage? = nil, identifier: UIMenu.Identifier? = nil, options: UIMenu.Options = [], actions: [UIAction]) {
        actions.forEach { self.titles.append($0.title) }
        actions[selectedTitleIndex].image = selectedImage
        menu = UIMenu(title: title,
                      image: image,
                      identifier: identifier,
                      options: options,
                      children: actions)
    }
}
