//
//  CityMapViewController.swift
//  ExperimentalViews
//
//  Created by Wesley Matlock on 9/27/16.
//  Copyright © 2016 net.insoc. All rights reserved.
//

import UIKit
import MapKit

class CityMapViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var mapView: MKMapView!
    
    fileprivate var newLocation = CLLocationCoordinate2D()
    
    var currentCity: City?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let currentCity = currentCity {
            navigationBar.topItem?.title = currentCity.annotation
            renderMap(currentCity.name, subTitle: currentCity.annotation, latitude: currentCity.latitude, longitude: currentCity.longitude)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: - MKMapView Delegates
extension CityMapViewController: MKMapViewDelegate {
    
    func renderMap(_ title: String, subTitle: String, latitude: Double, longitude: Double) {
        
        newLocation.latitude = latitude
        newLocation.longitude = longitude
        
        let coordSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let coordRegion = MKCoordinateRegion(center: newLocation, span: coordSpan)
        
        mapView.setRegion(coordRegion, animated: true)
        
        let point = MKPointAnnotation()
        point.coordinate = newLocation
        point.title = title
        point.subtitle = subTitle
        mapView.addAnnotation(point)
        mapView.selectAnnotation(point, animated: true)
    }
}
