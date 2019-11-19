//
//  Extensions.swift
//  On The Map
//
//  Created by Rahaf on 6/14/19.
//  Copyright © 2019 Rahaf. All rights reserved.
//

import Foundation
import MapKit


extension StudentsLocationsMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
}




extension StudentsLocationsTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if globalStudentsLocations != nil {
            
            return globalStudentsLocations!.count
            
        } else {
            
            return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "studentLocationCell")
        
        let currentStudentLocation = globalStudentsLocations?[indexPath.row]
        if  currentStudentLocation != nil {
            cell.textLabel?.text = "\(currentStudentLocation?.firstName ?? "" ) \(currentStudentLocation?.lastName ?? "" )"
            cell.detailTextLabel?.text = currentStudentLocation?.mediaURL
            
            cell.imageView?.image = #imageLiteral(resourceName: "icon_pin")
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        let app = UIApplication.shared
        if let url = NSURL(string: (cell?.detailTextLabel!.text)!) {
            let canOpen = UIApplication.shared.canOpenURL(url as URL)
            if canOpen {
                app.openURL(URL(string: (cell?.detailTextLabel!.text)!)!)
            }
            else {
                return
            }
        }

    }
    
    
}


extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
}

extension AddLocationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
