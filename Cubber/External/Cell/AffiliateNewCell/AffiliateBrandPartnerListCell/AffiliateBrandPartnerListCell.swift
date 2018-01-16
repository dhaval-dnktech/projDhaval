//
//  AffiliateBrandPartnerListCell.swift
//  Cubber
//
//  Created by dnk on 20/11/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit
protocol AffiliateBrandPartnerListCellDelegate {
    func btnAffiliateBrandPartnerListCell_CheckBoxAction(button:UIButton)
}

class AffiliateBrandPartnerListCell: UITableViewCell {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnCheckBox: UIButton!
    var delegate:AffiliateBrandPartnerListCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    @IBAction func btnCheckBoxAction(_ sender: UIButton) {
        self.delegate?.btnAffiliateBrandPartnerListCell_CheckBoxAction(button: sender)
    }
    
    
}
