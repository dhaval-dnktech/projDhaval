
//
//  OperatorView.swift
//  Cubber
//
//  Created by dnk on 31/08/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

@objc protocol OperatorViewDelegate:class {
    func onOperatorView_Selection(_ dictOperator: typeAliasDictionary, dictRegion: typeAliasDictionary)
}


class OperatorView: UIView, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate var arrOperator:[typeAliasDictionary] = [typeAliasDictionary]()
    fileprivate var stCategoryID:String = ""
    fileprivate var selectedSection: Int = -1
    fileprivate let obj_OperationWeb = OperationWeb()
    var delegate: OperatorViewDelegate! = nil
    internal var isBrowsePlan:Bool = false

    
    //MARK:PROPERTIES
    @IBOutlet var viewBG: UIView!
    @IBOutlet var tableViewOperator: UITableView!
    @IBOutlet var constraintViewBGTopToSuperview: NSLayoutConstraint!
    @IBOutlet var constraintViewOperatorTopToViewBG: NSLayoutConstraint!
    
    
   
     init(frame: CGRect , categoryID:String) {
        let frame: CGRect = CGRect.init(x: 0, y: STATUS_BAR_HEIGHT, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - STATUS_BAR_HEIGHT)
        super.init(frame: frame)
        self.stCategoryID = categoryID
        self.loadXIB()
        if obj_AppDelegate.checkIsCallService(serviceName: JMETHOD_OperatorList) {
            DataModel.setOperatorListResponse(dict: typeAliasDictionary())
            self.callOperatorService()
        }
        else{
            let dictOperatorList = DataModel.getOperatorListResponse()
            if dictOperatorList[stCategoryID] != nil {
                let dictData:typeAliasDictionary =  dictOperatorList[stCategoryID] as! typeAliasDictionary
                DataModel.setHeaderToken(dictData[RES_token] as! String)
                self.arrOperator = dictData[RES_data]  as! [typeAliasDictionary]
                self.constraintViewBGTopToSuperview.constant = 800
                self.layoutIfNeeded()
                self.tableViewOperator.reloadData()
                self.obj_AppDelegate.navigationController.view.addSubview(self)
                self.obj_AppDelegate.navigationController.SetScreenName(name: F_OPERATORLIST, stclass: F_OPERATORLIST)
                self.constraintViewBGTopToSuperview.constant = self.frame.height/2
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                    self.layoutIfNeeded()
                }, completion: nil)
            }
            else{
                self.callOperatorService()
            }
        }

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
        
        tableViewOperator.register(UINib.init(nibName: CELL_IDENTIFIER_OPERATORLIST_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_OPERATORLIST_CELL)
        tableViewOperator.estimatedRowHeight = HEIGHT_OPERATORLIST_CELL
    }
    
    func callOperatorService() {
        
            let params = [REQ_HEADER:DataModel.getHeaderToken(),
                          REQ_CATEGORY_ID:self.stCategoryID]
            
            obj_OperationWeb.callRestApi(methodName: JMETHOD_OperatorList, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: obj_AppDelegate.navigationController!.view, onSuccess: { (dict) in
                DataModel.setHeaderToken(dict[RES_token] as! String)
                self.arrOperator = dict[RES_data] as! [typeAliasDictionary]
                self.tableViewOperator.reloadData()
                self.constraintViewBGTopToSuperview.constant = 800
                self.layoutIfNeeded()
                self.obj_AppDelegate.navigationController.view.addSubview(self)
                self.obj_AppDelegate.navigationController.SetScreenName(name: F_OPERATORLIST, stclass: F_OPERATORLIST)
                self.constraintViewBGTopToSuperview.constant = self.frame.height/2
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                    self.layoutIfNeeded()
                }, completion: nil)
                var dictResponse = DataModel.getOperatorListResponse()
                dictResponse[self.stCategoryID] = dict as AnyObject?
                DataModel.setOperatorListResponse(dict: dictResponse as typeAliasDictionary)
                self.obj_AppDelegate.updateDictService(serviceName: JMETHOD_OperatorList)
            }, onFailure: { (code, dict) in
                
            }, onTokenExpire: {
                 let _KDAlertView = KDAlertView()
                _KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING); return })
        
    }

    
    @IBAction func btnCloseAction() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .beginFromCurrentState, animations: {
            self.constraintViewBGTopToSuperview.constant = 800
            self.layoutIfNeeded()
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
    
    
    // MARK:TABLEVIEW DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int { return  self.arrOperator.count }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { if self.selectedSection == section {
        let dict: typeAliasDictionary = self.arrOperator[section]
          return (dict[RES_region]?.count)! + 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell: OperatorListCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_OPERATORLIST_CELL) as! OperatorListCell
        
        let dict: typeAliasDictionary = self.arrOperator[(indexPath as NSIndexPath).section]
        
        let setOperatorData = {
            
            cell.lblOperator.text = dict[RES_operatorName] as? String
            cell.viewOperator.isHidden = false
            cell.imageViewOperator.isHidden = false
            cell.imageViewOperator.sd_setImage(with: (dict[RES_image] as! String).convertToUrl() as URL!, placeholderImage: nil, options: SDWebImageOptions.progressiveDownload, progress:
                { (receivedSize, expectedSize) in cell.activityIndicator.startAnimating() })
            { (image, error, cacheType, imageURL) in
                
                if image == nil { cell.imageViewOperator.image = UIImage(named: "logo") }
                else { cell.imageViewOperator.image = image! }
                cell.activityIndicator.stopAnimating()
            }
        }
        
        if  self.selectedSection == (indexPath as NSIndexPath).section {
            if (indexPath as NSIndexPath).row == 0 { setOperatorData() }
            else {
                let arrRegion: Array<typeAliasDictionary> = dict[RES_region] as! Array<typeAliasDictionary>
                let dict: typeAliasDictionary = arrRegion[(indexPath as NSIndexPath).row - 1]
                cell.lblOperator.text = "\t \(dict[RES_regionName]!)"
                cell.imageViewOperator.isHidden = true
                cell.viewOperator.isHidden = true
            }
        }
        else { setOperatorData() }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell

    }
    
    //MARK: UITABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {  if  self.selectedSection == (indexPath as NSIndexPath).section {
        if (indexPath as NSIndexPath).row == 0 {return UITableViewAutomaticDimension }
        else {
            return 50
        }
    }
    else{
        return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { cell.separatorInset = UIEdgeInsets.zero; cell.preservesSuperviewLayoutMargins = false; cell.layoutMargins = UIEdgeInsets.zero
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dictOperator: typeAliasDictionary = self.arrOperator[(indexPath as NSIndexPath).section]
        if dictOperator[RES_region] != nil {
            
            let collapse = {
                let selectedSectionPrevious: Int = self.selectedSection
                self.selectedSection = -1
                self.tableViewOperator.reloadSections(IndexSet.init(integer: selectedSectionPrevious), with: UITableViewRowAnimation.top)
            }
            
            if self.selectedSection == (indexPath as NSIndexPath).section {
                if (indexPath as NSIndexPath).row == 0 { collapse() }
                else {
                    var arrRegion: Array<typeAliasDictionary> = dictOperator[RES_region] as! Array<typeAliasDictionary>
                    var dictRegion: typeAliasDictionary = arrRegion[(indexPath as NSIndexPath).row - 1]
                    dictRegion[RES_operatorName] = dictOperator[RES_operatorName] as! String as AnyObject?
                    self.delegate.onOperatorView_Selection(dictOperator, dictRegion: dictRegion)
                    
                    if self.isBrowsePlan {
//                        let planVC = PlanViewController(nibName: "PlanViewController", bundle: nil)
//                        planVC.dictOperator = dictOperator
//                        planVC.dictRegion = dictRegion
//                        planVC.stCategoryID = self.stCategoryID
//                        self.navigationController?.pushViewController(planVC, animated: true)
                        
                        obj_AppDelegate.navigationController?.viewControllers.remove(at: (obj_AppDelegate.navigationController?.viewControllers.count)! - 2)
                    }
                    else { self.btnCloseAction() }
                }
            }
            else {
                if self.selectedSection >= 0 { collapse() }
                
                let arrRegion: Array<typeAliasDictionary> = dictOperator[RES_region] as! Array<typeAliasDictionary>
                if arrRegion.isEmpty {
                    self.delegate.onOperatorView_Selection(dictOperator, dictRegion: typeAliasDictionary())
                    
                    if self.isBrowsePlan {
//                        let planVC = PlanViewController(nibName: "PlanViewController", bundle: nil)
//                        planVC.dictOperator = dictOperator
//                        planVC.dictRegion = typeAliasDictionary()
//                        planVC.stCategoryID = self.stCategoryID
//                        self.navigationController?.pushViewController(planVC, animated: true)
                        
                        obj_AppDelegate.navigationController?.viewControllers.remove(at: (obj_AppDelegate.navigationController?.viewControllers.count)! - 2)
                    }
                    else {self.btnCloseAction()}
                }
                else {
                    self.selectedSection = (indexPath as NSIndexPath).section
                    self.tableViewOperator.reloadSections(IndexSet.init(integer: self.selectedSection), with: UITableViewRowAnimation.bottom)
                    let middleIndex: Int  = arrRegion.count / 2
                    self.tableViewOperator.scrollToRow(at: IndexPath.init(row: 0, section: self.selectedSection), at: UITableViewScrollPosition.middle, animated: true)
                }
            }
        }
    }
    
    // MARK: SCROLLVIEW DELAGATE
    
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
            if tableViewOperator.contentOffset.y > 0 {
               self.constraintViewBGTopToSuperview.constant = 0
                UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                     self.layoutIfNeeded()
                }, completion: nil)
                 }
            else if tableViewOperator.contentOffset.y < 0{
                self.constraintViewBGTopToSuperview.constant = self.frame.height/2
                UIView.animate(withDuration: 0.5, delay: 0.3, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                     self.layoutIfNeeded()
                }, completion: nil)
            }
        }
}
