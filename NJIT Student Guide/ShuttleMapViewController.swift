import UIKit
import MapKit

class ShuttleMapViewController: UIViewController, MKMapViewDelegate, NSXMLParserDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var myMap: MKMapView!
    var buslat = [Double]()
    var buslon = [Double]()
    
    var mapSelect: String = String()
    var pin = String()
    var timer: NSTimer? = nil
    
    var parser:NSXMLParser = NSXMLParser()
    var parse2:NSXMLParser = NSXMLParser()
    
    var ename : String = String()
    var routeTitle = String()
    var routeTag = String()
    var stopTitle = String()
    var stopLat = Double()
    var stopLon = Double()
    
    var stopTitleArr = [String]()
    var stopLatArr = [Double]()
    var stopLonArr = [Double]()
    
    var pointLat = Double()
    var pointLon = Double()
    var pathBool = false
    var dirBool = false
    var retLon = [Double]()
    var retLat = [Double]()
    

    var selectedLat = Double()
    var selectedLon = Double()

    
    var busAnnotation = [Station]()
    var busOrstop : Bool = false
    
    
    override func viewDidLoad() {
        myMap.delegate = self
        
        setUserPin()
        zoomToRegion()
        
        getLatLon(mapSelect)
        let annotation = getAnnotationStop(stopLatArr, lon: stopLonArr, tit: stopTitleArr)
       // print("\(stopTitleArr))")
        myMap.addAnnotations(annotation)
        
        let PostButton : UIBarButtonItem = UIBarButtonItem(title: "Get Direction", style: UIBarButtonItemStyle.Plain, target: self, action:Selector("popToPost:"))
        
        
        self.navigationItem.rightBarButtonItem = PostButton
        
        //setUserPin()
        super.viewDidLoad()
        startTimer()
    }
    
    override func viewDidDisappear(animated: Bool) {
        timer?.invalidate()
    }
    let locationManager = CLLocationManager()
    var sourLat = Double()
    var sourLong = Double()

    func setUserPin(){
        locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            print("Authenticated")
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    var cnt = 0
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if cnt == 0
        {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        sourLat = locValue.latitude
        sourLong = locValue.longitude
        locationManager.stopUpdatingLocation()
        
        //let point1 = MKPointAnnotation()
        //point1.coordinate = CLLocationCoordinate2DMake(sourLat!,sourLong!)
        //point1.title = "Your Are Here"
        let annot = Station(latitude: sourLat, longitude: sourLong,title: "Your Are Here",type: "",BSU: "user")
       // print("adding user location")
        myMap.addAnnotation(annot)
            cnt++
        }
    }

    
    var num = 0
    func startTimer()
    {
        busOrstop = true
        timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "onTick:", userInfo: nil, repeats: true)
    }
    
    
    func onTick(timer:NSTimer){
        
        buslat.removeAll()
        buslon.removeAll()
        myMap.removeAnnotations(busAnnotation)
        let url:NSURL = NSURL(string: "http://webservices.nextbus.com/service/publicXMLFeed?a=rutgers&command=vehicleLocations&t=0000")!
        parse2 = NSXMLParser(contentsOfURL: url)!
        parse2.delegate = self
        parse2.parse()
       // print("onTick Called \(num++)")
        busAnnotation = getBusAnnotation(buslat, lon: buslon)
        myMap.addAnnotations(busAnnotation)
        
    }
    
    func drawMap(annotations: [Station])
    {
        var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        
        for annotation in annotations {
            points.append(annotation.coordinate)
        }
        let polyline = MKPolyline(coordinates:&points, count: points.count)
        //print(points.count)
        myMap.addOverlay(polyline)
    }
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? Station{
            let identifier = "pin"
           var view = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            
            if view == nil {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view?.canShowCallout = true
                if annotation.BSU == "user"{
                    print("user")
                    view?.image = UIImage(named: "img-user")
                }else if annotation.BSU == "bus" {
                    print("bus")
                    view?.image = UIImage(named: "img-bus")
                }else if annotation.BSU == "stop"{
                    print("stop \(annotation.title)")
                    view?.image = UIImage(named: "img-stop")
                }
            }
            return view
        }
        return nil
        
    }
    
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer! {
        if overlay is MKPolyline {
            if !getDirectionSet
            {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = 3
            return polylineRenderer
            } else{
                let myLineRenderer = MKPolylineRenderer(polyline: (myRoute?.polyline)!)
                myLineRenderer.strokeColor = UIColor.orangeColor()
                myLineRenderer.lineWidth = 5
                return myLineRenderer
            }
        }
        
        return nil
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
    selectedLat = view.annotation!.coordinate.latitude
    selectedLon = view.annotation!.coordinate.longitude
    let title = view.annotation!.title
    print(selectedLat)
    print(selectedLon)
    print(title)
    //print(view.annotation)
    //print("ANnotation clicked")
    }
    
    
    func zoomToRegion() {
        
        let location = CLLocationCoordinate2D(latitude: 40.743193, longitude: -74.178550)
        
        let region = MKCoordinateRegionMakeWithDistance(location, 3000.0, 3000.0)
        
        myMap.setRegion(region, animated: true)
    }
    
    
    func getAnnotations(lat: [Double],lon: [Double]) -> [Station]
    {
        var annotaions: Array = [Station]()
        for var index = 0; index < lat.count; ++index
        {
            
            let annot = Station(latitude: lat[index], longitude: lon[index],title: "",type: "",BSU: "line")
            //annot.title = "\(lat[index])  \(lon[index])"
            annotaions.append(annot)
            
        }
        return annotaions
    }
    func getAnnotationStop(lat: [Double],lon: [Double], tit: [String]) -> [Station]
    {
        var annotaions: Array = [Station]()
        for var index = 0; index < lat.count; ++index
        {
            let annot = Station(latitude: lat[index], longitude: lon[index],title: tit[index],type: "Bus in:\(GetPredictions.myDict[tit[index]]!)",BSU: "stop")
            annotaions.append(annot)
            
            
        }
        return annotaions
    }
    
    func getBusAnnotation(lat: [Double],lon: [Double]) -> [Station]
    {
        pin = "bus"
        var annotaions: Array = [Station]()
        for var index = 0; index < lat.count; ++index
        {
            
            let annot = Station(latitude: lat[index], longitude: lon[index],title: "", type: "",BSU: "bus")
            annotaions.append(annot)
            
        }
        return annotaions
    }
    
    
    
    
    
    var map = String()
    func getLatLon(map: String){
        self.map = map
        let url:NSURL = NSURL(string: "http://webservices.nextbus.com/service/publicXMLFeed?a=rutgers&command=routeConfig")!
        parser = NSXMLParser(contentsOfURL: url)!
        parser.delegate = self
        parser.parse()
    }
    
    
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        ename = elementName
        if elementName == "route"
        {
            //print(elementName)
            routeTitle = attributeDict["title"]! as String
            if routeTitle == map{
                routeTag = attributeDict["tag"]! as String
                GetPredictions.getPred(routeTag)
            }
        }
        if elementName == "stop"
        {
            if map == routeTitle && !dirBool
            {
                stopTitle = attributeDict["title"]! as String
                stopLat = (attributeDict["lat"]! as NSString).doubleValue
                stopLon = (attributeDict["lon"]! as NSString).doubleValue
                stopTitleArr.append(stopTitle)
                stopLonArr.append(stopLon)
                stopLatArr.append(stopLat)
            }
        }
        if elementName == "direction"
        {
            dirBool = true
        }
        if elementName == "path"
        {
            dirBool = false
            if pathBool
            {
                let annotations = getAnnotations(retLat, lon: retLon)
                drawMap(annotations)
                retLat.removeAll()
                retLon.removeAll()
            }
            pathBool = true
        }
        if elementName == "point"
        {
            pointLat = (attributeDict["lat"]! as NSString).doubleValue
            pointLon = (attributeDict["lon"]! as NSString).doubleValue
        }
        if elementName == "vehicle"
        {
            let tag = attributeDict["routeTag"]! as String
            if routeTag == tag
            {
                let lat = (attributeDict["lat"]! as NSString).doubleValue
                let lon = (attributeDict["lon"]! as NSString).doubleValue
                buslat.append(lat)
                buslon.append(lon)
            }
            
        }
    }
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        
    }
    
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "point" && routeTitle == map
        {
            retLat.append(pointLat)
            retLon.append(pointLon)
        }
        if elementName == "stop" && !dirBool
        {
            
        }
    }
    var getDirectionSet = false
    var myRoute : MKRoute?
    
    func popToPost(sender: UIBarButtonItem!) {
        getDirectionSet = true
        print("\(sourLat) & \(sourLong) to \(selectedLat) & \(selectedLon)")
        let directionsRequest = MKDirectionsRequest()
        let markTaipei = MKPlacemark(coordinate: CLLocationCoordinate2DMake(sourLat, sourLong), addressDictionary: nil)
        let markChungli = MKPlacemark(coordinate: CLLocationCoordinate2DMake(selectedLat, selectedLon), addressDictionary:nil)
        
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
    
}
