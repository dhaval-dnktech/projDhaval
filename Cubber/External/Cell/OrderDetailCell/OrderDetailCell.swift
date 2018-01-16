//
//  OrderCell.swift
//  Cubber
//
//  Created by Vyas Kishan on 09/08/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit

protocol OrderDetailCellDelegate {
    func btnOrderDetailCell_RepeatAction(_ button: UIButton)
    func btnOrderDetailCell_RetryAction(_ button: UIButton)
    func btnOrderDetailCell_CancelTicketAction(_ button: UIButton)
    func btnOrderDetailCell_CancelOrderAction(_ button: UIButton)
}

class OrderDetailCell: UITableViewCell {
    
    //MARK: PROPERTIES
    @IBOutlet var viewImageBG: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var imageViewItem: UIImageView!
    @IBOutlet var lblItemTitle: UILabel!
    @IBOutlet var btnItemStatus: UIButton!
    @IBOutlet var btnRepeat: UIButton!
    @IBOutlet var btnRetry: UIButton!
    @IBOutlet var btnCollection: [UIButton]!
    @IBOutlet var lblAmount: UILabel!
    @IBOutlet var lblEventSeats: UILabel!
    
    @IBOutlet var lblReferenceNumber: UILabel!
    @IBOutlet var btnCancelTicket: UIButton!
    @IBOutlet var getStatusActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var constraintLblReferenceHeight: NSLayoutConstraint!
    @IBOutlet var constraintBtnCancelTicketHeight: NSLayoutConstraint!
    
    @IBOutlet var btnCancelOrder: UIButton!
    @IBOutlet var lblOrderDate: UILabel!
    @IBOutlet var constraintBtnCancelOrderHeight: NSLayoutConstraint!
    @IBOutlet var constraintLblEventSeatHeight: NSLayoutConstraint!
    
    var delegate: OrderDetailCellDelegate! = nil
    
    
    //MARK: VARIABLES
    
    //MARK: VIEW METHODS
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewImageBG.layer.cornerRadius = 30
        self.btnItemStatus.layer.cornerRadius = 5
        
        self.btnRepeat.layer.cornerRadius = 5.0
        self.btnRepeat.layer.borderWidth = 1.0
        self.btnRepeat.layer.borderColor = COLOUR_ORDER_STATUS_SUCCESS.cgColor
        self.btnRepeat.setTitleColor(COLOUR_ORDER_STATUS_SUCCESS, for: UIControlState())
        
        self.btnRetry.layer.cornerRadius = 5.0
        self.btnRetry.layer.borderWidth = 1.0
        self.btnRetry.layer.borderColor = COLOUR_ORDER_STATUS_FAILURE.cgColor
        self.btnRetry.setTitleColor(COLOUR_ORDER_STATUS_FAILURE, for: UIControlState())
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func btnRepeatAction(_ sender: UIButton) { self.delegate.btnOrderDetailCell_RepeatAction(sender) }
    
    @IBAction func btnRetryAction(_ sender: UIButton) { self.delegate.btnOrderDetailCell_RetryAction(sender) }
    
    @IBAction func btnCancelTicketAction(_ sender: UIButton) { self.delegate.btnOrderDetailCell_CancelTicketAction(sender)
    }
    @IBAction func btnCancelOrderAction(_ sender: UIButton) {
        self.delegate.btnOrderDetailCell_CancelOrderAction(sender)
    }
    
}
