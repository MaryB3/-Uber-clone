//
//  RiderLocationVC.swift
//  ParseStarterProject-Swift
//
//  Created by Mary Béds on 20/02/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse
import MapKit

class RiderLocationVC: UIViewController, MKMapViewDelegate {
    
    var requestLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var requestUsername = ""
    
    
    @IBOutlet weak var map: MKMapView!
    
    @IBAction func acceptRequest(_ sender: Any) {
        
        let query = PFQuery(className: "RiderRequest")
        
        query.whereKey("username", equalTo: requestUsername)
        query.findObjectsInBackground(block: { (objects, error) in
        
            if let riderRequests = objects {
                
                for riderRequest in riderRequests {
                    
                    riderRequest["driverResponded"] = PFUser.current()?.username
                    
                    riderRequest.saveInBackground()
                    
                    let requestCLLocation  = CLLocation(latitude: self.requestLocation.latitude, longitude: self.requestLocation.longitude)
                    
                    CLGeocoder().reverseGeocodeLocation(requestCLLocation, completionHandler: { (placemarks, error) in
                        
                        if let placemarkss = placemarks {
                            
                            if placemarkss.count > 0 {
                                
                                let mkPlacemark = MKPlacemark(placemark: placemarkss[0])
                                
                                let mapItem = MKMapItem(placemark: mkPlacemark)
                                mapItem.name = self.requestUsername
                                
                                let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                                
                                mapItem.openInMaps(launchOptions: launchOptions)
                            }
                        }
                        
                        
                    })
                }
            }
        
        })
        
    }
    
    @IBOutlet weak var acceptRequestBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let region = MKCoordinateRegion(center: requestLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        map.setRegion(region, animated: true)
        
        let annotation  = MKPointAnnotation()
        annotation.coordinate = requestLocation
        annotation.title = requestUsername
        
        map.addAnnotation(annotation)
        
    }



}
