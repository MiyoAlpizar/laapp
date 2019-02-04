//
//  ViewExtentions.swift
//  LaApp
//
//  Created by Miyo Alpízar on 2/2/19.
//  Copyright © 2019 Efrain Emigdio Navarrete Alpízar. All rights reserved.
//

import UIKit

extension UIView {
    
    /**
     Makes a corner radius for any UIView
     - Parameters:
     - cornerRadius: the size desired for the corner radius (default is 6)
     */
    func makeCornerRadius(cornerRadius: CGFloat = 6)  {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
    
    func makeShadow() {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.6
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 6.0
    }
    /**
     Makes a corner radius for any UIView
     - Parameters:
     - cornerRadius: the size desired for the corner radius (default is 6)
     - color: color desired for de border (default is nil)
     - width: whidth of the border (default is 1)
     */
    func makeCornerRadius(cornerRadius: CGFloat = 6, color: UIColor? = nil, width: CGFloat = 1)  {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        if let color = color {
            self.layer.borderColor = color.cgColor
            self.layer.borderWidth = width
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIView.dismissKeyboard))
        tap.cancelsTouchesInView = true
        self.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        self.endEditing(true)
    }
    
}
