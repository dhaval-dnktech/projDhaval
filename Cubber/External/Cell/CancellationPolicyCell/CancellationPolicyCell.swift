//
//  CancellationPolicyCell.swift
//  Cubber
//
//  Created by dnk on 19/04/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class CancellationPolicyCell: UITableViewCell {

    @IBOutlet var lblCancellationTime: UILabel!
  
    @IBOutlet var lblRefundPercentage: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
