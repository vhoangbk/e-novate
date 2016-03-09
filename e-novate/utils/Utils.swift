//
//  Utils.swift
//  e-novate
//
//  Created by paraline on 3/7/16.
//  Copyright © 2016 paraline. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Utils{

    class func showSimpleAlertWithTitle(title: String!, message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(action)
        viewController.presentViewController(alert, animated: true, completion: nil)
    }

    class func zoomToUserLocationInMapView(mapView: MKMapView) {
        if let coordinate = mapView.userLocation.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    class func setAnswer(key : String, value : Bool){
        NSUserDefaults.standardUserDefaults().setBool(value, forKey: key);
    }
    
    class func isAnswer(key : String) -> Bool{
        let obj : Bool = NSUserDefaults.standardUserDefaults().boolForKey(key);
        return obj != false;
    }
    
    class func zoomToCoordinate( centerCoordinate : CLLocationCoordinate2D, mapView : MKMapView) {
        let region = MKCoordinateRegionMakeWithDistance(centerCoordinate, 1000, 1000)
        mapView.setRegion(region, animated: true)
    }
    
    class func zoomToCoordinate( lat : Double, lon : Double, mapView : MKMapView) {
        let region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: lat, longitude: lon), 1000, 1000)
        mapView.setRegion(region, animated: true)
    }
    
    class func addPin(coordinate : CLLocationCoordinate2D, title : String, subTitle : String, mapView: MKMapView) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate;
        annotation.title = title;
        annotation.subtitle = subTitle;
        mapView.addAnnotation(annotation);
    }
    
    class func showDirections(source : CLLocationCoordinate2D, destination : CLLocationCoordinate2D, mapView : MKMapView){
        let request = MKDirectionsRequest()
        
        //soucre
        var sourceItem : MKMapItem = MKMapItem()
        let placeMarkSource = MKPlacemark(coordinate: source, addressDictionary: nil)
        sourceItem = MKMapItem(placemark: placeMarkSource);
        request.source = sourceItem;
        
        //destination
        var destinationItem : MKMapItem = MKMapItem()
        let placeMarkDestination = MKPlacemark(coordinate: destination, addressDictionary: nil)
        destinationItem = MKMapItem(placemark: placeMarkDestination);
        request.destination = destinationItem;
        
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        
        directions.calculateDirectionsWithCompletionHandler { (response, error) -> Void in
            if error != nil {
                print("Error \(error)")
            } else {
                let overlays = mapView.overlays
                mapView.removeOverlays(overlays)
                
                for route in response!.routes {
                    
                    mapView.addOverlay(route.polyline,
                        level: MKOverlayLevel.AboveRoads)
                    
                    for next  in route.steps {
                        print(next.instructions)
                    }
                }
                
                
            }
        }

    }


}