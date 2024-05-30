//
//  UIView+Ext.swift
//  MarsRoverPhotos
//
//  Created by Alina Bondarchuk on 28.05.2024.
//

import UIKit

extension UIView {
    func addShadow(offset: CGSize = CGSize(width: 0, height: 5),
                   color: UIColor = .black,
                   radius: CGFloat = 12.0,
                   opacity: Float = 0.12) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}
