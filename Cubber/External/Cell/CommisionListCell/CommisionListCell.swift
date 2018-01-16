//
//  CommisionListCell.swift
//  Cubber
//
//  Created by dnk on 29/04/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class CommisionListCell: UITableViewCell {

    @IBOutlet var lblCommisionName: UILabel!
    @IBOutlet var lblPercentage: UILabel!
    @IBOutlet var viewPercentage: UIView!
    @IBOutlet var constraintWidthLblCommisiionPercentage: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
         viewPercentage.setViewBorder(COLOUR_GREEN, borderWidth: 1, isShadow: false, cornerRadius: 3, backColor: UIColor.clear)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
