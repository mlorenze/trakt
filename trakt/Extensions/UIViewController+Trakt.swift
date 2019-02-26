//
//  UIViewController+Trakt.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/26/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import UIKit

extension UIViewController {
    @objc func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
