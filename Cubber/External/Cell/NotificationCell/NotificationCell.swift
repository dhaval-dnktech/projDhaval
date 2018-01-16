//
//  PlanDetailCell.swift
//  Cubber
//
//  Created by Vyas Kishan on 22/07/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit

protocol NotificationCellDelegate {
    func btnNotificationCell_DeleteAction(_ button: UIButton)
}

class NotificationCell: UITableViewCell {

    //MARK: PROPERTIES
    @IBOutlet var viewBG: UIView!
    @IBOutlet var imageViewLogo: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var lblNotificationTitle: UILabel!
    @IBOutlet var lblNotificationDescription: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var btnDelete: UIButton!
    var delegate: NotificationCellDelegate! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewBG.layer.cornerRadius = 10
        self.imageViewLogo.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func btnDeleteNotificaionAction(_ sender: UIButton) {
        self.delegate.btnNotificationCell_DeleteAction(sender)
    }
    
}
