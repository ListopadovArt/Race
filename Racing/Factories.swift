//
//  Factories.swift
//  Racing
//
//  Created by Artem Listopadov on 6.12.22.
//  Copyright © 2022 Artem Listopadov. All rights reserved.
//

import UIKit

func makeTitleLabel(withTitle text: String) -> UILabel {
    let label = UILabel()
    label.textAlignment = .center
    let labelAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
    let labelAttributesString = NSAttributedString(string: text.localized, attributes: labelAttributes)
    label.attributedText = labelAttributesString
    label.font = UIFont(name: Fonts.konstanting.rawValue, size: 50)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
}

func makeMenuButton(withText text: String, color: UIColor) -> UIButton {
    let button = UIButton()
    button.backgroundColor = color
    button.roundCorners()
    let labelText = text.localized
    button.titleLabel?.adjustsFontSizeToFitWidth = true
    button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    let buttonAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    let buttonAttributesString = NSAttributedString(string: labelText, attributes: buttonAttributes)
    button.setAttributedTitle(buttonAttributesString, for: .normal)
    button.titleLabel?.font = UIFont(name: Fonts.konstanting.rawValue, size: 50)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
}

func makeGameButton(withName name: String) -> UIButton {
    let button = UIButton()
    button.layer.contents = UIImage(named: name)?.cgImage
    button.layer.contentsGravity = CALayerContentsGravity.resize
    button.layer.masksToBounds = true
    return button
}

func makeSpeedButton(withSpeed text: String) -> UIButton {
    let button = UIButton(type: .system)
    button.setTitle(text, for: .normal)
    button.roundCorners(radius: 5)
    button.layer.borderWidth = 1
    button.tintColor = UIColor.black
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
}

func makeCarSelectionButton(withDirection text: String) -> UIButton {
    let rightButton = UIButton()
    rightButton.layer.contents = UIImage(named: text)?.cgImage
    rightButton.layer.contentsGravity = CALayerContentsGravity.resize
    rightButton.layer.masksToBounds = true
    rightButton.translatesAutoresizingMaskIntoConstraints = false
    return rightButton
}
