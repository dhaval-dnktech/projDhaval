//
//  EventPackageCell.swift
//  Cubber
//
//  Created by dnk on 13/10/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

protocol EventPackageCellDelegate {
    func btnEventPackageMinus_Action(_ button:UIButton)
    func btnEventPackagePlus_Action(_ button:UIButton)
}

class EventPackageCell: UITableViewCell {
    
    @IBOutlet var lblPerson: UILabel!
    @IBOutlet var lblPackageTitle: UILabel!
    @IBOutlet var lblPackageDescription: UILabel!
    @IBOutlet var lblPackageAmount: UILabel!
    
    @IBOutlet var btnPlus: UIButton!
    @IBOutlet var btnMinus: UIButton!
    var delegate:EventPackageCellDelegate? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnMinusAction(_ sender: UIButton) {
        self.delegate?.btnEventPackageMinus_Action(sender)
    }
    
    @IBAction func btnPlusAction(_ sender: UIButton) {
        self.delegate?.btnEventPackagePlus_Action(sender)
    }
}
