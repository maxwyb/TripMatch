//
//  LoginViewController.swift
//  TripMatch
//
//  Created by Sara Du on 2/18/17.
//  Copyright © 2017 Yingbo Wang. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FirebaseDatabase

class LoginViewController: UIViewController {

    var FbUserID: String?
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let loginButton = LoginButton(readPermissions: [ .publicProfile, .custom("user_events")])
        loginButton.center = view.center
        
        view.addSubview(loginButton)
        
        
        if let accessToken = AccessToken.current {
            if let userID = accessToken.userId {
                FbUserID = userID
                
            }
        }
        
        getUserEvents()

        
        ref = FIRDatabase.database().reference()

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
    
    func processUserEventsResponse(_ response: GraphRequest.Response) {
        
        let respResult = response.dictionaryValue!
        let eventsList = respResult["data"] as! NSArray
        
        var allUserEvents = ""
        for eventEntry in eventsList {
            let eventEntryDict = eventEntry as! NSDictionary
            
            // get the dictionary of each event here
            print(eventEntryDict["name"]!)
            let eventNameWithNL = (eventEntryDict["name"]! as! String) + "\n"
            
            //Sending information up to the database
            
            //checking if event exists already
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.hasChild(eventNameWithNL){
                    
                    print("true event exists")
                    
                    let ref1 = FIRDatabase.database().reference().child("events").child(eventNameWithNL)

                    var newArray = [String]()
                    ref1.observeSingleEvent(of: .value, with: { (snapshot) in
                        if snapshot.exists() {
                            if let all = ((snapshot.value as AnyObject)) as? [String]{
                                var newArr = all
                                newArr.append(self.FbUserID!)
                                newArray = newArr
                            }
                        }
                    })
                    
                }else{
                    self.ref.child("events").child(eventNameWithNL).setValue(["username": self.FbUserID])
                    
                    print("false event doesn't exist")
                }
                
                
            })

            allUserEvents.append(eventNameWithNL)
            
        }
        print(allUserEvents)

    }
    
    
    
}
