//
//  ProductAttributeListCell.swift
//  Cubber
//
//  Created by dnk on 15/11/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class ProductAttributeListCell: UITableViewCell {

    @IBOutlet var lblAttributeValue: UILabel!
    @IBOutlet var lblAttributeKey: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
