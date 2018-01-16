//
//  OTPView.swift
//  Cubber
//
//  Created by Vyas Kishan on 30/07/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit

protocol CubberTextFieldDelegate {
    func cubberTextFieldShouldBeginEditing(_ textField: UITextField)
    func cubberTextFieldShouldEndEditing(_ textField: UITextField)
    func cubberTextFieldShouldReturn(_ textField: UITextField)
    func cubberTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String)
}

class CubberTextField: UIView , UITextFieldDelegate{
    
    //MARK: CONSTANT
    fileprivate let activityIndicatorTrailing: CGFloat = -20
    
    //MARK: PROPERTIES
//    @IBOutlet var lblContent: UILabel!
    @IBOutlet var txtContent: FloatLabelTextField!
    var viewBG: UIView!
    var delegate: CubberTextFieldDelegate! = nil
    
    //MARK: VARIABLES
    var dictRegistrationPara: [String: String]!
    
    //MARK: VIEW METHODS
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, dictInfo: typeAliasStringDictionary, tag: Int) {
        super.init(frame : frame)
        loadXIB()
        
        let placeholder: String = dictInfo[RES_placeholder]!
//        self.lblContent.text = placeholder
        self.txtContent.placeholder = placeholder
        self.txtContent.tag = tag
        
        //accessibilityLabel - For editable or not
        
        if dictInfo[RES_min] != nil && dictInfo[RES_max] != nil { self.txtContent.accessibilityIdentifier = "\(dictInfo[RES_min]!),\(dictInfo[RES_max]!)" }
        
        if dictInfo[RES_type] != nil {
            if  dictInfo[RES_type] == "select"{
                self.txtContent.accessibilityLabel = "0"
            }
        }
    }
    
    fileprivate func loadXIB() {
        self.viewBG = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0] as! UIView
        self.viewBG.translatesAutoresizingMaskIntoConstraints = false;
        self.addSubview(self.viewBG)
        
        //TOP
        self.addConstraint(NSLayoutConstraint(item: self.viewBG, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0))
        
        //LEADING
        self.addConstraint(NSLayoutConstraint(item: self.viewBG, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0))
        
        //WIDTH
        self.addConstraint(NSLayoutConstraint(item: self.viewBG, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0))
        
        //HEIGHT
        self.addConstraint(NSLayoutConstraint(item: self.viewBG, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0))
        
        self.layoutIfNeeded()
    }
    
    internal func unSetHighlightCubberTextField() { self.txtContent.resignFirstResponder(); self.txtContent.unSetHighlight() }
    
    //MARK: UITEXTFIELD DELEGATE
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.delegate.cubberTextFieldShouldBeginEditing(textField)
        if textField.accessibilityLabel == "0" { return false }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.delegate.cubberTextFieldShouldEndEditing(textField)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.delegate.cubberTextFieldShouldReturn(textField)
        self.txtContent.resignFirstResponder()
        return true
    }
    
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         if textField.isOtherLanguageMode(string){ return false }
         self.delegate.cubberTextField(textField, shouldChangeCharactersIn: range, replacementString: string)
        return true
    }
}
