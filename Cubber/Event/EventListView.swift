//
//  EventListView.swift
//  Cubber
//
//  Created by dnk on 12/10/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

protocol EventViewDelegate {
    func EventViewDelegate_didSelectRow(dict:typeAliasDictionary)
}
class EventListView: UIView, UITableViewDataSource, UITableViewDelegate , EventListCellDelegate{

    @IBOutlet var tableViewEvent: UITableView!
    @IBOutlet var lblNoEventFound: UILabel!
    
    //MARK: VARIABLES
    
    var arrEvent = [typeAliasDictionary]()
    fileprivate let TAG_PLUS = 100
    fileprivate let obj_Location = Location.init()
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate var currentPage:Int = 1
    fileprivate var eventType:String = "0"
    fileprivate var totalPages: Int = 0
    fileprivate var totalRecords: Int = 0
    var delegate:EventViewDelegate? = nil
    
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
        
        tableViewEvent.tableFooterView = UIView.init(frame: CGRect.zero)
        self.tableViewEvent.estimatedRowHeight = HEIGHT_EVENT_LIST_CELL
        self.tableViewEvent.rowHeight = UITableViewAutomaticDimension

        self.tableViewEvent.register(UINib.init(nibName: CELL_IDENTIFIER_EVENT_LIST, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_EVENT_LIST)
        self.tableViewEvent.reloadData()
        self.layoutIfNeeded()
    }
    
    internal func loadData(id:Int) {
        self.eventType = String(id)
        if arrEvent.isEmpty {
            self.callGetEventList()
        }
        else{ self.tableViewEvent.reloadData() }
    }
    
    fileprivate func callGetEventList() {
        
        let userInfo: typeAliasDictionary = DataModel.getUserInfo()
        var params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_USER_ID: userInfo[RES_userID] as! String,
                      REQ_PAGE_NO: "\(currentPage)",
                      REQ_CATEGORY_ID:eventType
            ]
        params[REQ_LATITUDE] = obj_Location.latitude as String
        params[REQ_LONGITUDE] = obj_Location.longitude as String
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_GetEventList, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: obj_AppDelegate.navigationController!.view, onSuccess: { (dict) in
            
            DataModel.setHeaderToken(dict[RES_token] as! String)
            self.totalPages = Int(dict[RES_totalPages] as! String)!
            self.totalRecords = Int(dict[RES_totalRecord] as! String)!
            let arrData: Array<typeAliasDictionary> = dict[RES_eventData] as! Array<typeAliasDictionary>
            self.arrEvent += arrData
            self.tableViewEvent.reloadData()
            self.tableViewEvent.isHidden = false
            self.lblNoEventFound.isHidden = true
        }, onFailure: { (code, dict) in
            self.lblNoEventFound.isHidden = false
            self.lblNoEventFound.text = dict[RES_message] as? String
            self.tableViewEvent.isHidden = true
        }) {
            let _KDAlertView = KDAlertView()
            _KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING)
        }
    }
    
    //MARK: UITABLEVIEW DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrEvent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EventListCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_EVENT_LIST) as! EventListCell;
        
        let dict: typeAliasDictionary = arrEvent[(indexPath as NSIndexPath).row]
        
        let stImageUrl: String = dict[RES_image] as! String
        if stImageUrl.count != 0 {
            cell.imageViewEvent.sd_setImage(with: stImageUrl.convertToUrl() as URL!, placeholderImage: nil, options: SDWebImageOptions.progressiveDownload, progress:
                { (receivedSize, expectedSize) in cell.activityIndicator.startAnimating() })
            { (image, error, cacheType, imageURL) in
                if image == nil { cell.imageViewEvent.image = UIImage(named: "logo") }
                else { cell.imageViewEvent.image = image! }
                cell.activityIndicator.stopAnimating()
            }
        }
        else { cell.imageViewEvent.image = UIImage(named: "logo") }
        
        cell.lblEventName.text = dict[RES_operatorName] as? String
        cell.lblEventPlace.text = dict[RES_venue] as? String
        cell.lblEventDate.text = dict[RES_displayDate] as? String
        cell.lblAmount.text = "\(RUPEES_SYMBOL) \(dict[RES_price] as! String)"
        cell.btnSelectEvent.accessibilityIdentifier = String(indexPath.row)
        cell.delegate = self
        if (indexPath as NSIndexPath).row == self.arrEvent.count - 1 {
            let page: Int = self.currentPage + 1
            if page <= self.totalPages { currentPage = page; self.callGetEventList(); }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    
    //MARK: UITABLEVIEW DELEGATE
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { cell.separatorInset = UIEdgeInsets.zero; cell.preservesSuperviewLayoutMargins = false; cell.layoutMargins = UIEdgeInsets.zero
    }
    
    func EventListCell_btnSelecteventAction(button: UIButton) {
        let ind:Int = Int(button.accessibilityIdentifier!)!
        let dict = arrEvent[ind]
        let eventDetailVC = EventDetailViewController(nibName: "EventDetailViewController", bundle: nil)
        eventDetailVC.operatorID = dict[RES_operatorID] as! String
        obj_AppDelegate.navigationController.pushViewController(eventDetailVC, animated: true)
    }
}
