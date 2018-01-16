//
//  AccountCell.swift
//  Cubber
//
//  Created by Vyas Kishan on 02/08/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit

class AccountCell: UITableViewCell {

    //MARK: PROPERTIES
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblBlink: UILabel!
    @IBOutlet var imageIconArrow: UIImageView!
    
    //MARK: VIEW METHODS
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}
