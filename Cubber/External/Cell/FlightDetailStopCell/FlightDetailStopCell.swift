//
//  FlightDetailStopCell.swift
//  Cubber
//
//  Created by dnk on 09/11/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class FlightDetailStopCell: UITableViewCell {

    @IBOutlet var ImageAirline: UIImageView!
    @IBOutlet var lblAirlineName: UILabel!
    @IBOutlet var lblAirlineNumber: UILabel!
    @IBOutlet var lblClassName: UILabel!
    @IBOutlet var lblDestCode: UILabel!
    
    @IBOutlet var viewDashedLine: UIView!
    
    @IBOutlet var lblSourceCode: UILabel!
    @IBOutlet var lblDepTime: UILabel!
    @IBOutlet var lblTerminal: UILabel!
    @IBOutlet var lblSourceAirportName: UILabel!
    @IBOutlet var lblDuration: UILabel!
    @IBOutlet var lblDestAirportName: UILabel!
    
    @IBOutlet var lblDestTerminal: UILabel!
    @IBOutlet var lblArrTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func draw(_ rect: CGRect) {
        self.viewDashedLine.addDashedHorizontalLine(color: .lightGray)
    }
    
}
