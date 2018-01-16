//
//  BusListCell.swift
//  Cubber
//
//  Created by dnk on 07/02/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class BusListCell: UITableViewCell {

    
    //MARK: PROPERTIES
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblDuration: UILabel!
    @IBOutlet var lblDetail: UILabel!
    @IBOutlet var lblAvailability: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
