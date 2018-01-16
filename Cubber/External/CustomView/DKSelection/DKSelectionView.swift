//
//  RegionView.swift
//  Cubber
//
//  Created by dnk on 14/09/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

let VK_UNIQUE_KEY            = "VK_Unique_Key"
let VK_VALUE_KEY             = "VK_Value_Key"

import UIKit

@objc protocol DKSelectionViewDelegate:class {
    func onSelection(_ dictSelected: typeAliasDictionary)
}


class DKSelectionView: UIView , UITableViewDataSource , UITableViewDelegate , UITextFieldDelegate {

    //MARK: VARIABLES
    var didSelectOption: (_ option:typeAliasDictionary) -> () = { _ in }
    fileprivate let obj_AppDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate var arrData = [typeAliasDictionary]()
    fileprivate var arrDisplayData = [typeAliasDictionary]()
    fileprivate var stCategoryID:String = ""
    fileprivate var selectedSection: Int = -1
    fileprivate var dictKeys = typeAliasStringDictionary()
    var viewTitle:String = ""
    @IBOutlet var lblTitle: UILabel!
    internal var isBrowsePlan:Bool = false
    var delegate: DKSelectionViewDelegate! = nil
    var isSearch:Bool = false
    var isImage:Bool = false
    
    //MARK:PROPERTIES
    @IBOutlet var viewBG: UIView!
    @IBOutlet var tableViewRegion: UITableView!
    @IBOutlet var constraintViewBGTopToSuperview: NSLayoutConstraint!
    @IBOutlet var constraintViewOperatorTopToViewBG: NSLayoutConstraint!
    @IBOutlet var txtSearch: FloatLabelTextField!
    @IBOutlet var viewSearch: UIView!
    
    @IBOutlet var constraintViewSearchHeight: NSLayoutConstraint!

    
    init(frame: CGRect , arrRegion:[typeAliasDictionary] , title:String , dictKey : typeAliasStringDictionary) {
        
        let frame: CGRect = CGRect.init(x: 0, y: STATUS_BAR_HEIGHT, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - STATUS_BAR_HEIGHT)
        super.init(frame: frame)
        self.arrData = arrRegion
        self.arrDisplayData = arrData
        self.viewTitle = title
        self.dictKeys = dictKey
        self.isSearch = false
        self.isImage = false
        self.loadXIB()
    }
    
    init(frame: CGRect , arrRegion:[typeAliasDictionary] , title:String , dictKey : typeAliasStringDictionary , isSearch:Bool) {
        
        let frame: CGRect = UIScreen.main.bounds
        super.init(frame: frame)
        self.arrData = arrRegion
        self.arrDisplayData = self.arrData
        self.viewTitle = title
        self.dictKeys = dictKey
        self.isSearch = isSearch
        self.loadXIB()
    }
    
    init(frame: CGRect , arrRegion:[typeAliasDictionary] , title:String , dictKey : typeAliasStringDictionary , isSearch:Bool , isImage:Bool) {
        
        let frame: CGRect = UIScreen.main.bounds
        super.init(frame: frame)
        self.arrData = arrRegion
        self.arrDisplayData = self.arrData
        self.viewTitle = title
        self.dictKeys = dictKey
        self.isSearch = isSearch
        self.isImage = isImage
        self.loadXIB()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func loadXIB() {
        
        let view:UIView = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)![0] as! UIView
        view.translatesAutoresizingMaskIntoConstraints = false;
        self.addSubview(view)
        
        //TOP
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0))
        
        //LEADING
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0))
        
        //WIDTH
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0))
        
        //HEIGHT
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0))
        self.backgroundColor = RGBCOLOR(0, g: 0, b: 0, alpha: 0.4)
        //viewBG.backgroundColor = RGBCOLOR(0, g: 0, b: 0, alpha: 0.4)
        
        if isSearch {
            self.constraintViewSearchHeight.constant = 40
            self.viewSearch.isHidden = false
        }
        else{
            self.constraintViewSearchHeight.constant = 0
            self.viewSearch.isHidden = true
        }
        
        lblTitle.text = "Select \(viewTitle)"
        self.tableViewRegion.rowHeight = HEIGHT_REGION_CELL
        self.tableViewRegion.tableFooterView = UIView(frame: CGRect.zero)
        
        if isImage {
          self.tableViewRegion.register(UINib.init(nibName: CELL_IDENTIFIER_PREFERED_AIRLINE_LIST_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_PREFERED_AIRLINE_LIST_CELL)
        }
        else{
            self.tableViewRegion.register(UITableViewCell.self, forCellReuseIdentifier: CELL_IDENTIFIER_DEFAULT)
        }
      
        constraintViewBGTopToSuperview.constant = 800
        self.layoutIfNeeded()
        obj_AppDelegate.navigationController.view.addSubview(self)
        self.constraintViewBGTopToSuperview.constant = self.frame.height/2
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func btnCloseAction() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .beginFromCurrentState, animations: {
            self.constraintViewBGTopToSuperview.constant = 800
            self.layoutIfNeeded()
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
    fileprivate func filterContacts() {
        
        arrDisplayData = arrData
        tableViewRegion.reloadData()
    }
    
    fileprivate func serachContact(name:String) {
        
        self.filterContacts()
        if !name.isEmpty{
            var arrSearchedContact = [typeAliasDictionary]()
            for dict in arrData {
                if (dict[dictKeys[VK_VALUE_KEY]!] as! String).isContainString(name){arrSearchedContact.append(dict)}
            }
            arrDisplayData = arrSearchedContact
            tableViewRegion.reloadData()
        }
        else{ self.filterContacts() }
        
    }
    
    //MARK: UITABLEVIEW DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return self.arrDisplayData.count }
    
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dict: typeAliasDictionary = self.arrDisplayData[(indexPath as NSIndexPath).row]
        if isImage {
             let cell: PreferedAirlineCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_PREFERED_AIRLINE_LIST_CELL) as! PreferedAirlineCell
            cell.imageViewAirline.sd_setImage(with: (dict[RES_image] as! String).convertToUrl())
            cell.lblAirlineTitle.text = dict[dictKeys[VK_VALUE_KEY]!] as? String
           // cell.btnAirlineCheckBox.isHidden = true
            cell.btnPreferedCheckBox.isHidden = true
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        
        }
        else
        {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_DEFAULT)!
      //   UITableViewCell(style: .default, reuseIdentifier: CELL_IDENTIFIER_DEFAULT)
        cell.textLabel?.text = dict[dictKeys[VK_VALUE_KEY]!] as? String
        cell.textLabel?.font = UIFont.init(name: FONT_OPEN_SANS_SEMIBOLD, size: 13)
        cell.textLabel?.textColor = COLOUR_TEXT_GRAY
        cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
    }
    
    //MARK: UITABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return HEIGHT_REGION_CELL }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dictRegion: typeAliasDictionary = self.arrDisplayData[(indexPath as NSIndexPath).row]
        self.btnCloseAction()
        didSelectOption(dictRegion)
    }
    
    // MARK: SCROLLVIEW DELAGATE
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if tableViewRegion.contentOffset.y > 0 {
            self.constraintViewBGTopToSuperview.constant = 0
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.layoutIfNeeded()
            }, completion: nil)
        }
        else if tableViewRegion.contentOffset.y < 0 {
            self.constraintViewBGTopToSuperview.constant = self.frame.height/2
            UIView.animate(withDuration: 0.5, delay: 0.3, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.layoutIfNeeded()
            }, completion: nil)
        }
    }

    internal func didSelecteOption(completion: @escaping (_ option:typeAliasDictionary) -> ()) {
        didSelectOption = completion
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.constraintViewBGTopToSuperview.constant = 0
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtSearch.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text: String = textField.text!
        let resultingString: String = text.replacingCharacters(in: range.toRange(string: text), with: string)
        if textField.isEqual(txtSearch){self.serachContact(name: resultingString == "" ? ""  : resultingString)}
        
        return true
    }
}
