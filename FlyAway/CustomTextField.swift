//
//  CustomTextField.swift
//  My Employees
//
//  Created by Mohammed Ibrahim on 2017-07-16.
//  Copyright © 2017 Mohammed Ibrahim. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
}
