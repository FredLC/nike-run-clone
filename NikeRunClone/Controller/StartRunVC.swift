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
    @IBOutlet weak var lastRunView: UIView!
    @IBOutlet weak var lastRunStackView: UIStackView!
    @IBOutlet weak var lastRunCloseButton: UIButton!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthStatus()
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        manager?.startUpdatingLocation()
        getLastRun()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        manager?.stopUpdatingLocation()
    }
    
    func getLastRun() {
        guard let lastRun = Run.getRuns()?.first else {
            lastRunView.isHidden = true
            lastRunStackView.isHidden = true
            lastRunCloseButton.isHidden = true
            return
        }
        lastRunView.isHidden = false
        lastRunStackView.isHidden = false
        lastRunCloseButton.isHidden = false
        
        paceLabel.text = lastRun.pace.formatTimeDurationToString()
        distanceLabel.text = "\(lastRun.distance.convertMetersToMiles(places: 2))"
        durationLabel.text = lastRun.duration.formatTimeDurationToString()
    }

    @IBAction func centerLocationButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func lastRunCloseButtonPressed(_ sender: Any) {
        lastRunView.isHidden = true
        lastRunStackView.isHidden = true
        lastRunCloseButton.isHidden = true
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
