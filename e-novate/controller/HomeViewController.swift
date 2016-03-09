//
//  HomeViewController.swift
//  e-novate
//
//  Created by paraline on 3/7/16.
//  Copyright © 2016 paraline. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class HomeViewController: BaseViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapview: MKMapView!
    let locationManager = CLLocationManager();

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: false);
        
        // 1
        locationManager.delegate = self;
        // 2
        locationManager.requestAlwaysAuthorization();
        // 3
        locationManager.startUpdatingLocation();
        
        self.mapview.delegate = self;
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didBecomeActive", name: UIApplicationDidBecomeActiveNotification, object: nil);
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didEnterBackground", name: UIApplicationDidEnterBackgroundNotification, object: nil);
        
        Utils.zoomToUserLocationInMapView(self.mapview);

    }
    
    func didBecomeActive(){
        NSLog("didBecomeActive");
        locationManager.startUpdatingLocation();
    }
    
    func didEnterBackground(){
        NSLog("didEnterBackground");
        locationManager.stopUpdatingLocation()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        NSLog("viewWillAppear");
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated);
        NSLog("viewWillDisappear");
    }
    
    
    // MARK: CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation;
        print("didUpdateLocations lat:\(location.coordinate.latitude) lon:\(location.coordinate.longitude) distance:\(location.altitude)m");
        
        var distance : Double = 500.0;
        var index : Int = -1;
        
        for (var i = 0; i < LOCATION_LIST.count; i++) {
            let d = location.distanceFromLocation(LOCATION_LIST[i]);
            if( d < distance ){
                distance = d;
                index = i;
            }
        }
        
        if(distance < 500 && index != -1){
            if(!Utils.isAnswer(KEY_QUESTION_LIST[index])){
                Utils.showSimpleAlertWithTitle("Question", message: QUESTION_LIST[index], viewController: self);
                Utils.setAnswer(KEY_QUESTION_LIST[index], value: true);
            }
            
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("didChangeAuthorizationStatus \(status.rawValue)");
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("didFailWithError "+error.description);
    }
    
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        print("didStartMonitoringForRegion \(region)");
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("didEnterRegion \(region)");
    }
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("monitoringDidFailForRegion \(region)")
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("didExitRegion \(region)")
    }
    
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        print("didDetermineState state:\(state.rawValue)  region:\(region)");
    }
    
    // MARK: MKMapViewDelegate
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        NSLog("rendererForOverlay");
        let draw = MKPolylineRenderer(overlay: overlay)
        draw.strokeColor = UIColor.redColor()
        draw.lineWidth = 3.0
        return draw
    }

}
