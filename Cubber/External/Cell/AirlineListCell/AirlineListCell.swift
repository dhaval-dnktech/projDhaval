//
//  AirlineListCell.swift
//  Cubber
//
//  Created by dnk on 08/11/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

protocol AirlineListCellDelegate {
    func btnAirlineListCell_CheckBoxAction(_ button:UIButton)
}

class AirlineListCell: UITableViewCell {

    @IBOutlet var lblAirLineTitle: UILabel!
    @IBOutlet var btnCheckBox: UIButton!
    var delegate:AirlineListCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnCheckBoxAction(_ sender: UIButton) {
        self.delegate?.btnAirlineListCell_CheckBoxAction(sender)
    }
    
}
