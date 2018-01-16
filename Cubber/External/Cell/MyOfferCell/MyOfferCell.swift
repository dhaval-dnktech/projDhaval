//
//  MyOfferCell.swift
//  Cubber
//
//  Created by dnk on 06/06/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

protocol MyOfferCellDelegate {
    func btnmyOfferCell_GetAction(_ button:UIButton)
}

class MyOfferCell: UITableViewCell  {
    
    var offerdelegate: MyOfferCellDelegate! = nil
    fileprivate var _KDAlertView = KDAlertView()
    @IBOutlet var viewBGUpcoming: UIView!
    @IBOutlet var viewBGCoupon: UIView!
    @IBOutlet var viewBG: UIView!
    @IBOutlet var lblValidity: UILabel!
    @IBOutlet var lblCouponCode: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnGet: UIButton!
    
    @IBOutlet var lblEndDateTitle: UILabel!
    @IBOutlet var lblValidityTitle: UILabel!
    @IBOutlet var lblnotAvailableCode: UILabel!
    @IBOutlet var lblEndDate: UILabel!
    
    
    
    @IBOutlet var constraintsViewCouponHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       viewBG.setViewBorder(UIColor.clear, borderWidth: 0, isShadow: true, cornerRadius: 0, backColor: UIColor.clear)
        btnGet.setViewBorder(UIColor.clear, borderWidth: 0, isShadow: true, cornerRadius: 5, backColor: COLOUR_DARK_GREEN)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnGetAction(_ sender: UIButton) {
        self.offerdelegate.btnmyOfferCell_GetAction(sender)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        lblCouponCode.addDashedBorder(color: COLOUR_ORANGE)

    }
    
    @IBAction func btnCopyCouponTextActon(_ sender: UIButton) {
        let paste = UIPasteboard.general
        paste.string = lblCouponCode.text
        sender.backgroundColor = COLOUR_ORANGE
        _KDAlertView.showMessage(message: "Copied to clipboard", messageType: .SUCCESS)
    }

    @IBAction func btnTouchDown(_ sender: UIButton) {
       sender.backgroundColor = COLOUR_ORDER_STATUS_PROCESSING
    }
  
}
