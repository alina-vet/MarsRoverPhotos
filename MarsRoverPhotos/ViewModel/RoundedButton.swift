//
//  RoundedButton.swift
//  MarsRoverPhotos
//
//  Created by Alina Bondarchuk on 29.05.2024.
//

import UIKit

class RoundedButton: UIButton{

    @IBInspectable var shadowColor: UIColor = UIColor.clear {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }

    @IBInspectable var shadowRadius: CGFloat = 0.0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0.0, height: 0.0) {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable var isCircle: Bool = false {
        didSet {
            layer.cornerRadius = isCircle ? layer.frame.height / 2 : cornerRadius
        }
    }
}
