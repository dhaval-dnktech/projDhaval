//
//  WalletListViewController.swift
//  Cubber
//
//  Created by Vyas Kishan on 13/08/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit

class WalletListViewController: UIViewController,  AppNavigationControllerDelegate,  VKPagerViewDelegate{

     let TAG_PLUS = 100
    //MARK: PROPERTIES

    internal var walletAmount: String = ""
    @IBOutlet var viewRightNav: UIView!
    @IBOutlet var lblCurrentBalance: UILabel!
    
    @IBOutlet var _VKPagerView: VKPagerView!
    
    @IBOutlet var constraintLblUserWalletHeight: NSLayoutConstraint!
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate var arrWallet = [typeAliasDictionary]()
    fileprivate var arrTransTypeList = [typeAliasDictionary]()
    //MARK: VIEW METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        if self.walletAmount == "" {
            self.callGetUserWalletService()
        }
        else {
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: walletAmount, attributes: [NSFontAttributeName:UIFont(name: FONT_OPEN_SANS_SEMIBOLD, size: 13)!])
            // let location:Int = Int(stWallet.range(of: ".")?.lowerBound)
            let stWallet1 = walletAmount.components(separatedBy: ".")
            let loc:Int =  (stWallet1.first?.characters.count)!
            
            myMutableString.addAttribute(NSFontAttributeName,
                                         value: UIFont(name: FONT_OPEN_SANS_SEMIBOLD,size: 11)!,range: NSMakeRange(loc + 1, 2))
            self.lblCurrentBalance.attributedText = myMutableString
            self.createPaginationView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
        self.sendScreenView(name: F_TRANSACTION)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.SetScreenName(name: F_TRANSACTION, stclass: F_TRANSACTION)
    }
    
    //MARK: NAVIGATION DELEGATE
    
    func setNavigationBar(){
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.setCustomTitle("Wallet List")
        obj_AppDelegate.navigationController.setRightView(self, view: viewRightNav, totalButtons: 2)
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_BackAction() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: CUSTOME METHODS
    
    
    fileprivate func createPaginationView() {
        
         self.arrTransTypeList = [[RES_id :"0" as AnyObject,RES_value:"All" as AnyObject] , [RES_id :"1" as AnyObject,RES_value:"Paid" as AnyObject] , [RES_id :"2" as AnyObject,RES_value:"Received" as AnyObject] , [RES_id :"3" as AnyObject,RES_value:"Added" as AnyObject] ,[RES_id :"5" as AnyObject,RES_value:"Shopping Cashback" as AnyObject],[RES_id :"4" as AnyObject,RES_value:"Referral Cashback" as AnyObject]]
        
        self.view.layoutIfNeeded()
        //self._VKPagerView.setPagerViewData(self.arrTransTypeList , keyName: RES_value, font: UIFont.systemFont(ofSize: 11), widthView:  UIScreen.main.bounds.width)
        self._VKPagerView.setPagerViewData(self.arrTransTypeList, keyName: RES_value)
        self._VKPagerView.delegate = self
        
        for i in 0..<self.arrTransTypeList.count {
            var dict: typeAliasDictionary = self.arrTransTypeList[i]
            
            let catID = String(i)//dict[RES_id] as! String
            let xOrigin: CGFloat = CGFloat(i) * self._VKPagerView.scrollViewPagination.frame.width
            let frame: CGRect = CGRect(x: xOrigin, y: 0, width: self._VKPagerView.scrollViewPagination.frame.width, height: self._VKPagerView.scrollViewPagination.frame.height)
            let  _walletListView: WalletListView = WalletListView.init(frame: frame)
            _walletListView.tag = Int(catID)! + TAG_PLUS
            
            _walletListView.translatesAutoresizingMaskIntoConstraints = false;
            self._VKPagerView.scrollViewPagination.addSubview(_walletListView);
            //---> SET AUTO LAYOUT
            //HEIGHT
            self._VKPagerView.scrollViewPagination.addConstraint(NSLayoutConstraint(item: _walletListView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self._VKPagerView.scrollViewPagination, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0))
            
            //WIDTH
            self._VKPagerView.scrollViewPagination.addConstraint(NSLayoutConstraint(item: _walletListView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self._VKPagerView.scrollViewPagination, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0))
            
            //TOP
            self._VKPagerView.scrollViewPagination.addConstraint(NSLayoutConstraint(item: _walletListView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self._VKPagerView.scrollViewPagination, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 1))
            
            if (i == 0)
            {
                //LEADING
                self._VKPagerView.scrollViewPagination.addConstraint(NSLayoutConstraint(item: _walletListView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self._VKPagerView.scrollViewPagination, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0))
            }
            else
            {
                //LEADING = SPCING BETWEEN PREVIOUS SCROLLVIEW AND CURRENT
                let viewPrevious: UIView = self._VKPagerView.scrollViewPagination.viewWithTag(TAG_PLUS + Int(catID)! - 1)!;
                self._VKPagerView.scrollViewPagination.addConstraint(NSLayoutConstraint(item: _walletListView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: viewPrevious, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0))
            }
            
            if (i == arrTransTypeList.count - 1) //This will set scroll view content size
            {
                //SCROLLVIEW - TRAILING
                self.view.addConstraint(NSLayoutConstraint(item: _walletListView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self._VKPagerView.scrollViewPagination, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0))
            }
        }
        self.view.layoutIfNeeded()
        self.setWalletViewData(id: 0)
    }
    
    func setWalletViewData(id:Int) {
        
        let _walletListView:WalletListView = self._VKPagerView.viewWithTag(TAG_PLUS + id) as! WalletListView
        let dictType = arrTransTypeList[id]
        _walletListView.loadData(id: Int(dictType[RES_id] as! String)!)
        _walletListView.layoutIfNeeded()
    }
    
    
    
    fileprivate func callGetUserWalletService() {
        
        let userInfo: typeAliasDictionary = DataModel.getUserInfo()
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                     REQ_USER_ID: userInfo[RES_userID] as! String]
      
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_GetUserWallet, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in

            DataModel.setHeaderToken(dict[RES_token] as! String)
            self.walletAmount = "\(RUPEES_SYMBOL) \(dict[RES_wallet]!)"
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: self.walletAmount, attributes: [NSFontAttributeName:UIFont(name: FONT_OPEN_SANS_SEMIBOLD, size: 13)!])
            // let location:Int = Int(stWallet.range(of: ".")?.lowerBound)
            let stWallet1 = self.walletAmount.components(separatedBy: ".")
            let loc:Int =  (stWallet1.first?.characters.count)!
            
            myMutableString.addAttribute(NSFontAttributeName,
                                         value: UIFont(name: FONT_OPEN_SANS_SEMIBOLD,size: 11)!,range: NSMakeRange(loc + 1, 2))
            self.lblCurrentBalance.attributedText = myMutableString
            self.createPaginationView()
            
        }, onFailure: { (code, dict) in
            
        }) {let _KDAlertView = KDAlertView()
            _KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return}
    }
    
    //MARK: VKPAGERVIEW DELEGATE
    
    func onVKPagerViewScrolling(_ selectedMenu: Int) {
        self.setWalletViewData(id: selectedMenu)
    }
    
    func onVKPagerViewScrolling(_ selectedMenu: Int, arrMenu: [typeAliasDictionary]) {
    }
    
}
