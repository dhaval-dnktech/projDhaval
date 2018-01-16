//
//  PlanDetailCell.swift
//  Cubber
//
//  Created by Vyas Kishan on 22/07/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit

class OperatorCell: UITableViewCell {

    //MARK: PROPERTIES
    @IBOutlet var viewImageBG: UIView!
    @IBOutlet var imageViewLogo: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewImageBG.layer.cornerRadius = 10
        self.viewImageBG.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
