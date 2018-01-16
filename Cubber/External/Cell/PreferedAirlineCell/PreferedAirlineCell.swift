//
//  PreferedAirlineCell.swift
//  Cubber
//
//  Created by dnk on 08/11/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

protocol PreferedAirlineCellDelegate {
    func btnPreferedAirlineCell_PreferedCheckBoxAction(_ button:UIButton)
}

class PreferedAirlineCell: UITableViewCell {

    @IBOutlet var btnAirlineCheckBox: UIButton!
    @IBOutlet var imageViewAirline: UIImageView!
    
    @IBOutlet var btnPreferedCheckBox: UIButton!
    @IBOutlet var lblAirlineTitle: UILabel!
    var delegate:PreferedAirlineCellDelegate? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnPreferedCheckBoxAction(_ sender: UIButton) {
        self.delegate?.btnPreferedAirlineCell_PreferedCheckBoxAction(sender)
    }
    
}
