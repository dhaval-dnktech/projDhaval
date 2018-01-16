//
//  AmountPickUp.swift
//  Cubber
//
//  Created by Vyas Kishan on 15/08/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit

@objc protocol AmountPickUpDelegate {
    func amountPickUp_SelectedAmount(_ amount: String)
}

class AmountPickUp: UIView {
    
    //MARK: CONSTANT
    fileprivate let COLOUR_DESELECT: UIColor = RGBCOLOR(255, g: 255, b: 255)
    
    //MARK: PROPERTIES
    @IBOutlet var delegate: AmountPickUpDelegate!
    
    //MARK: VARIABLES
    var btnCollection = [UIButton]()
    
    //MARK: VIEW METHODS
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        
        if self.accessibilityIdentifier != nil
        {
            let stAmounts: String = self.accessibilityIdentifier!
            let arrAmount = stAmounts.components(separatedBy: ",")
            
            var xOrigin: CGFloat = 0
            let heightView = self.frame.height - 10
            let font = UIFont.systemFont(ofSize: 14)
            for stAmt in arrAmount {
//                let textWidth = stAmt.textWidth(heightView, textFont: font) + SIZE_EXTRA_TEXT
                let textWidth:CGFloat = (UIScreen.main.bounds.width - 44)/CGFloat(arrAmount.count)

                let btnAmount = DesignModel.createButton(CGRect(x: xOrigin, y: 0, width: textWidth, height: heightView), title: "\(RUPEES_SYMBOL) \(stAmt)", tag: 0, titleColor: UIColor.black, titleFont: font, textAlignment: UIControlContentHorizontalAlignment.center, bgColor: COLOUR_DESELECT, borderWidth: 1, borderColor: UIColor.lightGray, cornerRadius: 5)
                btnAmount.setTitleColor(UIColor.black, for: UIControlState())
                btnAmount.setTitleColor(UIColor.white, for: UIControlState.selected)
                btnAmount.isSelected = false
                btnAmount.addTarget(self, action: #selector(btnAmountAction), for: UIControlEvents.touchUpInside)
                self.addSubview(btnAmount)
                btnAmount.center = CGPoint(x: btnAmount.center.x, y: self.frame.height / 2)
                xOrigin = btnAmount.frame.maxX + 6
                btnCollection.append(btnAmount)
            }
        }
    }
    
    internal func btnAmountAction(_ button: UIButton) {
        if button.isSelected {
            button.backgroundColor = COLOUR_DESELECT
            self.delegate.amountPickUp_SelectedAmount("")
        }
        else {
            for btn in btnCollection { btn.backgroundColor = COLOUR_DESELECT; btn.isSelected = false }
            button.backgroundColor = "20ae48".hexStringToUIColor()
            self.delegate.amountPickUp_SelectedAmount(button.currentTitle!)
        }
        
        button.isSelected = !button.isSelected
    }
    
    internal func resetAmountPickUp() { for button in btnCollection { button.backgroundColor = COLOUR_DESELECT; button.isSelected = false; } }
}
