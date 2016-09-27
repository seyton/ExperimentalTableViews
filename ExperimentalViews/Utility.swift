//
//  Utility.swift
//  ExperimentalViews
//
//  Created by Wesley Matlock on 9/26/16.
//  Copyright © 2016 net.insoc. All rights reserved.
//

import UIKit

class Utility {
    
    class func loadJsonData(_ fileName: String, withExtension ext: String) -> [State] {
        
        let url = Bundle.main.url(forResource: fileName, withExtension: ext)
        let data = try? Data(contentsOf: url!)
        
        let json = JSON(data: data!)

        var states = [State]()
        
        for index in 0..<json.count {
            
            let state = json[index]["State"].stringValue
            var cities = [City]()
            
            let cityData = json[index]["Cities"].arrayValue
            for item in 0..<cityData.count {
               
                let cityName = cityData[item]["Name"].stringValue
                let longitude = cityData[item]["Longitude"].doubleValue
                let latitude = cityData[item]["Latitude"].doubleValue
                let image = cityData[item]["Image"].stringValue
                let annotation = cityData[item]["Annotation"].stringValue
                
                cities.append(City(name: cityName, image: image, annotation: annotation, latitude: latitude, longitude: longitude))
            }
            
            states.append(State(name: state, cities: cities))
        }
        
        return states
    }
}
