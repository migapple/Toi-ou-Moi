//
//  Setup.swift
//  Toi ou Moi
//
//  Created by Michel Garlandat on 11/06/2019.
//  Copyright © 2019 Michel Garlandat. All rights reserved.
//

import Foundation

class Activite {
    var toi: String?
    var moi: String?
    var activites: [String]?
    
    init(toi:String,moi:String,activites:[String]) {
        self.toi = "toi"
        self.moi = "moi"
        self.activites![0] = "Restau"
        self.activites?[1] = "Courses"
        self.activites![3] = "Essence"
    }
}

func readSetUp() {
    
    UserDefaults.standard.register(defaults: [String : Any]())
    let userDefaults = UserDefaults.standard
    
    let activite = Activite(toi: "", moi: "", activites: [])
    
    // Set the controls to the default values.
    for index in 0...5 {
        let lactivite = "activite_\(index)"
        if let activiteSetup = userDefaults.string(forKey: lactivite) {
            activite.activites!.append(activiteSetup)
            //activite!.activites.append(activiteSetup)
        }
    }
}

func initSetup() {
    
    UserDefaults.standard.register(defaults: [String : Any]())
    let userDefaults = UserDefaults.standard
    
    let activites = Activite(toi: "Toi", moi: "Moi", activites: ["Restau","Courses","Essence"])
    
    userDefaults.set(activites.toi, forKey: "toi_0")
    userDefaults.set(activites.moi, forKey: "moi_0")
    
    for index in 0...5 {
        let lactivite = "activite_\(index)"
        userDefaults.setValue(activites.activites![index], forKey: lactivite)
    }
}
