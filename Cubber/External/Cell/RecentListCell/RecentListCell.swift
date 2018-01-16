
//
//  RecentListCell.swift
//  Cubber
//
//  Created by dnk on 30/08/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class RecentListCell: UITableViewCell {

    @IBOutlet var lblNumber: UILabel!
    @IBOutlet var lblLastRecharge: UILabel!
    @IBOutlet var btnAmount: UIButton!
    @IBOutlet var viewOperator: UIView!
    @IBOutlet var imageViewOperator: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewOperator.layer.cornerRadius = self.viewOperator.frame.height/2
        imageViewOperator.layer.cornerRadius = self.imageViewOperator.frame.height/2

        btnAmount.setViewBorder(COLOUR_DARK_GREEN, borderWidth: 1, isShadow: false, cornerRadius: 5, backColor: UIColor.clear)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
