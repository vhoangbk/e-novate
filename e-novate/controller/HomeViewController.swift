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


class HomeViewController: BaseViewController, CLLocationManagerDelegate {
    
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
//        locationManager.startUpdatingLocation();
        
//        let vanmieu = CLLocationCoordinate2D(latitude: 21.028450, longitude: 105.835910);
      
//        let reggion = CLCircularRegion(center: vanmieu, radius: 500, identifier: "vanmieu");
        
//        locationManager.startMonitoringForRegion(reggion);
//        locationManager.requestStateForRegion(reggion)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        locationManager.startUpdatingLocation();
    }
    
    override func viewWillDisappear(animated: Bool) {
        locationManager.stopUpdatingLocation()
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
                Utils.zoomToUserLocationInMapView(mapview);
            }
            
        }
        
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("didChangeAuthorizationStatus \(status.rawValue)");
        mapview.showsUserLocation = (status == .AuthorizedAlways)
        
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

}
