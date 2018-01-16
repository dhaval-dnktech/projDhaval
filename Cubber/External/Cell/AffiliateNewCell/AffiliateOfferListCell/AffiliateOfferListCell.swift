//
//  AffiliateOfferListCell.swift
//  Cubber
//
//  Created by dnk on 08/07/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit
import AudioToolbox

@objc protocol AffiliateOfferListCellDelegate {
    func AffiliateOfferListCell_btnCouponCodeAction(button:UIButton)
}

class AffiliateOfferListCell: UITableViewCell {

    fileprivate var _KDAlertView = KDAlertView()
    @IBOutlet var viewBG: UIView!
    @IBOutlet var lblCouponCode: UILabel!
    @IBOutlet var imageViewLogo: UIImageView!
    @IBOutlet var lblDiscount: UILabel!
    @IBOutlet var lblRewards: UILabel!
    @IBOutlet var lblCouponValid: UILabel!
    @IBOutlet var lblProductDiscount: UILabel!
    @IBOutlet var lblPartnerName: UILabel!
    @IBOutlet var btnCouponCode: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBG.setViewBorder(UIColor.lightGray, borderWidth: 1, isShadow: false, cornerRadius: 5
            , backColor: UIColor.clear)
    }
    
    override func draw(_ rect: CGRect) {
        lblCouponCode.addDashedBorder(color: COLOUR_ORANGE)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func btnCouponCodeAction(_ sender: UIButton) {
        print("\((self.lblCouponCode.text?.trim())!)")
        let paste = UIPasteboard.general
        paste.string = (self.lblCouponCode.text?.trim())!
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        _KDAlertView.showMessage(message: "Copied to clipboard", messageType: MESSAGE_TYPE.SUCCESS)
        return
    }
    
}
