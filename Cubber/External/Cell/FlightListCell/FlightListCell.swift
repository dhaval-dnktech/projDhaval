//
//  FlightListCell.swift
//  Cubber
//
//  Created by dnk on 03/11/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class FlightListCell: UITableViewCell {
    
    
    @IBOutlet var viewVerticalLine: UIView!
    @IBOutlet var viewPriceBG: UIView!
    @IBOutlet var viewAirlineImageBG: UIView!
    @IBOutlet var lblTotalAmount: UILabel!
    @IBOutlet var lblStops: UILabel!
    @IBOutlet var lblDepartureTime: UILabel!
    
    @IBOutlet var imageAirLineOne: UIImageView!
    @IBOutlet var imageAirlineTwo: UIImageView!
    @IBOutlet var constraintImgaeAirlineOneTrailingToSuper: NSLayoutConstraint!
    
    @IBOutlet var constraintImageAirlineOneTrailingToImageAirlineTwo: NSLayoutConstraint!
    
    @IBOutlet var lblDepDate: UILabel!
    @IBOutlet var lblArrivalDate: UILabel!
    
    @IBOutlet var lblStopString: UILabel!
    @IBOutlet var lblFirstStop: UILabel!
    
    @IBOutlet var lblLastStop: UILabel!
    
    @IBOutlet var lblArrivalTime: UILabel!
    @IBOutlet var lblSourceCode: UILabel!
    @IBOutlet var lblDestinationCode: UILabel!
    @IBOutlet var lblTotalDuration: UILabel!
    @IBOutlet var lblFlightType: UILabel!
    @IBOutlet var lblUserCommission: UILabel!
    @IBOutlet var collectionViewStops: UICollectionView!
    @IBOutlet var viewDashedLine: UIView!
    @IBOutlet var collectionViewAirlines: UICollectionView!
    
    @IBOutlet var constraintFlightTypeWidth: NSLayoutConstraint!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionViewStops.register(UINib.init(nibName: CELL_IDENTIFIER_FLIGHT_STOP_CELL, bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER_FLIGHT_STOP_CELL)
        self.collectionViewAirlines.register(UINib.init(nibName: CELL_IDENTIFIER_AIRLINE_CELL, bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER_AIRLINE_CELL)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func draw(_ rect: CGRect) {
        
        self.viewVerticalLine.addDashedLine(color: .lightGray)
        //self.viewDashedLine.addDashedHorizontalLine(color: .lightGray)
    }
    
}
