//
//  AddLocationViewController.swift
//  On The Map
//
//  Created by Rahaf on 6/14/19.
//  Copyright © 2019 Rahaf. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var locationTxtField: UITextField!
    @IBOutlet weak var linkTxtField: UITextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    
    
    var latitude : Double?
    var longitude : Double?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationTxtField.delegate = self
        linkTxtField.delegate = self
        
        
    }
    
    @IBAction func findLocationBtClicked(_ sender: Any) {
        
        locationTxtField.resignFirstResponder()
        linkTxtField.resignFirstResponder()
        
        guard let websiteLink = linkTxtField.text else {return}
        
        let prefixOfwebsiteLinkFirst = String(websiteLink.prefix(7))
        let prefixOfwebsiteLinkSecond = String(websiteLink.prefix(8))
        
        
        
        let rangeCheckBool = (websiteLink.range(of:"http://") == nil ) || (websiteLink.range(of:"https://") == nil )
        let prefixCheckBool = (prefixOfwebsiteLinkFirst == "http://") || (prefixOfwebsiteLinkSecond == "https://")
        
        if  rangeCheckBool  &&  !prefixCheckBool {
            
            HandelError.showAlert(title: "Error", message: "Please Insert A Valid URL...starts with http://", inViewController: self)
            
            
        } else {
            if locationTxtField.text != "" && linkTxtField.text != "" {
                
                loadingIndicator.startAnimating()
                
                let searchRequest = MKLocalSearch.Request()
                searchRequest.naturalLanguageQuery = locationTxtField.text
                
                let activeSearch = MKLocalSearch(request: searchRequest)
                
                activeSearch.start { (response, error) in
                    
                    if error != nil {
                        self.loadingIndicator.stopAnimating()
                        
                        HandelError.showAlert(title: "Error", message: "\(error?.localizedDescription ?? "")", inViewController: self)
                        
                    } else {
                        self.loadingIndicator.stopAnimating()
                        self.latitude = response?.boundingRegion.center.latitude
                        self.longitude = response?.boundingRegion.center.longitude
                        self.performSegue(withIdentifier: "confirmLocationSegue", sender: nil)
                    }
                }
                
            }else {
                
                HandelError.showAlert(title: "Error", message: "Fill All The Fields Please", inViewController: self)
                
            }
        }
    }
    
    @IBAction func cancelBtClicked(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "confirmLocationSegue" {
            
            let findLocation = segue.destination as! ConfirmLocationViewController
            
            let currentStudentLocation = StudentLocations(objectId: nil, uniqueKey: nil, firstName: nil, lastName: nil, mapString: locationTxtField.text, mediaURL: linkTxtField.text, latitude: latitude, longitude: longitude, createdAt: nil, updatedAt: nil)
            
            findLocation.passedStudentLocation = currentStudentLocation
            
        }
        
        
        
    }
}
