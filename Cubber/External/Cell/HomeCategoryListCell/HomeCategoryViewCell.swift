//
//  HomeCategoryViewCell.swift
//  Cubber
//
//  Created by dnk on 29/08/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class HomeCategoryViewCell: UITableViewCell {

    
    @IBOutlet var imageViewShopping: UIImageView!
    @IBOutlet var viewShopping: UIView!
    @IBOutlet var viewAmount: UIView!
    @IBOutlet var viewDate: UIView!
    @IBOutlet var viewShopNowBG: UIView!
    @IBOutlet var imageViewShopNow: UIImageView!
    @IBOutlet var btnShopNow: UIImageView!
    @IBOutlet var lblShoppingTentativeAmount: UILabel!
    @IBOutlet var lblShopping_Date: UILabel!
    @IBOutlet var btnInfo: UIButton!
    @IBOutlet var btnShoppingAmount: UIButton!
    
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubtitle: UILabel!
    @IBOutlet var collectionViewCategories: UICollectionView!
    @IBOutlet var constraintCollectionViewCategoryHeight: NSLayoutConstraint!
    @IBOutlet var userSummaryView: UIView!
    @IBOutlet var imageViewInvite: UIImageView!
    @IBOutlet var btnInviteFriend: UIButton!
     fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionViewCategories.register(UINib.init(nibName: CELL_IDENTIFIER_HOME_CATEGORY_COLLECTION_CELL, bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER_HOME_CATEGORY_COLLECTION_CELL)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func btnInvitefriendAction(_ sender: UIButton) {
        obj_AppDelegate.onVKMenuAction(.INVITE_FRIENDS, categoryID: 0)
    }
    @IBAction func btnShopNowAction(_ sender: UIButton) {
        
        let afffiliateOfferVC = AffiliatePartnersViewController(nibName: "AffiliatePartnersViewController", bundle: nil)
        afffiliateOfferVC.isOffer = true
        obj_AppDelegate.navigationController?.pushViewController(afffiliateOfferVC, animated: true)
    }
    
    @IBAction func btnSummaryInfoAction(_ sender: UIButton) {
        obj_AppDelegate.onVKMenuAction(.HOW_TO_EARN, categoryID: 21)
    }
    @IBAction func btnShoppingCashbackAction(_ sender: Any) {
            obj_AppDelegate.redirectToScreen(_REDIRECT_SCREEN_TYPE: .SCREEN_AFFILIATE_ORDERLIST, dict: typeAliasDictionary())
    }
    
}
