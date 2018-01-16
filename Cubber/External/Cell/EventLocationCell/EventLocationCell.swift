//
//  EventLocationCell.swift
//  Cubber
//
//  Created by dnk on 13/10/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit
import MapKit

protocol EventLocationCellDelegate {
    func EventCell_btnLocationAction(button:UIButton)
 }

class EventLocationCell: UITableViewCell , MKMapViewDelegate {

    
    @IBOutlet var btnCellVenue: UIButton!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblVanue: UILabel!
    @IBOutlet var lblAddress: UILabel!
    
    
    
    fileprivate let obj_AppDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var delegate:EventLocationCellDelegate? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func btnEventLocationAction(_ sender: UIButton) {
        
        self.delegate?.EventCell_btnLocationAction(button: sender)
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
