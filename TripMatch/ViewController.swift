//
//  ViewController.swift
//  TripMatch
//
//  Created by Yingbo Wang on 2/18/17.
//  Copyright © 2017 Yingbo Wang. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    let loginButton = LoginButton(readPermissions: [ .publicProfile ])
    loginButton.center = view.center
    
    view.addSubview(loginButton)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBOutlet weak var userInfoLabel: UILabel!

  @IBAction func getUserInfoButtonClicked() {
    if let accessToken = AccessToken.current {
      if let userID = accessToken.userId {
        let userIDString = "Facebook User ID = " + userID
        userInfoLabel.text = userIDString
        print("Facebook User ID = " + userID)
      }
    }
  }

}

