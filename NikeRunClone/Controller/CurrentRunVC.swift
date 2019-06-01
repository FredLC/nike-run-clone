//
//  CurrentRunVC.swift
//  NikeRunClone
//
//  Created by Fred Lefevre on 2019-03-15.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import UIKit
import MapKit

class CurrentRunVC: LocationVC {

    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var sliderBackground: UIImageView!
    @IBOutlet weak var sliderImageVIew: UIImageView!
    
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var runDistance = 0.0
    var counter = 0
    var pace = 0
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(endRunSwiped(sender:)))
        sliderImageVIew.addGestureRecognizer(swipeGesture)
        sliderImageVIew.isUserInteractionEnabled = true
        swipeGesture.delegate = self as? UIGestureRecognizerDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        manager?.distanceFilter = 10
        startRun()
    }
    
    func startRun() {
        manager?.startUpdatingLocation()
        startTimer()
        pauseButton.setImage(#imageLiteral(resourceName: "pauseButton"), for: .normal)
    }
    
    func pauseRun() {
        startLocation = nil
        lastLocation = nil
        timer.invalidate()
        manager?.stopUpdatingLocation()
        pauseButton.setImage(#imageLiteral(resourceName: "resumeButton"), for: .normal)
    }
    
    func endRun() {
        manager?.stopUpdatingLocation()
        Run.addRunToRealm(pace: pace, distance: runDistance, duration: counter)
    }
    
    func startTimer() {
        durationLabel.text = counter.formatTimeDurationToString()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter() {
        counter += 1
        durationLabel.text = counter.formatTimeDurationToString()
    }
    
    func calculatePace(time seconds: Int, miles: Double) -> String {
        pace = Int(Double(seconds) / miles)
        return pace.formatTimeDurationToString()
    }
    
    @IBAction func pauseButtonPressed(_ sender: Any) {
        if timer.isValid {
            pauseRun()
        } else {
            startRun()
        }
    }
    
    @objc func endRunSwiped(sender: UIPanGestureRecognizer) {
        let minAdjust: CGFloat = 80
        let maxAdjust: CGFloat = 130
        if let sliderView = sender.view {
            if sender.state == UIGestureRecognizer.State.began || sender.state == UIGestureRecognizer.State.changed {
                let translation = sender.translation(in: self.view)
                if sliderView.center.x >= (sliderBackground.center.x - minAdjust) && sliderView.center.x <= (sliderBackground.center.x + maxAdjust) {
                    sliderView.center.x = sliderView.center.x + translation.x
                } else if sliderView.center.x >= (sliderBackground.center.x + maxAdjust) {
                    sliderView.center.x = sliderBackground.center.x + maxAdjust
                    endRun()
                    dismiss(animated: true, completion: nil)
                } else {
                    sliderView.center.x = sliderBackground.center.x - minAdjust
                }
                sender.setTranslation(CGPoint.zero, in: self.view)
            } else if sender.state == UIGestureRecognizer.State.ended {
                UIView.animate(withDuration: 0.1) {
                    sliderView.center.x = self.sliderBackground.center.x - minAdjust
                }
            }
        }
    }

}

extension CurrentRunVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            checkLocationAuthStatus()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if startLocation == nil {
            startLocation = locations.first
        } else if let location = locations.last {
            runDistance += lastLocation.distance(from: location)
            let runDistanceMiles = runDistance * 0.000621371
            let runDistanceRounded = round(100*runDistanceMiles)/100
            distanceLabel.text = "\(runDistanceRounded)"
            if counter > 0 && runDistanceRounded > 0 {
                paceLabel.text = calculatePace(time: counter, miles: runDistanceRounded)
            }
        }
        lastLocation = locations.last
    }
}
