//
//  TravellerDetailCell.swift
//  Cubber
//
//  Created by dnk on 14/11/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class TravellerDetailCell: UITableViewCell {

    @IBOutlet var lblTravellerName: UILabel!
    @IBOutlet var iconTraveller: UIImageView!
    
    @IBOutlet var txtTravellerName: FloatLabelTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
