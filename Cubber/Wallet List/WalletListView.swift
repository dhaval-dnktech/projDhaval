//
//  WalletListView.swift
//  Cubber
//
//  Created by dnk on 03/07/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class WalletListView: UIView , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet var lblNoWalletFound: UILabel!
    @IBOutlet var tableViewList: UITableView!
    
    //MARK: VARIABLES
    var arrWallet = [typeAliasDictionary]()
    fileprivate let TAG_PLUS = 100
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate var currentPage:Int = 1
    fileprivate var transactionType:String = "0"
    fileprivate var pageSize: Int = 0
    fileprivate var totalPages: Int = 0
    fileprivate var totalRecords: Int = 0
    
    //MARK: VIEW METHODS
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.loadXIB()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadXIB()
    }
    
    fileprivate func loadXIB() {
        
        let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0]as! UIView
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
        
        tableViewList.tableFooterView = UIView.init(frame: CGRect.zero)
        self.tableViewList.estimatedRowHeight =  HEIGHT_WALLET_LIST_CELL
        self.tableViewList.rowHeight = UITableViewAutomaticDimension
        self.tableViewList.register(UINib.init(nibName: CELL_IDENTIFIER_WALLET_LIST, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_WALLET_LIST)
        self.tableViewList.reloadData()
    }
    
    internal func loadData(id:Int) {
        self.transactionType = String(id)
        if arrWallet.isEmpty {
         self.callGetUserWalletListService()
        }
        else{ self.tableViewList.reloadData() }
     }
    
    fileprivate func callGetUserWalletListService() {
        
        let userInfo: typeAliasDictionary = DataModel.getUserInfo()
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_USER_ID: userInfo[RES_userID] as! String,
                      REQ_PAGE_NO: "\(currentPage)",
                      REQ_TRANSACTION_TYPE:transactionType]

        obj_OperationWeb.callRestApi(methodName: JMETHOD_UserWalletList, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: obj_AppDelegate.navigationController!.view, onSuccess: { (dict) in
            
            DataModel.setHeaderToken(dict[RES_token] as! String)
            self.pageSize = Int(dict[RES_par_page] as! String)!
            self.totalPages = Int(dict[RES_total_pages] as! String)!
            self.totalRecords = Int(dict[RES_total_items] as! String)!
            let arrData: Array<typeAliasDictionary> = dict[RES_data] as! Array<typeAliasDictionary>
            let wallet = "\(RUPEES_SYMBOL) \(dict[RES_wallet] as! String)"
            if ((self.obj_AppDelegate.navigationController.viewControllers.last?.isKind(of: WalletListViewController.classForCoder()))!) {
                let walletListVC:WalletListViewController = self.obj_AppDelegate.navigationController.viewControllers.last as! WalletListViewController
                
                var myMutableString = NSMutableAttributedString()
                myMutableString = NSMutableAttributedString(string: wallet, attributes: [NSFontAttributeName:UIFont(name: FONT_OPEN_SANS_SEMIBOLD, size: 13)!])
                // let location:Int = Int(stWallet.range(of: ".")?.lowerBound)
                let stWallet1 = wallet.components(separatedBy: ".")
                let loc:Int =  (stWallet1.first?.count)!
                myMutableString.addAttribute(NSFontAttributeName,
                                             value: UIFont(name: FONT_OPEN_SANS_SEMIBOLD,size: 11)!,range: NSMakeRange(loc + 1, 2))
                walletListVC.lblCurrentBalance.attributedText = myMutableString
                let width:CGFloat =  walletListVC.lblCurrentBalance.text!.textWidth(17,  textFont: walletListVC.lblCurrentBalance.font)
                walletListVC.constraintLblUserWalletHeight.constant =  width < 60 ? 60 :  width+10
            }

            var dictUserWallet:typeAliasDictionary = DataModel.getUserWalletResponse()
            if !dictUserWallet.isEmpty {
                dictUserWallet[RES_wallet] = dict[RES_wallet] as! String as AnyObject
                DataModel.setUserWalletResponse(dict: dictUserWallet)
            }
            
            self.arrWallet += arrData
            self.tableViewList.reloadData()
//            self.tableViewList.reloadRows(at: self.tableViewList.indexPathsForVisibleRows!, with: .none)
            self.tableViewList.isHidden = false
            self.lblNoWalletFound.isHidden = true
            self.tableViewList.layoutIfNeeded()
        }, onFailure: { (code, dict) in
            self.lblNoWalletFound.isHidden = false
            self.lblNoWalletFound.text = dict[RES_message] as? String
            self.tableViewList.isHidden = true
        }) {
            let _KDAlertView = KDAlertView()
            _KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING)
            _KDAlertView.didClick(completion: { (isClicked) in
               self.obj_AppDelegate.navigationController.popViewController(animated: true)
            })
  }
    }
    
    //MARK: UITABLEVIEW DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrWallet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WalletListCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_WALLET_LIST) as! WalletListCell;
        
        let dict: typeAliasDictionary = arrWallet[(indexPath as NSIndexPath).row]
        cell.lblDate.text = dict[RES_entryDate] as? String
        let stCreditAmount: String = dict[RES_creditWalletAmount] as! String
        let stDebitAmount: String = dict[RES_debitWalletAmount] as! String
        cell.lblWalletCreditDebit.text = Int(stCreditAmount) == 0 ? "- \(RUPEES_SYMBOL) \(stDebitAmount)" : "+ \(RUPEES_SYMBOL) \(stCreditAmount)"
        
        cell.lblWalletTitle.text = dict[RES_walletTitle] as? String
        cell.lblOrderId.text = "Cubber Order # \(dict[RES_orderID] as! String)"
        var stDetail = ""
        let stFrom: String = dict[RES_FromName] as! String
        let stNote: String = dict[RES_note] as! String
        stDetail += stFrom.isEmpty ? "" : "From : \(stFrom)\n"
        stDetail += "Cubber Wallet Txn ID \(dict[RES_walletID] as! String) "
        stDetail += stNote.isEmpty ? "" : "\n\(stNote)"
        cell.lblFrom.text = stDetail
              
        let stImageUrl: String = dict[RES_image] as! String
        if stImageUrl.count != 0 {
            cell.imageViewLogo.sd_setImage(with: stImageUrl.convertToUrl() as URL!, placeholderImage: nil, options: SDWebImageOptions.progressiveDownload, progress:
                { (receivedSize, expectedSize) in cell.activityIndicator.startAnimating() })
            { (image, error, cacheType, imageURL) in
                if image == nil { cell.imageViewLogo.image = UIImage(named: "logo") }
                else { cell.imageViewLogo.image = image! }
                cell.activityIndicator.stopAnimating()
            }
        }
        else { cell.imageViewLogo.image = UIImage(named: "logo") }
        
        if (indexPath as NSIndexPath).row == self.arrWallet.count - 1 {
            let page: Int = self.currentPage + 1
            if page <= self.totalPages { currentPage = page; self.callGetUserWalletListService(); }
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    //MARK: UITABLEVIEW DELEGATE
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { cell.separatorInset = UIEdgeInsets.zero; cell.preservesSuperviewLayoutMargins = false; cell.layoutMargins = UIEdgeInsets.zero
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableViewList.frame.width, height: 35))
        view.tag = 1001
        let lbl:UILabel = DesignModel.createPaddingLabel(frame:  CGRect(x: 0, y: 0, width: 120, height: 30), labelTag: 10, textColor: .white, textAlignment: NSTextAlignment.center, textFont: .systemFont(ofSize: 13), padding: UIEdgeInsets.zero)
        lbl.backgroundColor = RGBCOLOR(238, g: 238, b: 238)
        lbl.textColor = COLOUR_ORANGE
        lbl.center = view.center
        lbl.alpha = 0.0
        view.addSubview(lbl)
        view.setShadowDrop(view)
        if arrWallet.count > 0 {
        let dict: typeAliasDictionary = arrWallet[0]
            let str =  dict[RES_Label] as! String
             lbl.text = str
            lbl.alpha = 1.0
        }
        return view
     }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
        if tableViewList.contentSize.height > tableViewList.frame.height {
        let indexPathOfVisibleCells = tableViewList.indexPathsForVisibleRows
            if !(indexPathOfVisibleCells?.isEmpty)! {
                let dict:typeAliasDictionary = arrWallet[(indexPathOfVisibleCells?.first!.row)!]
                let strDate = dict[RES_Label] as? String
                self.setDurationMessage(str: strDate!)
            }
        }
    }
    
    func setDurationMessage(str:String) {
        let view = tableViewList.viewWithTag(1001)
        if view != nil {
        let lbl:UILabel = view?.viewWithTag(10) as! UILabel
        lbl.text = str
        }
    }
    
   }
