//
//  ConfirmLocationViewController.swift
//  On The Map
//
//  Created by Rahaf on 6/14/19.
//  Copyright © 2019 Rahaf. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ConfirmLocationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    var passedStudentLocation : StudentLocations?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createAnnotation()
    }
    
    @IBAction func confirmBtClicked(_ sender: Any) {
        
        APIsRequests.postStudentLocation(student: passedStudentLocation!, compeletion: handlPostStudentLocation(studentLocation:error:))
        
    }
    
    
    func handlPostStudentLocation(studentLocation: StudentLocations?,error:Error?){
        
        if error != nil {
            
            DispatchQueue.main.async {
                HandelError.showAlert(title: "Error", message: "Error Occured \(error?.localizedDescription ?? "" )", inViewController: self)
                
            }
            
        }
        
        DispatchQueue.main.async {
            
            if studentLocation == nil {
                
                HandelError.showAlert(title: "Error", message: "Error Occured", inViewController: self)
                self.navigationController?.popViewController(animated: true)
                
                
            } else {
                
                let alert = UIAlertController(title: "Done", message: "Location Added Sucssecfully", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                })
                
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            }
            
            
        }
        
    }
   
    
    
    func createAnnotation(){
        
        let annotation = MKPointAnnotation()
        annotation.title = passedStudentLocation?.mapString
        annotation.subtitle = passedStudentLocation?.mediaURL
        annotation.coordinate = CLLocationCoordinate2DMake((passedStudentLocation?.latitude)!, (passedStudentLocation?.longitude)!)
        mapView.addAnnotation(annotation)
        
        
        let coredinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake((passedStudentLocation?.latitude)!, (passedStudentLocation?.longitude)!)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coredinate, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    
}
