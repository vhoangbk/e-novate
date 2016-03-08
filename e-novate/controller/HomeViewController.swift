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
//        locationManager.startUpdatingLocation();
        
        self.mapview.delegate = self;
        
        let region = MKCoordinateRegionMakeWithDistance(BACK_KHOA.coordinate, 1000, 1000)
        self.mapview.setRegion(region, animated: true)
        
//        let vanmieu = CLLocationCoordinate2D(latitude: 21.028450, longitude: 105.835910);
      
//        let reggion = CLCircularRegion(center: vanmieu, radius: 500, identifier: "vanmieu");
        
//        locationManager.startMonitoringForRegion(reggion);
//        locationManager.requestStateForRegion(reggion)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didBecomeActive", name: UIApplicationDidBecomeActiveNotification, object: nil);
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didEnterBackground", name: UIApplicationDidEnterBackgroundNotification, object: nil);
        
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: VAN_MIEU.coordinate.latitude, longitude: VAN_MIEU.coordinate.longitude), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: BACK_KHOA.coordinate.longitude, longitude: BACK_KHOA.coordinate.longitude), addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = MKDirectionsTransportType.Automobile
        
        let directions = MKDirections(request: request)
        
//        directions.calculateDirectionsWithCompletionHandler { [unowned self] response, error in
//            guard let unwrappedResponse = response else { return }
//            
//            for route in unwrappedResponse.routes {
//                self.mapview.addOverlay(route.polyline)
//                self.mapview.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
//            }
//        }
        

        directions.calculateDirectionsWithCompletionHandler { (response, error) -> Void in
            if error == nil {
                for route in response!.routes {
                    self.mapview.addOverlay(route.polyline)
                    self.mapview.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                }
            }
        }
        
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
        
//        Utils.zoomToUserLocationInMapView(self.mapview);
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("didChangeAuthorizationStatus \(status.rawValue)");
//        mapview.showsUserLocation = (status == .AuthorizedAlways)
//        Utils.zoomToUserLocationInMapView(self.mapview);
        
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
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blueColor()
        return renderer
    }

}
