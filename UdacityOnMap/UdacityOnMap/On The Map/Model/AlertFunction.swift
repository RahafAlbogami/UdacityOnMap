//
//  AlertFunction.swift
//  On The Map
//
//  Created by Rahaf on 6/14/19.
//  Copyright © 2019 Rahaf. All rights reserved.
//

import Foundation
import UIKit

class HandelError {
    
    class func showAlert(title: String, message: String, inViewController: UIViewController){
        
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(ok)
        inViewController.present(alert, animated: true, completion: nil)
        
    }
    
    
    
}
