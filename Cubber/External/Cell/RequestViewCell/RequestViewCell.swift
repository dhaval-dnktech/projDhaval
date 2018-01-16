//
//  RequestViewCell.swift
//  Cubber
//
//  Created by dnk on 02/02/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

protocol RequestViewCellDelegate {
    func btnRequestViewCell_Send_RemindAction(button:UIButton)
    func btnRequestViewCell_CancelAction(button:UIButton)
}

class RequestViewCell: UITableViewCell {

    //MARK: PROPERTIES
    @IBOutlet var lblInfoName: UILabel!
    @IBOutlet var lblEntryDate: UILabel!
    @IBOutlet var lblRequestAmount: UILabel!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var btnSend_Remind: UIButton!
    @IBOutlet var btnCancel: UIButton!
    var delegate:RequestViewCellDelegate? = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        btnCancel.layer.borderWidth = 1
        btnCancel.layer.borderColor = COLOUR_GREEN.cgColor
        btnCancel.layer.cornerRadius = 5
        lblInfoName.layer.cornerRadius = 20
    }
    
    @IBAction func btnSend_RemindAction(_ sender: UIButton) {
        self.delegate?.btnRequestViewCell_Send_RemindAction(button: sender)
    }
    
    @IBAction func btnCancelAction(_ sender: UIButton) {
        self.delegate?.btnRequestViewCell_CancelAction(button: sender)
    }
    
}
