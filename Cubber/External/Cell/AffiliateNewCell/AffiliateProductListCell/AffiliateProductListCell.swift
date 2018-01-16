//
//  AffiliateProductListCell.swift
//  Cubber
//
//  Created by dnk on 17/11/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class AffiliateProductListCell: UITableViewCell {

    @IBOutlet var imageViewProduct: UIImageView!
    @IBOutlet var imageViewPartner: UIImageView!
    @IBOutlet var lblProductTitle: UILabel!
    @IBOutlet var lblCubberCommision: UILabel!
    @IBOutlet var lblSpecialPrice: UILabel!
    @IBOutlet var lblSellingPrice: UILabel!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
