//
//  SideMenuCell.swift
//  Cubber
//
//  Created by dnk on 13/09/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {

    @IBOutlet var imageViewIcon: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblShortOffer: UILabel!
    @IBOutlet var viewLblShortTitleBG: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
