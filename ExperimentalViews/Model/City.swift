//
//  City.swift
//  ExperimentalViews
//
//  Created by Wesley Matlock on 9/26/16.
//  Copyright © 2016 net.insoc. All rights reserved.
//

import Foundation

class City {
    
    var name: String
    var annotation: String
    var image: String
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    init(name: String!, image: String = "", annotation: String!, latitude: Double, longitude: Double) {
        
        self.name = name
        self.annotation = annotation
        self.image = image
        self.latitude = latitude
        self.longitude = longitude
    }
}
