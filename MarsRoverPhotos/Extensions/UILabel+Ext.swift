//
//  UILabel+Ext.swift
//  MarsRoverPhotos
//
//  Created by Alina Bondarchuk on 28.05.2024.
//

import UIKit

extension UILabel {
    func halfTextColorChange(title: String, text: String) {
        let attributedString = NSMutableAttributedString(string: title + text)
        
        let titleRange = NSRange(location: 0, length: title.count)
        let textRange = NSRange(location: title.count, length: text.count)
        
        attributedString.addAttribute(.font, value: Constants.body!, range: titleRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.gray, range: titleRange)
        
        attributedString.addAttribute(.font, value: Constants.body2!, range: textRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: textRange)
        
        self.attributedText = attributedString
    }
}
