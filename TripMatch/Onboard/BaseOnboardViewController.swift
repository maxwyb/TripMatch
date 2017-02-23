//
//  BaseOnboardViewController.swift
//  TripMatch
//
//  Created by Huyanh Hoang on 2017. 2. 18..
//  Copyright © 2017년 Yingbo Wang. All rights reserved.
//

import UIKit
import Material

struct ButtonLayout {
    struct Fab {
        static let diameter: CGFloat = 48
    }
}

class BaseOnboardViewController: UIViewController {
    
    @IBOutlet weak var fabButton: FabButton!
    @IBOutlet weak var textField: UITextField!
    var buttonOrigin: CGPoint?
    
    fileprivate var keyboardSize: CGRect?
    fileprivate var backgroundTapGesture: UITapGestureRecognizer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonOrigin = fabButton.frame.origin
        textField.delegate = self
        prepareFabButton()
        registerForKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        guard let navigationController = navigationController else { return }
        
        navigationController.navigationBar.backgroundColor = nil
        navigationController.navigationBar.barStyle = .default
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        // .shadowImage and .setBackgroundImage must be UIImage() in order to be clear otherwise default
        
        let textAttributes: [String: AnyObject] = [
            NSForegroundColorAttributeName: UIColor.white,
        ]
        
        navigationController.navigationBar.titleTextAttributes = textAttributes
        navigationController.navigationBar.tintColor = .black
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(aNotification: NSNotification) {
        if let userInfo: NSDictionary = aNotification.userInfo! as NSDictionary? {
            keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        }
//
//        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
//            self.view.frame.origin = CGPoint(x: 0, y: -self.keyboardSize!.height)
//        }, completion: nil)
        UIView.animate(withDuration: 0.1) {
            self.fabButton.frame.origin = CGPoint(x: self.fabButton.frame.origin.x, y: self.fabButton.frame.origin.y - self.keyboardSize!.height)
        }
    }
    
    func keyboardWillBeHidden(aNotification: NSNotification) {
//        UIView.animate(withDuration: 0.1) {
//            self.view.frame.origin = CGPoint(x: 0, y: 0)
//        }
        UIView.animate(withDuration: 0.1) {
            self.fabButton.frame.origin = self.buttonOrigin!
        }
        
    }

}

extension BaseOnboardViewController {
    
    fileprivate func prepareFabButton() {
        fabButton.image = Icon.cm.arrowBack
        fabButton.tintColor = .white
        fabButton.pulseColor = .white
        fabButton.backgroundColor = Color.black
        fabButton.transform = CGAffineTransform(scaleX: -1, y: 1)
        fabButton.title = nil
        fabButton.layer.width = ButtonLayout.Fab.diameter
        fabButton.layer.height = ButtonLayout.Fab.diameter
    }

}

extension BaseOnboardViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        backgroundTapGesture = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(backgroundTapGesture!)
        hideKeyboardWhenTappedAround()
    }
    
    override func dismissKeyboard() {
        view.endEditing(true)
        view.removeGestureRecognizer(backgroundTapGesture!)
    }
    
}



