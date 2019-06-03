//
//  FirstViewController.swift
//  NikeRunClone
//
//  Created by Fred Lefevre on 2019-03-15.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        mapView.delegate = self
        manager?.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupMapView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        manager?.stopUpdatingLocation()
    }
    
    func setupMapView() {
        if let overlay = addLastRunToMap() {
            if mapView.overlays.count > 0 {
                mapView.removeOverlays(mapView.overlays)
            }
            mapView.addOverlay(overlay)
            lastRunView.isHidden = false
            lastRunStackView.isHidden = false
            lastRunCloseButton.isHidden = false
        } else {
            lastRunView.isHidden = true
            lastRunStackView.isHidden = true
            lastRunCloseButton.isHidden = true
            centerMapOnUserLocation()
        }
    }
    
    func addLastRunToMap() -> MKPolyline? {
        guard let lastRun = Run.getRuns()?.first else { return nil }
        paceLabel.text = lastRun.pace.formatTimeDurationToString()
        distanceLabel.text = "\(lastRun.distance.convertMetersToMiles(places: 2))"
        durationLabel.text = lastRun.duration.formatTimeDurationToString()
        
        var coordinates = [CLLocationCoordinate2D]()
        for location in lastRun.locations {
            coordinates.append(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        }
        
        mapView.userTrackingMode = .none
        mapView.setRegion(centerMapOnPreviousRoute(locations: lastRun.locations), animated: true)
        
        return MKPolyline(coordinates: coordinates, count: lastRun.locations.count)
    }
    
    func centerMapOnUserLocation() {
        mapView.userTrackingMode = .follow
        let coordinateRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func centerMapOnPreviousRoute(locations: List<Location>) -> MKCoordinateRegion {
        guard let initialLocation = locations.first else { return MKCoordinateRegion() }
        var minLat = initialLocation.latitude
        var minLong = initialLocation.longitude
        var maxLat = minLat
        var maxLong = minLong
        
        for location in locations {
            minLat = min(minLat, location.latitude)
            minLong = min(minLong, location.longitude)
            maxLat = max(maxLat, location.latitude)
            maxLong = max(maxLong, location.longitude)
        }
        
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLong + maxLong) / 2), span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.4, longitudeDelta: (maxLong - minLong) * 1.4))
    }

    @IBAction func centerLocationButtonPressed(_ sender: Any) {
        centerMapOnUserLocation()
    }
    
    @IBAction func lastRunCloseButtonPressed(_ sender: Any) {
        lastRunView.isHidden = true
        lastRunStackView.isHidden = true
        lastRunCloseButton.isHidden = true
        centerMapOnUserLocation()
    }
}

extension StartRunVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            checkLocationAuthStatus()
            mapView.showsUserLocation = true
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        renderer.lineWidth = 4
        return renderer
    }
}
