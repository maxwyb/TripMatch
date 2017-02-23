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
    
    var arr = [String]()
    var FbUserID: String?
    var rootRef = FIRDatabase.database().reference()
    var eventsRef = FIRDatabaseReference()
    var eventGoingTo: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventGoingTo = UserDefaults.standard.value(forKey: "event") as! String?
        
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .custom("user_events")])
        loginButton.center = view.center
        
        view.addSubview(loginButton)
        
        
        if let accessToken = AccessToken.current {
            if let userID = accessToken.userId {
                FbUserID = userID
                
            }
        }
        
        getUserEvents()
        
        
        eventsRef = rootRef.child("/events")
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
            rootRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.hasChild(eventNameWithNL){
                    
                    print("true event exists")
                    
                    let ref1 = self.eventsRef.child(eventNameWithNL)
                    
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
                    
                    var xString = ""
                    for x in newArray{
                        xString.append(x)
                        xString.append(",")
                    }
                    xString.remove(at: xString.index(before: xString.endIndex))
                    
                    
                    let newEvent: Dictionary<String, AnyObject> = [
                        "eventName": eventNameWithNL as AnyObject,
                        "names": xString as AnyObject
                    ]
                    
                    let setuser = self.eventsRef.childByAutoId()
                    setuser.setValue(newEvent)
                    
                    
                }else{
                    let newEvent: Dictionary<String, AnyObject> = [
                        "eventName": eventNameWithNL as AnyObject,
                        "names": self.FbUserID as AnyObject
                    ]
                    
                    let setuser = self.eventsRef.childByAutoId()
                    setuser.setValue(newEvent)
                    //self.rootRef.cchild(eventNameWithNL).childByAutoId().setValue(["username": self.FbUserID])
                    
                    print("false event doesn't exist")
                }
                
                
            })
            
            allUserEvents.append(eventNameWithNL)
            
        }
        
        makeMatches()
    }
    
    func makeMatches(){
        
        rootRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild(self.eventGoingTo!){
                
                print("true event exists")
                
                let ref1 = self.eventsRef.child(self.eventGoingTo!)
                
                //get all the people going to the events
                ref1.observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.exists() {
                        if let all = ((snapshot.value as AnyObject)) as? [String]{
                            self.arr = all
                        }
                    }
                })
                
                var i = 0
                for x in self.arr{
                    if(x == self.FbUserID){
                        self.arr.remove(at: i)
                        i += 1
                    }
                    i += 1
                }
                
                
            }else{
                
                print("Event does not exist on Facebook")
                
            }
            
            
        })
        
        self.performSegue(withIdentifier: "matched", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! DemoViewController
        for x in self.arr{
            print(x)
        }
        vc.people = arr
    }
    
    
    
}
