//
//  MapViewController.swift
//  Virtual Tourist|Norah
//
//  Created by نورة . on 20/09/2019.
//  Copyright © 2019 نورة . All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController{
    
    //MARK:Outlets
 @IBOutlet weak var mapView : MKMapView!
    
      //MARK: Variables
    var dataController: DataController!
    var fetchRe: NSFetchRequest<Pin> = Pin.fetchRequest()
    var myPin: Pin!
    
    // viewDidLoad & viewWillAppear
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupFetchedResults()
        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.LongPress(_:)))
        longPressRecogniser.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(longPressRecogniser)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResults()
    }
    
    
    // MARK:  Long Press func
    @objc func LongPress(_ gestureRecognizer : UIGestureRecognizer){
        if gestureRecognizer.state != .began { return }
        let touchPoint = gestureRecognizer.location(in: mapView)
        let coordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        let newPin = Pin(context: dataController.viewContext)
        newPin.latitude = coordinates.latitude
        newPin.longitude = coordinates.longitude
        do{
            try dataController.viewContext.save()
            myPin = newPin
        } catch{
            debugPrint()
        }
        mapView.addAnnotation(annotation)
    }
   
    
    
    // MARK: Setup Fetched Results Controller
    func setupFetchedResults() {
        if let result = try? dataController.viewContext.fetch(fetchRe) {
            for pin in result {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(pin.latitude), longitude: CLLocationDegrees(pin.longitude))
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    
    // MARK: Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoCollectionSegue"{
            let vc = segue.destination as! PhotoFliViewController
            vc.pin = myPin
        }
    }
    
}


extension MapViewController: MKMapViewDelegate {
    //Func Map
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard annotation is MKPointAnnotation else { print("no mkpointannotaions"); return nil }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.rightCalloutAccessoryView = UIButton(type: .infoDark)
            pinView!.pinTintColor = UIColor.red
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        
        if let latitude = view.annotation?.coordinate.latitude , let longitude = view.annotation?.coordinate.longitude {
            if let result = try? dataController.viewContext.fetch(fetchRe) {
                for Mypin in result {
                    if Mypin.latitude == latitude && Mypin.longitude == longitude {
                        myPin = Mypin
                        self.performSegue(withIdentifier: "photoCollectionSegue", sender: nil)
                    }
                    else {
                        print("returning")
                    }
                    
                }
            }
        }
    }
}



