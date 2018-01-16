//
//  PlanDetailCell.swift
//  Cubber
//
//  Created by Vyas Kishan on 22/07/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit

class PlanDetailCell: UITableViewCell {

    //MARK: PROPERTIES
    @IBOutlet var lblTalkTime: UILabel!
    @IBOutlet var lblValidity: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblAmount: UILabel!
    @IBOutlet var viewBGAmount: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewBGAmount.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
