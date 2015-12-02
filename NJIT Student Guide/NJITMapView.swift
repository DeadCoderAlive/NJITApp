//
//  NJITMapView.swift
//  NJIT Student Guide
//
//  Created by Mac on 11/28/15.
//  Copyright © 2015 Fantastic4. All rights reserved.
//


import UIKit
import MapKit
import CoreLocation

class NJITMapView: UIViewController , MKMapViewDelegate,CLLocationManagerDelegate{

    
    @IBOutlet weak var myMap: MKMapView!
    var myRoute : MKRoute?
    let locationManager = CLLocationManager()
    var destLat : Double?
    var destLong : Double?
    var sourLat : Double?
    var sourLong : Double?
    var destLoc : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        
        
            }
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
        sourLat = locValue.latitude
        sourLong = locValue.longitude
        locationManager.stopUpdatingLocation()
        
        drawMapCoor()
    }
    
    func drawMapCoor()
    {
        let point1 = MKPointAnnotation()
        let point2 = MKPointAnnotation()
        point1.coordinate = CLLocationCoordinate2DMake(sourLat!,sourLong!)
        point1.title = "Your Location"
        myMap.addAnnotation(point1)
        
        point2.coordinate = CLLocationCoordinate2DMake(destLat!, destLong!)
        point2.title = destLoc
        myMap.addAnnotation(point2)
        myMap.centerCoordinate = point2.coordinate
        myMap.delegate = self
        
        
        //Span of the map
        myMap.setRegion(MKCoordinateRegionMake(point2.coordinate, MKCoordinateSpanMake(0.012,0.012)), animated: true)
        
        let directionsRequest = MKDirectionsRequest()
        let markTaipei = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point1.coordinate.latitude, point1.coordinate.longitude), addressDictionary: nil)
        let markChungli = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point2.coordinate.latitude, point2.coordinate.longitude), addressDictionary: nil)
        
        directionsRequest.source = MKMapItem(placemark: markChungli)
        directionsRequest.destination = MKMapItem(placemark: markTaipei)
        directionsRequest.transportType = MKDirectionsTransportType.Walking
        let directions = MKDirections(request: directionsRequest)
        directions.calculateDirectionsWithCompletionHandler( { (response,error) -> Void in
            if error == nil {
                self.myRoute = response!.routes[0]
                self.myMap.addOverlay((self.myRoute?.polyline)!)
            }
        })
    }
    
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let myLineRenderer = MKPolylineRenderer(polyline: (myRoute?.polyline)!)
        myLineRenderer.strokeColor = UIColor.orangeColor()
        myLineRenderer.lineWidth = 5
        return myLineRenderer
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
