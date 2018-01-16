//
//  MyOrderFilterView.swift
//  Cubber
//
//  Created by dnk on 01/05/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

protocol GiveUpListViewDelegate {
    func GiveUpListView_SelectedData(id:String,isNeverShow:Bool)
}

class GiveUpListView: UIView,UIGestureRecognizerDelegate , UITableViewDelegate , UITableViewDataSource , GiveUpCashBackCellDelegate{
    
    //MARK: VARIABLES
    
    let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate var _VKDatePopover = VKDatePopOver()
    var delegate: GiveUpListViewDelegate! = nil
    fileprivate let _VKAlertActionView = VKAlertActionView()
    fileprivate var arrGiveUpList = [typeAliasDictionary]()
    fileprivate var selectedGiveUpID:String = ""
    fileprivate var giveUpNote:String = ""
    fileprivate var giveUpTerms:String = ""
    fileprivate var giveUpTitle:String = ""
    fileprivate var giveUpCategoryId:String = ""
    fileprivate var isNeverShow:Bool = false
    
    //MARK: PROPERTIES
    
    @IBOutlet var viewFilter: UIView!
    @IBOutlet var viewBG: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tableViewList: UITableView!
    @IBOutlet var btnNeverShowAgain: UIButton!
    @IBOutlet var btnWhyShouldGiveUp: UIButton!
 
   
     
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init(frame: CGRect , arrList:[typeAliasDictionary] , selectedId:String , isNeverShow:Bool , giveUpNote:String , giveUpTerms:String , lblTitle:String , giveUpCategoryId:String) {
        let frame: CGRect = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - STATUS_BAR_HEIGHT)
        super.init(frame: frame)
        self.arrGiveUpList = arrList
        self.selectedGiveUpID = selectedId
        self.giveUpNote = giveUpNote
        self.giveUpTerms = giveUpTerms
        self.giveUpTitle = lblTitle
        self.isNeverShow = isNeverShow
        self.giveUpCategoryId = giveUpCategoryId
        self.loadXib()
    }
    
    func loadXib() {
        
        self.alpha = 1
        let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0] as! UIView
        view.translatesAutoresizingMaskIntoConstraints = false;
        self.backgroundColor = COLOUR_BLACK_TRANSPARENT
        self.addSubview(view)
        
        //TOP
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0))
        
        //LEADING
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0))
        
        //WIDTH
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0))
        
        //HEIGHT
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0))
        
        let gestureTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(btnCloseViewTapAction))
        self.isUserInteractionEnabled = true
        self.isMultipleTouchEnabled = true
        self.addGestureRecognizer(gestureTap)
        gestureTap.delegate = self
        viewBG.tag = 100
        let walletInfo = DataModel.getUserWalletResponse()
        if walletInfo.isEmpty{
            lblTitle.text =  walletInfo[RES_isGiveupTitle] as! String
        }
        else{ lblTitle.text = "GiveUp Cashback"
        }
        
        btnNeverShowAgain.isSelected = self.isNeverShow
        
        self.tableViewList.register(UINib.init(nibName: CELL_IDENTIFIER_GIVEUP_CASHBACK_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_GIVEUP_CASHBACK_CELL)
        self.tableViewList.tableFooterView = UIView.init(frame: .zero)
        self.tableViewList.rowHeight = HEIGHT_GIVE_UP_CASHBACK_CELL
        
        self.layoutIfNeeded()
       // obj_AppDelegate.navigationController.view.addSubview(self)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.viewBG.alpha = 1
        }) { (completed) in

        }
    }
    
    @IBAction func btnNeverShowAgainAction() {
        btnNeverShowAgain.isSelected = !btnNeverShowAgain.isSelected
        self.isNeverShow = btnNeverShowAgain.isSelected
    }
    
    @IBAction func btnWhyShouldGiveUpAction() {
       // self.btnCloseViewTapAction()
        let howToEarnVC = HowToEarnViewController(nibName: "HowToEarnViewController", bundle: nil)
        howToEarnVC.categoryID = self.giveUpCategoryId
        obj_AppDelegate.navigationController?.pushViewController(howToEarnVC, animated: true)
    }
    
    @IBAction func btnProceedAction() {
        self.delegate.GiveUpListView_SelectedData(id: self.selectedGiveUpID, isNeverShow: self.isNeverShow)
        self.btnCloseViewTapAction()
    }
    
    @IBAction func btnCancelAction() {
        self.btnCloseViewTapAction()
    }
    
    //MARK: TABLEVIEW DELEGATE
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HEIGHT_GIVE_UP_CASHBACK_CELL
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // self.btnCloseViewTapAction()
        let dict = self.arrGiveUpList[indexPath.row]
        let howToEarnVC = HowToEarnViewController(nibName: "HowToEarnViewController", bundle: nil)
        howToEarnVC.categoryID = dict[RES_operatorCategoryId] as! String
        obj_AppDelegate.navigationController?.pushViewController(howToEarnVC, animated: true)
    }
    
    //MARK: TABLEVIEW DATASOURCE
    
    func numberOfSections(in tableView: UITableView) -> Int {return 1}
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return arrGiveUpList.count}
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:GiveUpCashBackCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_GIVEUP_CASHBACK_CELL) as! GiveUpCashBackCell
        
        cell.delegate = self
        cell.btnSelect.accessibilityIdentifier = String(indexPath.row)
        cell.btnInfo.isHidden = false
        
        let dictGiveup = arrGiveUpList[indexPath.row]
        if !(dictGiveup[RES_userProfileImage] as! String).isEmpty{
            cell.indicator.startAnimating()
            let sturl = dictGiveup[RES_userProfileImage] as! String
            cell.imageViewProfile.sd_setImage(with: NSURL.init(string: sturl) as URL!, completed: { (image, error, type, url) in
                if image != nil {
                    cell.imageViewProfile.isHidden = false
                    cell.lblProfileInitial.isHidden = true
                }
                else {
                    cell.imageViewProfile.isHidden = true
                    cell.lblProfileInitial.isHidden = false
                }
                cell.indicator.stopAnimating()
            })
        }
        else{
            cell.lblProfileInitial.isHidden = false
            cell.imageViewProfile.isHidden = true
        }
        let userFullName:String = dictGiveup[RES_Name] as! String
        let arrName = userFullName.components(separatedBy: " ")
        
        var stLN:String = ""
        var stLastName: String = ""
        let stFirstName: String = arrName[0]
        if arrName.count > 1 {
            stLastName = arrName[1]
        }
        
        let startIndex = stFirstName.index(stFirstName.startIndex, offsetBy: 0)
        let range = startIndex..<stFirstName.index(stFirstName.startIndex, offsetBy: 1)
        let stFN = stFirstName.substring( with: range ).uppercased()
        if !stLastName.isEmpty { stLN = stLastName.substring( with: range ).uppercased()}
        
        cell.lblProfileInitial.text = stFN+stLN
        cell.labelName.text = userFullName
        cell.imageViewStatus.isHidden = true
        if selectedGiveUpID == dictGiveup[RES_giveupId] as! String {
            cell.btnSelect.isSelected = true
        }
        else{cell.btnSelect.isSelected = false}
        
        cell.selectionStyle = .none
        return cell
    }
    
    //MARK: UITEXTFIELD DELEGATE
    func btnCloseViewTapAction() {
        self.removeFromSuperview()
        UIView.animateKeyframes(withDuration: 0.3, delay: 0.0, options: UIViewKeyframeAnimationOptions.beginFromCurrentState, animations: {
            self.viewBG.alpha = 0
        }, completion: { (finished) in
            self.removeFromSuperview()
        })
    }
    
    // MARK:GESTURE DELEGATE
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let view = touch.view
        if view?.tag == 100 {
            return true
        }
        return false
        
    }
    //MARK: GIVEUPCASHBACK CELL DELEGATE
    func GiveUpCashBackCell_btnSelectAction(button: UIButton) {
        let index:Int = Int(button.accessibilityIdentifier!)!
        let dictGiveUpId = arrGiveUpList[index]
        if dictGiveUpId[RES_giveupId] as! String == selectedGiveUpID { selectedGiveUpID = "" }
        else { selectedGiveUpID = dictGiveUpId[RES_giveupId] as! String }
        self.tableViewList.reloadData()
    }
}
