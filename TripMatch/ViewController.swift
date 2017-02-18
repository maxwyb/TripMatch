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

  var FbUserID: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    let loginButton = LoginButton(readPermissions: [ .publicProfile, .custom("user_events")])
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
        FbUserID = userID
        
        let userIDString = "Facebook User ID = " + userID
        userInfoLabel.text = userIDString
        print("Facebook User ID = " + userID)
      }
    }
  }
  
  func getUserEvents() {
    if let userID = FbUserID {
      let FbGraphPath = userID + "/events"
      //let FbGraphPath = "me"
      print("graphPath: ", FbGraphPath)
      
      let connection = GraphRequestConnection()
      connection.add(GraphRequest(graphPath: FbGraphPath)) { httpResponse, result in
        switch result {
        case .success(let response):
          print("Graph Request Succeeded: \(response)")
        case .failed(let error):
          print("Graph Request Failed: \(error)")
        }
      }
      connection.start()
    }
  }
  
  @IBAction func getEventsButtonClicked() {
    getUserEvents()
  }
  
}

