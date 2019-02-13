//
//  SaveData.swift
//  MyTravels
//
//  Created by Maurício Oliveira on 13/02/2019.
//  Copyright © 2019 Maurício Oliveira. All rights reserved.
//

import UIKit

class SaveData {
    
    let key = "locals"
    var travels: [Dictionary<String,String>] = []
    
    func getDefaults () -> UserDefaults {
        return UserDefaults.standard
    }
    
    func saveTravel (travel : Dictionary<String,String>) {
        travels = listTravels()
        travels.append(travel)
        
        getDefaults().set(travels, forKey: key)
        getDefaults().synchronize()
    }
    
    func listTravels () -> [Dictionary<String,String>] {
        let data = getDefaults().object(forKey: key)
        
        if data != nil {
            return data as! [Dictionary<String, String>]
        } else {
            return []
        }
    }
    
    func removeTravel(index: Int) {
        travels = listTravels()
        
        travels.remove(at: index)
        
        getDefaults().set(travels, forKey: key)
        getDefaults().synchronize()
    }
    
}
