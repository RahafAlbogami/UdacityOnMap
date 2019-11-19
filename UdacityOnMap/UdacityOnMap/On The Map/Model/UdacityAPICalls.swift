//
//  UdacityAPICalls.swift
//  On The Map
//
//  Created by Rahaf on 6/14/19.
//  Copyright © 2019 Rahaf. All rights reserved.
//

import Foundation


class APIsRequests {
    
    
    enum EndPoits {
        
        case allStudentsLocations
        case postStudentLocation
        case session
        case getUserDate(String)
        
        
        var stringValue : String {
            
            switch self {
                
            case .allStudentsLocations: return "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order=-updatedAt"
            case .postStudentLocation: return "https://onthemap-api.udacity.com/v1/StudentLocation"
            case .session: return "https://onthemap-api.udacity.com/v1/session"
            case .getUserDate(let userID): return "https://onthemap-api.udacity.com/v1/users/\(userID)"
            }
        }
        
        var url : URL {
            return URL(string: stringValue)!
        }
    }
    
    
    
    class func getStudentsLocations(compeletion: @escaping ([StudentLocations]?) ->()){
        
        
        var request = URLRequest(url: EndPoits.allStudentsLocations.url)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                return
            }
            
            print(String(data: data!, encoding: .utf8)!)
            let dictionary = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
            let results = dictionary["results"] as! [[String: Any]]
            let dataFormResults = try! JSONSerialization.data(withJSONObject: results, options: [])
            let studentsLocations = try! JSONDecoder().decode([StudentLocations].self, from: dataFormResults)
            compeletion(studentsLocations)
            
        }
        task.resume()
        
    }
    
    
    class func postStudentLocation(student : StudentLocations, compeletion: @escaping (StudentLocations?, Error?)->()){
        
        var request = URLRequest(url: EndPoits.postStudentLocation.url)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(student.uniqueKey ?? "")\", \"firstName\": \"\(student.firstName ?? "MOAYAD")\", \"lastName\": \"\(student.lastName ?? "Makhdom")\",\"mapString\": \"\(student.mapString ?? "")\", \"mediaURL\": \"\(student.mediaURL ?? "")\",\"latitude\": \(student.latitude ?? 0.0 ), \"longitude\": \(student.longitude ?? 0.0 )}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                compeletion(nil,error)
                return
            }
            print(String(data: data!, encoding: .utf8)!)
            
            let result = try! JSONDecoder().decode(StudentLocations.self, from: data!)
            compeletion(result,nil)
        }
        task.resume()
        
    }
    
    
    
    class func getSessionID(userName:String, password:String, compeletion: @escaping (_ success:Bool?, _ data:Data?, _ error:Error?)->()){
        
        var request = URLRequest(url: EndPoits.session.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(userName)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                
                compeletion(false,nil,error)
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            print(String(data: newData!, encoding: .utf8)!)
            
            compeletion(true,newData,nil)
        }
        task.resume()
    }
    
    class func deleteSession(compeletion: @escaping (_ success:Bool?,_ key:String?,_  error:Error?)->()){
        
        
        var request = URLRequest(url: EndPoits.session.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                compeletion(nil, nil, error)
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            print(String(data: newData!, encoding: .utf8)!)
            
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                let error = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                compeletion(false, "", error)
                return
            }
            if statusCode >= 200  && statusCode < 300 {
                
                
                let range = 5..<data!.count
                let newData = data?.subdata(in: range)
                
                
                print (String(data: newData!, encoding: .utf8)!)
                
                let json = try! JSONSerialization.jsonObject(with: newData!, options: []) as? [String : Any]
                
                
                let accountDictionary = json? ["account"] as? [String : Any]
                let uniqueKey = accountDictionary? ["key"] as? String ?? " "
                compeletion(true, uniqueKey, nil)
            } else {
                compeletion(false, "", nil)
            }
            
            
            
        }
        task.resume()
        
    }
    
    class func getUserData(userID : String){
        
        
        let request = URLRequest(url: EndPoits.getUserDate(userID).url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
        
    }
    
}
