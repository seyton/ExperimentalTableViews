//
//  State.swift
//  ExperimentalViews
//
//  Created by Wesley Matlock on 9/26/16.
//  Copyright © 2016 net.insoc. All rights reserved.
//

import Foundation

class State {
    
    var name: String
    var cities: [City]
    
    init(name: String, cities: [City]) {
        
        self.name = name
        self.cities = cities
    }
}
