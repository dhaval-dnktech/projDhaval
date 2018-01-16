//
//  ApplyPromocodeCell.swift
//  Cubber
//
//  Created by dnk on 18/09/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

protocol ApplyPromoCodeCellDelegate {
    func ApplyPromoCodeCell_btnApplyAction(button:UIButton)
    func ApplyPromoCodeCell_btnTermsAndCondAction(button:UIButton)

}

class ApplyPromocodeCell: UITableViewCell {

    
    @IBOutlet var lblCouponName: UILabel!
    
    @IBOutlet var btnTermsAndCond: UIButton!
    @IBOutlet var btnApplyCode: UIButton!
    @IBOutlet var lblDescription: UILabel!
    
    var delegate:ApplyPromoCodeCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnApplyAction(_ sender: UIButton) {
        self.delegate?.ApplyPromoCodeCell_btnApplyAction(button: sender)
    }
    @IBAction func btnTermsAndConditionAction(_ sender: UIButton) {
        self.delegate?.ApplyPromoCodeCell_btnTermsAndCondAction(button: sender)
    }
    
    
}
