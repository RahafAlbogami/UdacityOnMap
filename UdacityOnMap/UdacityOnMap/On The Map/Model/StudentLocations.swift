//
//  StudentLocations.swift
//  On The Map
//
//  Created by Rahaf on 6/14/19.
//  Copyright © 2019 Rahaf. All rights reserved.
//

import Foundation


struct Respones : Codable {
    
    let responses : [StudentLocations]?
}


struct StudentLocations : Codable {
    
    
    let objectId : String?
    let uniqueKey : String?
    let firstName : String?
    let lastName : String?
    let mapString : String?
    let mediaURL : String?
    let latitude : Double?
    let longitude : Double?
    let createdAt : String?
    let updatedAt : String?
    
    
}


