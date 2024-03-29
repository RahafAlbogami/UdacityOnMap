//
//  UdacityResponesesStructs.swift
//  On The Map
//
//  Created by Rahaf on 6/14/19.
//  Copyright © 2019 Rahaf. All rights reserved.
//

import Foundation


struct loginRespons: Codable {
    
    let account: Account
    let session: Session
    
    
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration:String
}
