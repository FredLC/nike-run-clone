//
//  FirstViewController.swift
//  NikeRunClone
//
//  Created by Fred Lefevre on 2019-03-15.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import UIKit
import MapKit

class StartRunVC: LocationVC {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthStatus()
        mapView.delegate = self
        print("\(Run.getRuns())")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        manager?.startUpdatingLocation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        manager?.stopUpdatingLocation()
    }

    @IBAction func centerLocationButtonPressed(_ sender: Any) {
        
    }
    
}

extension StartRunVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            checkLocationAuthStatus()
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
        }
    }
}
