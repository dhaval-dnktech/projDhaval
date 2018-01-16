//
//  BoardingPointCell.swift
//  Cubber
//
//  Created by dnk on 25/04/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class BoardingPointCell: UITableViewCell {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
