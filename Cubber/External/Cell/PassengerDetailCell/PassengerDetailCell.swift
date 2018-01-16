//
//  PassengerDetailCell.swift
//  Cubber
//
//  Created by dnk on 26/04/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit
protocol PassengerDetalCellDelegate {
    func PassengerDetailCell_BtnSelectGenderAction(button:UIButton)
}

class PassengerDetailCell: UITableViewCell {

    @IBOutlet var lblPassengerTitle: UILabel!
    @IBOutlet var lblSeatNo: UILabel!
    @IBOutlet var txtPassengerName: UITextField!
    @IBOutlet var txtPassengerAge: UITextField!
    @IBOutlet var btnGender_Male: UIButton!
    @IBOutlet var btnGender_Female: UIButton!
    
    var delegate:PassengerDetalCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func btnSelectGenderAction(_ sender: UIButton) {
        self.delegate?.PassengerDetailCell_BtnSelectGenderAction(button: sender)
    }
    
}
