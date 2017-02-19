//
//  AirportViewController.swift
//  TripMatch
//
//  Created by Yingbo Wang on 2/18/17.
//  Copyright © 2017 Yingbo Wang. All rights reserved.
//

import Foundation
import Alamofire
import SearchTextField

class AirportViewController: BaseOnboardViewController {
    
    let AMADEUS_API_KEY = "Eq55oRpz6dwQe3jXTLF1d3Gq8Lpxmpb1"
    
    @IBOutlet weak var AirportTextField: SearchTextField!
    var airports: [String] = ["hi","asdf","asfdff"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1 - Configure a simple search text field
        configureSimpleSearchTextField()
        
        //sendAirportAutocompleteRequest(airportName: "LAX")
    }
    
    // 1 - Configure a simple search text view
    fileprivate func configureSimpleSearchTextField() {
        // Start visible - Default: false
        AirportTextField.startVisible = false
        
        AirportTextField.userStoppedTypingHandler = {
            // Set data source
            if let userTyped = self.AirportTextField.text {
                
                // Show loading indicator
                self.AirportTextField.showLoadingIndicator()
                
                // we do not query Amadeus API when the user clears his input, or the response JSON cannot be parsed into NSArray
                if (userTyped != "") {
                    self.sendAirportAutocompleteRequest(airportName: userTyped) { (result) in
                        self.AirportTextField.filterStrings(result)
                        
                        // Stop loading indicator
                        self.AirportTextField.stopLoadingIndicator()
                    }
                }
            }
        }

    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.view.endEditing(true)
//        return false
//    }
//    
    ////////////////////////////////////////////////////////
    // Data Sources
    fileprivate func sendAirportAutocompleteRequest(airportName airport: String, _ callback: @escaping ([String]) -> ()) -> Void {
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
                
                var allAirportLabels: [String] = []

                for airport in airportLists {
                    let airportDict = airport as! NSDictionary
                    let airportLabel = airportDict["label"]!  // the name string of each airport
                    
//                    let airportLabelWithNewLine = (airportLabel as! String)
//                    allAirportLabels.append(airportLabelWithNewLine)
                    allAirportLabels.append(airportLabel as! String)
                    
                }
                DispatchQueue.main.async {
                    callback(allAirportLabels)
                    }
//                self.AirportNamesLabel.text = allAirportLabels
            }
        }
    }

}
