//
//  FlightListCell.swift
//  Cubber
//
//  Created by dnk on 03/11/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class ReturnFlightListCell: UITableViewCell {
    
    
    @IBOutlet var viewVerticalLine: UIView!
    @IBOutlet var viewPriceBG: UIView!
    @IBOutlet var viewAirlineImageBG: UIView!
    @IBOutlet var lblTotalAmount: UILabel!
    @IBOutlet var lblStops: UILabel!
    @IBOutlet var lblDepartureTime: UILabel!
    
    @IBOutlet var lblArrivalTime: UILabel!
    @IBOutlet var lblSourceCode: UILabel!
    @IBOutlet var lblDestinationCode: UILabel!
    @IBOutlet var lblTotalDuration: UILabel!
    @IBOutlet var lblFlightType: UILabel!
    @IBOutlet var lblUserCommission: UILabel!
    @IBOutlet var collectionViewStops: UICollectionView!
    @IBOutlet var viewDashedLine: UIView!
    @IBOutlet var collectionViewAirlines: UICollectionView!
    
    @IBOutlet var lblFirstStop: UILabel!
    @IBOutlet var lblStopsString: UILabel!
    @IBOutlet var lblLastStop: UILabel!
    
    @IBOutlet var imageAirlineSingle: UIImageView!
    @IBOutlet var imageAirLineOne: UIImageView!
    @IBOutlet var imageAirlineTwo: UIImageView!
    @IBOutlet var constraintImgaeAirlineOneTrailingToSuper: NSLayoutConstraint!
    @IBOutlet var constraintImageAirlineOneTrailingToImageAirlineTwo: NSLayoutConstraint!
    
    @IBOutlet var lblDepDate: UILabel!
    @IBOutlet var lblReturnDepDate: UILabel!
    @IBOutlet var lblArrivalDate: UILabel!
    @IBOutlet var lblReturnArrivalDate: UILabel!
    
    
    //RETURN DATA
   
    @IBOutlet var viewReturn_lblStops: UILabel!
    @IBOutlet var ViewReturn_lblArrivalTime: UILabel!
    @IBOutlet var ViewReturn_lblDepartureTime: UILabel!
    @IBOutlet var ViewReturn_CollectionViewStops: UICollectionView!
    
    @IBOutlet var ViewReturn_lblToAirportCode: UILabel!
    @IBOutlet var ViewReturn_lblFromAirportCode: UILabel!
    @IBOutlet var ViewReturn_lblTotalFilghtTime: UILabel!
    @IBOutlet var ViewReturn_lblFilghtTypeText: UILabel!
    @IBOutlet var ViewReturn_lblCommission: UILabel!
    @IBOutlet var ViewReturn_viewHorizonatlLine: UIView!
    @IBOutlet var ViewReturn_CollectionViewAirlines: UICollectionView!
    
    @IBOutlet var lblReturn_StopsString: UILabel!
    @IBOutlet var lblReturn_FirstStop: UILabel!
    @IBOutlet var lblReturn_LastStop: UILabel!
    
    
    @IBOutlet var ViewReturn_imageAirlineSingle: UIImageView!
    
    @IBOutlet var ViewReturn_imageAirLineOne: UIImageView!
    @IBOutlet var ViewReturn_imageAirlineTwo: UIImageView!
    @IBOutlet var ViewReturn_constraintImgaeAirlineOneTrailingToSuper: NSLayoutConstraint!
    @IBOutlet var ViewReturn_constraintImageAirlineOneTrailingToImageAirlineTwo: NSLayoutConstraint!
    
    
    @IBOutlet var constraintOneWayFlightTypeWidth: NSLayoutConstraint!
    
    @IBOutlet var constraintReturnWayFlightTypeWidth: NSLayoutConstraint!
    @IBOutlet var constraintViewReturnFlightCommissionHeight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionViewStops.register(UINib.init(nibName: CELL_IDENTIFIER_FLIGHT_STOP_CELL, bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER_FLIGHT_STOP_CELL)
         self.ViewReturn_CollectionViewStops.register(UINib.init(nibName: CELL_IDENTIFIER_FLIGHT_STOP_CELL, bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER_FLIGHT_STOP_CELL)
        self.collectionViewAirlines.register(UINib.init(nibName: CELL_IDENTIFIER_AIRLINE_CELL, bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER_AIRLINE_CELL)
          self.ViewReturn_CollectionViewAirlines.register(UINib.init(nibName: CELL_IDENTIFIER_AIRLINE_CELL, bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER_AIRLINE_CELL)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func draw(_ rect: CGRect) {
        
        self.viewVerticalLine.addDashedLine(color: .lightGray)
        //self.ViewReturn_viewHorizonatlLine.addDashedHorizontalLine(color: .lightGray)
        //self.viewDashedLine.addDashedHorizontalLine(color: .lightGray)
    }
    
}
