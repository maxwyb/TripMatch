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

    // the Facebook Login button
    let loginButton = LoginButton(readPermissions: [ .publicProfile, .custom("user_events")])
    loginButton.center = view.center
    
    view.addSubview(loginButton)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  func getUserInfo() {
    // get a Facebook user's metadata after logged into Facebook
    if let accessToken = AccessToken.current {
      if let userID = accessToken.userId {
        FbUserID = userID
        
        print("\(accessToken)")
        let userIDString = "Facebook User ID = " + userID
        userInfoLabel.text = userIDString
        print("Facebook User ID = " + userID)
      }
    }
  }
  
  func processUserEventsResponse(_ response: GraphRequest.Response) {
    
    //let respResult = response as! NSDictionary
    /*
    var jsonError: NSError?
    let swiftObject: AnyObject = JSONSerialization.JSONObjectWithData(response, options: JSONSerialization.ReadingOptions.AllowFragments)
     */
    
    // parse the events query response into an array of event names
    let respResult = response.dictionaryValue!
    let eventsList = respResult["data"] as! NSArray
    
    var allUserEvents = ""
    for eventEntry in eventsList {
      let eventEntryDict = eventEntry as! NSDictionary
      
      // get the dictionary of each event here
      print(eventEntryDict["name"]!)
      let eventNameWithNL = (eventEntryDict["name"]! as! String) + "\n"
      allUserEvents.append(eventNameWithNL)
    }
    eventsListLabel.text = allUserEvents
  }
  
  func getUserEvents() {
    // send query of an users' events going in Graph API
    if let userID = FbUserID {
      let FbGraphPath = userID + "/events"
      //let FbGraphPath = "me"
      print("graphPath: ", FbGraphPath)
      
      let connection = GraphRequestConnection()
      connection.add(GraphRequest(graphPath: FbGraphPath)) { httpResponse, result in
        switch result {
        case .success(let response):
          print("Graph Request Succeeded: \(response)")
          self.processUserEventsResponse(response)
          
        case .failed(let error):
          print("Graph Request Failed: \(error)")
        }
      }
      connection.start()
    }
  }

  @IBOutlet weak var userInfoLabel: UILabel!
  
  @IBOutlet weak var eventsListLabel: UILabel!

  @IBAction func getUserInfoButtonClicked() {
    getUserInfo()
  }
  
  @IBAction func getEventsButtonClicked() {
    getUserEvents()
  }
  
}

