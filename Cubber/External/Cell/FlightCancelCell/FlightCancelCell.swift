//
//  FlightCancelCell.swift
//  Cubber
//
//  Created by dnk on 17/11/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class FlightCancelCell: UITableViewCell {
    
    @IBOutlet var btnCheckBox: UIButton!
    @IBOutlet var lblPassengerName: UILabel!
    @IBOutlet var viewBG: UIView!
    
    @IBOutlet var lblPassengerType: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        viewBG.setShadowDrop(viewBG)
        viewBG.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
