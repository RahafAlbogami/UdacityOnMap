//
//  ViewController.swift
//  On The Map
//
//  Created by Rahaf on 6/14/19.
//  Copyright © 2019 Rahaf. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController {

    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var logInBt: UIButton!
    @IBOutlet weak var loadingIndecator: UIActivityIndicatorView!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTxtField.delegate = self
        passwordTxtField.delegate = self
        
    }

    @IBAction func logInBtClicked(_ sender: Any) {
        
        loadingIndecator.startAnimating()
        APIsRequests.getSessionID(userName: emailTxtField.text! , password: passwordTxtField.text!, compeletion: handlLoginResponse(success:data:error:))
        
    }
    
    @IBAction func signUpBtClicked(_ sender: Any) {
        
        let safariViewController = SFSafariViewController(url: URL(string: "https://auth.udacity.com/sign-up")!)
        present(safariViewController, animated: true, completion: nil)
        
    }
    
    
    func handlLoginResponse(success:Bool?, data:Data?, error:Error?){
        
        DispatchQueue.main.async {
            
            self.loadingIndecator.stopAnimating()
            
            if error != nil {
                HandelError.showAlert(title: "ERROR", message: "\(error?.localizedDescription ?? "" )", inViewController: self)
                return }
            if !success! {
                HandelError.showAlert(title: "error", message: "No Connection", inViewController: self)
                return
            }
            
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            do {
                let respons = try decoder.decode(loginRespons.self, from: data)
                
                if respons.account.registered {
                    
                    self.performSegue(withIdentifier: "viewLocationsSegue", sender: self)
                    
                } else {
                    HandelError.showAlert(title: "Error", message: "Wronge UserName Or Password", inViewController: self)
                    
                }
                
                print("data \(respons)")
                
            } catch {
                HandelError.showAlert(title: "Error", message: "Wrong Input", inViewController: self)
                print("could not find respons ") }
        }
    }
    
    
    
}

