//
//  Utility.swift
//  TripMatch
//
//  Created by Huyanh Hoang on 2017. 2. 18..
//  Copyright © 2017년 Yingbo Wang. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let backgroundTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(backgroundTapGesture)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
