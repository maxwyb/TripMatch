//
//  AirportViewController.swift
//  TripMatch
//
//  Created by Yingbo Wang on 2/18/17.
//  Copyright © 2017 Yingbo Wang. All rights reserved.
//

import Foundation
import Alamofire

class AirportViewController: UIViewController, UITextFieldDelegate {
  
  let AMADEUS_API_KEY = "Eq55oRpz6dwQe3jXTLF1d3Gq8Lpxmpb1"
  
  @IBOutlet weak var AirportTextField: UITextField!
  
  @IBOutlet weak var AirportNamesLabel: UILabel!
  
  // MARK: UITextFieldDelegate
  func textFieldDidChange(_ textField: UITextField) {
    if let userTyped = textField.text {
          sendAirportAutocompleteRequest(airportName: userTyped)
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    AirportTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    self.AirportTextField.delegate = self
    
    //sendAirportAutocompleteRequest(airportName: "LAX")
  }
  
  func sendAirportAutocompleteRequest(airportName airport: String) {
    let requestURL = "https://api.sandbox.amadeus.com/v1.2/airports/autocomplete?apikey=" + AMADEUS_API_KEY + "&term=" + airport
    print("Amadeus Airport Autocomplete: HTTP request = " + requestURL)
    
    /*
    var airportsList = [[String:String]]()
    var airportLists: NSDictionary!
    */
    var airportLists: NSArray!
    Alamofire.request(requestURL).responseJSON { response in
      /*
      print(response.request)  // original URL request
      print(response.response) // HTTP URL response
      print(response.data)     // server data
      print(response.result)   // result of response serialization
      */
      
      /*
      airportLists = try? JSONSerialization.jsonObject(with: response.data!, options: []) as! NSDictionary
      */
      if let JSON = response.result.value {
        print("JSON: \(JSON)")
        
        airportLists = JSON as! NSArray
        /*
         airportLists = JSON as! NSDictionary
         */
        /*
        airportLists = try? JSONSerialization.jsonObject(with: JSON, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
        airportLists = try? JSONSerialization.jsonObject(with: (JSON as! Data), options: []) as! NSDictionary
        */
        
        var allAirportLabels = ""
        for airport in airportLists {
          let airportDict = airport as! NSDictionary
          let airportLabel = airportDict["label"]!
          
          let airportLabelWithNewLine = (airportLabel as! String) + "\n"
          allAirportLabels.append(airportLabelWithNewLine)
          
          print(airportLabel)
        }
        self.AirportNamesLabel.text = allAirportLabels
      }
    }
  }
  
}
