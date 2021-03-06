//
//  Station.swift
//  NJIT Student Guide
//
//  Created by Ishani Chatterjee on 11/5/15.
//  Copyright © 2015 Fantastic4. All rights reserved.
//

import MapKit

class Station: NSObject, MKAnnotation {
    var title: String?
    var latitude: Double
    var longitude:Double
    var type : String
    var img : UIImage?
    var BSU : String
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double,title: String,type: String,BSU: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.title = title
        self.type = type
        self.BSU = BSU
    }
    
    var subtitle: String?{
        return type
    }
    
    var image : UIImage?{
        return img
    }
    
    /*func pinColor()-> MKPinAnnotationColor{
    switch type{
    case "bus":
    return .Green
    // case "stop":
    //return .Red
    default:
    return .Purple
    }
    }*/
}

