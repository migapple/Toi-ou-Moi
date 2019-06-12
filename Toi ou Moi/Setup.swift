//
//  Setup.swift
//  Toi ou Moi
//
//  Created by Michel Garlandat on 11/06/2019.
//  Copyright © 2019 Michel Garlandat. All rights reserved.
//

import Foundation

func readSetUp() {
    
    var activites: [String] = []
    
    UserDefaults.standard.register(defaults: [String : Any]())
    let userDefaults = UserDefaults.standard
    let moi = userDefaults.string(forKey: "moi_0")
    let toi = userDefaults.string(forKey: "toi_0")
    print(toi)
    print(moi)
    
    // Set the controls to the default values.
    for index in 0...5 {
        let lactivite = "activite_\(index)"
        if let activiteSetup = userDefaults.string(forKey: lactivite) {
            activites.append(activiteSetup)
            print(activites[index])
        }
    }
}
