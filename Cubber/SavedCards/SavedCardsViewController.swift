//
//  SavedCardsViewController.swift
//  Cubber
//
//  Created by Dhaval Nagar on 30/12/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class SavedCardsViewController: UIViewController, AppNavigationControllerDelegate , UITableViewDelegate , UITableViewDataSource , SavedCardCellDelegate{
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate var _KDAlertView = KDAlertView()
    fileprivate var arrCardList = [typeAliasDictionary]()
    
    //MARK: PROPERTIES
    @IBOutlet var tableViewList: UITableView!
    @IBOutlet var lblNoDataFound: UILabel!
    
    //MARK: DEFAULT METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewList.register(UINib.init(nibName: CELL_IDENTIFIER_SAVED_CARD_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_SAVED_CARD_CELL)
        self.tableViewList.tableFooterView = UIView.init(frame: .zero)
        self.tableViewList.rowHeight = HEIGHT_SAVED_CARD_CELL
        self.callGetCardList()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
    }
    //MARK: - APP NAVIGATION CONTROLLER DELEGATE
    fileprivate func setNavigationBar() {
        
        obj_AppDelegate.navigationController.setCustomTitle("Saved Cards")
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_BackAction() {
        let _ =  self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: CUSTOM METHODS
    
    func callGetCardList(){
        
        let params = [REQ_USER_ID:DataModel.getUserInfo()[RES_userID] as! String,
                      REQ_HEADER:DataModel.getHeaderToken(),]
        obj_OperationWeb.callRestApi(methodName: JMETHOD_GetCard, methodType: .POST, isAddToken: false, parameters: params, viewActivityParent: (self.navigationController?.view!)!, onSuccess: { (dict) in
            self.arrCardList = dict[RES_cardList] as! [typeAliasDictionary]
            self.tableViewList.isHidden = false
            self.tableViewList.reloadData()
            self.lblNoDataFound.isHidden = true
            
        }, onFailure: { (code, dict) in
            self.tableViewList.isHidden = true
            self.lblNoDataFound.isHidden = false
        }) {
        }
    }
    
    func callDeleteCardList(cardToken:String){
        
        let params = [REQ_USER_ID:DataModel.getUserInfo()[RES_userID] as! String,
                      REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_CARD_ID:cardToken,
                      REQ_U_MOBILE:DataModel.getUserInfo()[RES_userMobileNo] as! String]
        obj_OperationWeb.callRestApi(methodName: JMETHOD_DeleteCard, methodType: .POST, isAddToken: false, parameters: params, viewActivityParent: (self.navigationController?.view!)!, onSuccess: { (dict) in
            self._KDAlertView.showMessage(message: dict[RES_message] as! String, messageType: .WARNING)
            self._KDAlertView.didClick(completion: { (clicked) in
                self.arrCardList = [typeAliasDictionary]()
                self.callGetCardList()
            })
            
        }, onFailure: { (code, dict) in
            self._KDAlertView.showMessage(message: dict[RES_message] as! String, messageType: .WARNING)
        }) {
        }
    }
    
    //MARK: TABLEVIEW DELEGATE
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HEIGHT_SAVED_CARD_CELL
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    //MARK: TABLEVIEW DATASOURCE
    
    func numberOfSections(in tableView: UITableView) -> Int {return 1}
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return arrCardList.count}
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SavedCardCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_SAVED_CARD_CELL) as!  SavedCardCell
        
        cell.delegate = self
        
        cell.btnDeleteCard.accessibilityIdentifier = String(indexPath.row)
        let dictCard:typeAliasDictionary = arrCardList[indexPath.row]
        
        cell.lblCardNo.text = dictCard[RES_card_no] as! String?
        cell.lblCardType.text = dictCard[RES_card_type] as! String?
        cell.lblCardHolderName.text = dictCard[RES_card_name] as! String?
        if dictCard[RES_card_type] != nil && dictCard[RES_card_type] as! String != "" &&  dictCard[RES_card_type] as! String != "0" {
            cell.activityIndicator.startAnimating()
            cell.imageViewCardImage.sd_setImage(with: (dictCard[RES_card_image] as! String).convertToUrl(), completed: { (image,error, type, url) in
                cell.imageViewCardImage.image = image == nil ? #imageLiteral(resourceName: "logo_nav") : image
                cell.activityIndicator.stopAnimating()
            })
        }
        cell.selectionStyle = .none
        return cell
    }
    
    //MARK: SAVED CARD CELL DELEGATE
    func SavedCardCell_btnDeleteCardAction(button: UIButton) {
              
        let ind:Int = Int(button.accessibilityIdentifier!)!
        let dictCard:typeAliasDictionary = arrCardList[ind]
        self.callDeleteCardList(cardToken: dictCard[RES_card_token] as! String)
    }
    
}
