//
//  UserDefault.swift
//  CodeBase2
//
//  Created by Yogesh2 Gupta on 24/11/20.
//

import UIKit

class UserDefault: NSObject {
    static let shareInstance : UserDefault = UserDefault()
    
    private override init() {
        super.init()
    }
     
    func saveData(_ isEnable : Bool, key : String) {
        UserDefaults.standard.set(isEnable, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func getDataForKey(_ key :String) -> Bool {
        UserDefaults.standard.bool(forKey: key)
    }
}
