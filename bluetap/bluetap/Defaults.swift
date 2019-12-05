//
//  Defaults.swift
//  bluetap
//
//  Created by Nicha Thongtanakul on 4/12/19.
//  Copyright © 2019 Nicha Thongtanakul. All rights reserved.
//
import UIKit

struct Defaults {
    
    static let (nameKey, addressKey) = ("name", "address")
    static let userSessionKey = "com.save.usersession"
    private static let userDefault = UserDefaults.standard
    
    /**
     - Description -  It's using for the passing and fetching
     user values from the UserDefaults.
     */
    struct UserDetails {
        let name: String
        let address: String
        
        init(_ json: [String: String]) {
            self.name = json[nameKey] ?? ""
            self.address = json[addressKey] ?? ""
        }
    }
    
    /**
     - Description - Saving user details
     - Inputs - name `String` & address `String`
     */
    static func save(_ name: String, address: String){
        userDefault.set([nameKey: name, addressKey: address],
                        forKey: userSessionKey)
    }
    
    /**
     - Description - Fetching Values via Model `UserDetails` you can use it based on your uses.
     - Output - `UserDetails` model
     */
    static func getNameAndAddress()-> UserDetails {
        return UserDetails((userDefault.value(forKey: userSessionKey) as? [String: String]) ?? [:])
    }
    
    /**
     - Description - Clearing user details for the user key `com.save.usersession`
     */
    static func clearUserData(){
        userDefault.removeObject(forKey: userSessionKey)
    }
}
