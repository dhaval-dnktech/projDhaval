//
//  OperatorListCell.swift
//  Cubber
//
//  Created by dnk on 30/08/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class OperatorListCell: UITableViewCell {
    

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var viewOperator: UIView!
    @IBOutlet var imageViewOperator: UIImageView!
    @IBOutlet var lblOperator: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewOperator.layer.cornerRadius = self.viewOperator.frame.height/2
        imageViewOperator.layer.cornerRadius = self.imageViewOperator.frame.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
