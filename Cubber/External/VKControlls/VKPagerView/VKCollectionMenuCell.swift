//
//  HomeMenuCell.swift
//  Cubber
//
//  Created by Vyas Kishan on 19/07/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

let FONT_HOME_MENU_CELL                     = UIFont.systemFont(ofSize: 15) //Check XIB
let PEDDING_HOME_MENU_CELL                  = 10

let CELL_IDENTIFIER_COLLECTION_MENU         = "VKCollectionMenuCell"
let HEIGHT_COLLECTION_MENU_CELL             = 45

import UIKit

protocol VKCollectionMenuCellDelegate:class {
    func btnVKCollectionMenuCell_TitleAction(_ button: UIButton)
}

class VKCollectionMenuCell: UICollectionViewCell {

    //MARK: PROPERTIES
    @IBOutlet var btnTitle: UIButton!
    @IBOutlet var viewUnderLine: UIView!
    var delegate: VKCollectionMenuCellDelegate! = nil
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnSortIcon: UIButton!
    @IBOutlet var viewTitleWithIcon: UIView!
    @IBOutlet var constraintLblTitleWidth: NSLayoutConstraint!
    @IBOutlet var constraintLblTitleTrailing: NSLayoutConstraint!
    @IBOutlet var constraintBtnSortIconTrailing: NSLayoutConstraint!
    
    
    
    //MARK: VIEW METHODS
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
    }
    
    //MARK: UIBUTTON ACTION
    @IBAction func btnTitleAction(_ sender: UIButton) {
        self.delegate.btnVKCollectionMenuCell_TitleAction(sender)
    }
}
