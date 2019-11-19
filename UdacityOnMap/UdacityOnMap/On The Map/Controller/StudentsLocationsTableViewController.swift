//
//  StudentsLocationsTableViewController.swift
//  On The Map
//
//  Created by Rahaf on 6/14/19.
//  Copyright © 2019 Rahaf. All rights reserved.
//

import Foundation
import UIKit

class StudentsLocationsTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.reloadData()
        
    }
    
    
    func handleStudentsLocationsResponse(students: [StudentLocations]? ){
        
        guard let students = students else { return }
        globalStudentsLocations = students
        
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
            self.scrollToTop()
            
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
    
    
    func scrollToTop() {
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
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


