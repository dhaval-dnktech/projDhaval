//
//  ContactUsViewController.swift
//  Cubber
//
//  Created by 정광희 on 10/25/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit
import Contacts

class ContactUsViewController: UIViewController ,UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AppNavigationControllerDelegate {

    //MARK: PROPERTIES
    @IBOutlet var collectionViewOrderTypeList: UICollectionView!
    @IBOutlet var lblCubberHelplineNo: UILabel!
    @IBOutlet var lblCuberEmail: UILabel!
    @IBOutlet var constraintViewDescriptionTopToViewCubberAdmin: NSLayoutConstraint!
    @IBOutlet var constraintViewTopToSuper: NSLayoutConstraint!
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate var pageSize: Int = 0
    fileprivate var totalPages: Int = 0
    fileprivate var totalRecords: Int = 0
    fileprivate var currentPage: Int = 0
    fileprivate var arrOrderType = [typeAliasDictionary]()
    
    //MARK: DEFAULT METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionViewOrderTypeList.register(UINib.init(nibName: CELL_IDENTIFIER_CONTACTUS_CELL, bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER_CONTACTUS_CELL)

        let dictWalletResponse:typeAliasDictionary =  DataModel.getUserWalletResponse()
        if dictWalletResponse[RES_contact_customer_no] != nil {
            if dictWalletResponse[RES_contact_customer_no] as! String != "" {
                lblCubberHelplineNo.text = "Cubber Support : \(dictWalletResponse[RES_contact_customer_no]!)"
                constraintViewTopToSuper.priority = PRIORITY_LOW
                constraintViewDescriptionTopToViewCubberAdmin.priority = PRIORITY_HIGH
            }
        }
        if dictWalletResponse[RES_contact_customer_email] != nil {
            if dictWalletResponse[RES_contact_customer_email] as! String != "" {
                lblCuberEmail.text = "Cubber Email : \(dictWalletResponse[RES_contact_customer_email]!)"
                constraintViewTopToSuper.priority = PRIORITY_LOW
                constraintViewDescriptionTopToViewCubberAdmin.priority = PRIORITY_HIGH
            }
        }
        else{
            constraintViewTopToSuper.priority = PRIORITY_HIGH
            constraintViewDescriptionTopToViewCubberAdmin.priority = PRIORITY_LOW
        }

        
        if obj_AppDelegate.checkIsCallService(serviceName: JMETHOD_getAllOrderType){
            self.callOrderHistoryService()
        }
        else{
            let dictResponse = DataModel.getAllOrderTypeResponse()
            let arrData: Array<typeAliasDictionary> = dictResponse[RES_orderType] as! Array<typeAliasDictionary>
            self.arrOrderType = arrData
            self.collectionViewOrderTypeList.isHidden = false
            self.collectionViewOrderTypeList.reloadData()
        }
    
        
    }
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.setNavigationBar()
        self.sendScreenView(name: CONTACTUS)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.SetScreenName(name: F_CONTACT_US, stclass: F_CONTACT_US)
    }
    
    //MARK: - APP NAVIGATION CONTROLLER DELEGATE
    
    func setNavigationBar() {
        obj_AppDelegate.navigationController.setCustomTitle("Contact Us")
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_BackAction() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: CUSTOM METHODS
    
    fileprivate func callOrderHistoryService() {
        
        let params = [REQ_HEADER:DataModel.getHeaderToken()]
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_getAllOrderType, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: self.navigationController!.view, onSuccess: { (dict) in
            
            DataModel.setHeaderToken(dict[RES_token] as! String)
            let arrData: Array<typeAliasDictionary> = dict[RES_orderType] as! Array<typeAliasDictionary>
            self.arrOrderType += arrData
            DataModel.setAllOrderTypeResponse(dict: dict)
            self.obj_AppDelegate.updateDictService(serviceName: JMETHOD_getAllOrderType)
            self.collectionViewOrderTypeList.isHidden = false
            self.collectionViewOrderTypeList.reloadData()
        }, onFailure: { (code, dict) in
            
        }) {let _KDAlertView = KDAlertView()
            _KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING)
            _KDAlertView.didClick(completion: { (isClicked) in
                self.obj_AppDelegate.navigationController.popViewController(animated: true)
            }) }
    }
    
    //MARK: COLLECTION VIEW DATA SOURCE
    func numberOfSections(in collectionView: UICollectionView) -> Int {return 1}
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return arrOrderType.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: ContactUsCell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER_CONTACTUS_CELL, for: indexPath) as! ContactUsCell
        
        let dict:typeAliasDictionary = arrOrderType[indexPath.item]
        cell.lblCategoryName.text = dict[RES_orderTypeName] as? String
        cell.imageViewCategory.sd_setImage(with:  (dict[RES_icon] as! String).convertToUrl(), placeholderImage: #imageLiteral(resourceName: "logo"))
        return cell
    }
    
    //MARK: COLLECTON VIEW DELEGATE FLOW LAYOUT
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: CGFloat((collectionViewOrderTypeList.frame.width/3) - 8), height: (collectionViewOrderTypeList.frame.width/3) - 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dict = arrOrderType[indexPath.item]
        if dict[RES_orderTypeID] as! String == "11" || dict[RES_orderTypeID] as! String == "13" {
            let registerProblemVC = RegisterProblemViewController(nibName: "RegisterProblemViewController", bundle: nil)
            registerProblemVC.orderTypeId = dict[RES_orderTypeID] as! String
            self.navigationController?.pushViewController(registerProblemVC, animated: true)
        }
        else{
            let selectOrderVC = SelectOrderViewController(nibName: "SelectOrderViewController", bundle: nil)
            selectOrderVC.orderTypeId = dict[RES_orderTypeID] as! String
            self.navigationController?.pushViewController(selectOrderVC, animated: true)
        
        }
    }
}
