//
//  MapViewController.swift
//  Cubber
//
//  Created by dnk on 30/10/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController , MKMapViewDelegate , AppNavigationControllerDelegate {

    
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblVenue: UILabel!
    @IBOutlet var mapView: MKMapView!
    //MARK: VARIABLES
    internal var long:Double = 0.0
    internal var lat:Double = 0.0
    internal var stVenue:String = ""
    internal var stAddress:String = ""
    
    fileprivate let obj_AppDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblVenue.text = stVenue
        lblAddress.text = stAddress
        let annotation = MKPointAnnotation()
        let cordinate = CLLocationCoordinate2DMake(lat,long)
        annotation.coordinate = cordinate
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegionMake(cordinate, span)
        mapView.setRegion(region, animated: true)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setNavigationBar() {
        
        obj_AppDelegate.navigationController.setCustomTitle("Event Location")
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_BackAction() {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
            
        else {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            annotationView.image = #imageLiteral(resourceName: "ic_pointer")
            
            return annotationView
        }
    }
}
