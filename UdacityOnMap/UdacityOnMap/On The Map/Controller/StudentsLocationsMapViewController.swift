//
//  StudentsLocationsMapViewController.swift
//  On The Map
//
//  Created by Rahaf on 6/14/19.
//  Copyright © 2019 Rahaf. All rights reserved.
//

import UIKit
import MapKit


var globalStudentsLocations : [StudentLocations]?

class StudentsLocationsMapViewController: UIViewController {
    
    
    
    @IBOutlet weak var mapView: MKMapView!
    var annotations = [MKPointAnnotation]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        APIsRequests.getStudentsLocations(compeletion: handleStudentsLocationsResponse(students:))
        
    }
    
    
    func handleStudentsLocationsResponse(students: [StudentLocations]? ){
        
        guard let students = students else { return }
        
        globalStudentsLocations = students
        
        DispatchQueue.main.async {
            
            for student in students{
                self.addAnnotationFor(student: student)
            }
            
            
        }
        
    }
    
    
    func handleLogoutResponse(success:Bool?,key:String?,error:Error?){
        
        DispatchQueue.main.async {
            
            if error != nil {
                HandelError.showAlert(title: "Error", message: "Error Occured While Logging Out \(error!.localizedDescription)", inViewController: self)
                return
            }else if success == false {
                HandelError.showAlert(title: "Error", message: "Error Occured While Logging Out", inViewController: self)
            } else {
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    
    
    func addAnnotationFor(student: StudentLocations){
        
        let lat = student.latitude
        let long = student.longitude
        
        let coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
        
        let first = student.firstName
        let last = student.lastName
        let mediaURL = student.mediaURL
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(first!) \(last!)"
        annotation.subtitle = mediaURL
        
        annotations.append(annotation)
        
        mapView.addAnnotations(annotations)
        
        
    }
    
    
    
    
    @IBAction func logOutBtClicked(_ sender: Any) {
        
        APIsRequests.deleteSession(compeletion: handleLogoutResponse(success:key:error:))
        
    }
    
    @IBAction func refreshBtClicked(_ sender: Any) {
        
        APIsRequests.getStudentsLocations(compeletion: handleStudentsLocationsResponse(students:))

    }
    
    @IBAction func addLocationBtClicked(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "AddLocationViewController", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AddLocationViewController")
        self.present(controller, animated: true, completion: nil)
        
    }
    
    
    
}


