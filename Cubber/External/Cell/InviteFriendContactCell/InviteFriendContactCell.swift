//
//  InviteFriendContactCell.swift
//  Cubber
//
//  Created by dnk on 03/02/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

protocol InviteFriendContactCellDelegate {
    func btnInviteFriendContactCell_InviteAction(buton:UIButton)
    func btnRemindFriendContactCell_InviteAction(buton:UIButton)
}

class InviteFriendContactCell: UITableViewCell {

    //MARK: PROPERTIES
    @IBOutlet var imageViewIconUser: UIImageView!
    @IBOutlet var lblContactName: UILabel!
    @IBOutlet var lblContactNumber: UILabel!
    @IBOutlet var btnInvite: UIButton!
    @IBOutlet var lblInviteTimer: UILabel!
    @IBOutlet var btnRemind: UIButton!
    
    var delegate:InviteFriendContactCellDelegate? = nil
    var timer = Timer()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func btnInviteAction(_ sender: UIButton) {
        self.delegate?.btnInviteFriendContactCell_InviteAction(buton: sender)
    }
    
    @IBAction func btnRemindAction(_ sender: UIButton) {
        self.delegate?.btnRemindFriendContactCell_InviteAction(buton: sender)
    }

}
