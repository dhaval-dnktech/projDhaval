//
//  AffiliateRewardsListCell.swift
//  Cubber
//
//  Created by dnk on 08/07/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class AffiliateRewardsListCell: UITableViewCell {

    @IBOutlet var viewBG: UIView!
    @IBOutlet var lblCategory: UILabel!
    @IBOutlet var lblPercentRewards: UILabel!
    @IBOutlet var lblRewardsNote: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBG.setViewBorder(UIColor.lightGray, borderWidth: 1, isShadow: false, cornerRadius: 5, backColor: UIColor.clear)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
