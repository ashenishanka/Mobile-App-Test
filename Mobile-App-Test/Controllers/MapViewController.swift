//
//  MapViewController.swift
//  Mobile-App-Test
//
//  Created by Ashen Ishanka on 2024-06-27.
//

import UIKit
import MapKit
class MapViewController: UIViewController {
    
    var lat: String?, lang: String?
    var hotelTitle: String?
    var hotelAddress: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.mapType = .standard
        setMap()
    }
    func setMap(){
        //this function will handle send coordinate to the mapview
        //then it will load the map to that point
        let latConverted = Double(lat ?? "0.0") ?? 0.0
        let langConverted = Double(lang ?? "0.0") ?? 0.0
        let mCoordinate = CLLocationCoordinate2D(latitude: latConverted, longitude: langConverted)
        let region = MKCoordinateRegion(center: mCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
        //now we are going to point the hotel location in the map using above coordinates
        
        let mAnnotationPointer = MKPointAnnotation()
        mAnnotationPointer.coordinate = mCoordinate
        mAnnotationPointer.title = hotelTitle ?? "Hotel"
        mAnnotationPointer.subtitle = hotelAddress ?? "Unable to show the address"
        //We are going to  draw the pointer in the map below
        mapView.addAnnotation(mAnnotationPointer)
        
    }
    @IBOutlet weak var mapView: MKMapView!
    
    
    
}
