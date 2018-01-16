//
//  OrderDetailViewController.swift
//  Cubber
//
//  Created by dnk on 02/09/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit
import ImageIO
import ModelIO

class OrderDetailViewController: UIViewController , AppNavigationControllerDelegate , UIDocumentInteractionControllerDelegate , OrderDetailCellDelegate , VKPopoverDelegate , FlightCancelViewDelegate{
    
    //MARK: PROPERTIES
    @IBOutlet var viewBG: UIView!
    @IBOutlet var scrollViewBG: UIScrollView!
    
    @IBOutlet var viewCollection: [UIView]!
    
    
    //STATUS
    @IBOutlet var viewOrderStatusBG: UIView!
    @IBOutlet var viewImageStatusBG: UIView!
    @IBOutlet var imageViewStatus: UIImageView!
    @IBOutlet var lblOrderTitle: UILabel!
    @IBOutlet var constraintViewImageStatusBGHeight: NSLayoutConstraint!
    
    @IBOutlet var constraintStatus_LblOrderTitleTopToSuper: NSLayoutConstraint!
    
    @IBOutlet var constraintStatus_lblOrdertitleTopToImageViewStatus: NSLayoutConstraint!
    
    @IBOutlet var constraintLblCouponCodeWidth: NSLayoutConstraint!
    
    
    //ORDER INFO
    @IBOutlet var viewOrderInfoBG: UIView!
    @IBOutlet var lblOrderNumber: UILabel!
    @IBOutlet var lblOrderDate: UILabel!
    @IBOutlet var tableViewItems: UITableView!
    @IBOutlet var constraintTableViewItemsHeight: NSLayoutConstraint!
    
    //INVOICE
    @IBOutlet var viewInvoiceBG: UIView!
    @IBOutlet var btnInvoice: UIButton!
    @IBOutlet var constraintViewInvoiceBGHeight: NSLayoutConstraint!
    
    //COUPON VIEW
    @IBOutlet var lblCouponCode: UILabel!
    @IBOutlet var lblCouponDescription: UILabel!
    @IBOutlet var viewCouponInfoBG: UIView!
    @IBOutlet var constraintViewSummaryTitleTopToViewInvoice: NSLayoutConstraint!
    @IBOutlet var constraintViewSummaryTitleTopToViewCouponInfo: NSLayoutConstraint!
    
    //CANCELLATION DETAILS
    @IBOutlet var viewCancellationDetails: UIView!
    @IBOutlet var lblSeatNo: UILabel!
    @IBOutlet var lblRefundAmount: UILabel!
    @IBOutlet var lblDeductedAmount: UILabel!
    
    //FEEDBACK
    @IBOutlet var viewFeedBackBG: UIView!
    @IBOutlet var viewComment: UIView!
    @IBOutlet var viewRating: UIView!
    @IBOutlet var butttonRatingCollection: [UIButton]!
    @IBOutlet var txtFeedback: UITextField!
    
    @IBOutlet var constraintViewSummaryLineTopToViewFeedback: NSLayoutConstraint!
    @IBOutlet var constraintViewSummary_LineToSuper: NSLayoutConstraint!
    @IBOutlet var constraintViewCommentLeading: NSLayoutConstraint!
    
    //SUMMARY
    @IBOutlet var viewSummaryTitle: UIView!
    @IBOutlet var viewSummaryBG: UIView!
    @IBOutlet var viewSummary_SubTotalBG: UIView!
    
    @IBOutlet var viewSummary_OrderTotalBG: UIView!
    
    @IBOutlet var tableviewSummary: UITableView!
    
    @IBOutlet var lblSummary_OrderTotal: UILabel!
    
    @IBOutlet var constraintSummary_ViewOrderTotalTopToViewSubTotal: NSLayoutConstraint!
    @IBOutlet var constraintViewSummaryTitleTopToLblNote: NSLayoutConstraint!
    
    @IBOutlet var constraintTableViewSummaryHeight: NSLayoutConstraint!
    
    //PAYMENT DETAILS
    @IBOutlet var viewPaymentDetailTitle: UIView!
    @IBOutlet var viewPaymentDetailBG: UIView!
    @IBOutlet var viewPaidAmountTransactionNoBG: UIView!
    @IBOutlet var viewWalletAmountTransactionNoBG: UIView!
    @IBOutlet var constraintPaidTransactionHeight: NSLayoutConstraint!
    
    @IBOutlet var constraintViewWalletIdHeight: NSLayoutConstraint!
    
    @IBOutlet var lblNote: UILabel!
    @IBOutlet var lblPaidAmountTransactionNO: UILabel!
    @IBOutlet var lblWalletAmountTransactionNo: UILabel!
    @IBOutlet var lblPaymentsDetail_PaidAmount: UILabel!
    @IBOutlet var lblPaymentDetaill_WalletAmount: UILabel!
    
    @IBOutlet var imageView_TrustedLogo: UIImageView!
    @IBOutlet var viewContactUsTitle: UIView!
    @IBOutlet var viewContactUsBG: UIView!
    @IBOutlet var constraintLblNoteHeight: NSLayoutConstraint!
    
    @IBOutlet var constraintViewContactUsTitleTopToLblNote: NSLayoutConstraint!
    @IBOutlet var constraintViewContactUsTitleTopToViewPaymentDetails: NSLayoutConstraint!
    @IBOutlet var constraintViewContactUsTitleTopToViewSummary: NSLayoutConstraint!
    
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate var _VKPopOver = VKPopover()
    fileprivate var _KDAlertView = KDAlertView()
    internal var orderId: String = ""
    internal var isOrderDetailFromOrderHistory = false
    internal var _RECHARGE_TYPE: RECHARGE_TYPE = RECHARGE_TYPE.DUMMY
    internal var dictOrderDetail = typeAliasDictionary()
    fileprivate var arrItems = [typeAliasDictionary]()
    fileprivate let userInfo: typeAliasDictionary = DataModel.getUserInfo()
    internal var isShowAppReview = false
    internal var eventVenue = "Not Defined"
    var alertMessage:String = ""
    internal var isCancelTicket = false
    fileprivate var dictCancellationDetails = typeAliasStringDictionary()
    fileprivate var arrServices = [typeAliasDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableViewItems.rowHeight = UITableViewAutomaticDimension
        self.tableViewItems.estimatedRowHeight = HEIGHT_ORDER_DETAIL_CELL
        self.tableViewItems.tableFooterView = UIView(frame: CGRect.zero)
        self.tableViewItems.separatorColor = RGBCOLOR(170, g: 170, b: 170)
        
        self.tableviewSummary.rowHeight = 40
        self.tableviewSummary.tableFooterView = UIView(frame: CGRect.zero)
        self.tableviewSummary.separatorColor = RGBCOLOR(170, g: 170, b: 170)
        self.tableviewSummary.register(UINib.init(nibName: CELL_IDENTIFIER_ORDER_DETAIL_SUMMARY_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_ORDER_DETAIL_SUMMARY_CELL)
        
        self.hideFeedbackView()
        self.tableViewItems.register(UINib.init(nibName: CELL_IDENTIFIER_ORDER_DETAIL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_ORDER_DETAIL)
        
        self.imageView_TrustedLogo.sd_setImage(with: DataModel.getTrustedLogo().convertToUrl() as URL!, placeholderImage: nil, options: SDWebImageOptions.progressiveDownload, progress:
            { (receivedSize, expectedSize) in
                
        })
        { (image, error, cacheType, imageURL) in
            
            if image == nil {
                self.imageView_TrustedLogo.image = UIImage(named: "icon_trusted_logo")
            }
            else {
                self.imageView_TrustedLogo.image = image!
            }
        }
        
        if !self.isOrderDetailFromOrderHistory {
            NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFICATION_RELOAD_WALLET), object: nil)
            obj_AppDelegate.setOrderBackView(self._RECHARGE_TYPE)
        }
        self.callSingleOrderDetailService(false)
        // self.callGetOrderStatusService(false)
        scrollViewBG.alpha = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.registerForKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    //MARK: KEYBOARD
    fileprivate func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    internal func keyboardWasShown(_ aNotification: Notification) {
        let info: [AnyHashable: Any] = (aNotification as NSNotification).userInfo!;
        var keyboardRect: CGRect = ((info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue)
        keyboardRect = self.view.convert(keyboardRect, from: nil);
        
        var contentInset: UIEdgeInsets = scrollViewBG.contentInset
        contentInset.bottom = keyboardRect.size.height
        scrollViewBG.contentInset = contentInset
    }
    
    internal func keyboardWillBeHidden(_ aNotification: Notification) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            self.scrollViewBG.contentInset = UIEdgeInsets.zero
        }, completion: nil)
    }
    
    
    //MARK: APPNAVIGATION CONTROLLER METHOD
    func setNavigationBar() {
        
        obj_AppDelegate.navigationController.setCustomTitle("Order Summary")
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.setRightButton(image: "icon_share")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_BackAction() {
        if isOrderDetailFromOrderHistory{
            let _ = self.navigationController?.popViewController(animated: true)}
        else{obj_AppDelegate.onVKFooterAction(.HOME)}
    }
    
    func appNavigationController_RightMenuAction() {
        
        constraintViewInvoiceBGHeight.constant = 0
        let orderStatus: Int = (Int(self.dictOrderDetail[RES_orderStatusID] as! String))!
        if orderStatus == ORDER_STATUS.FAILED.rawValue { return }
        self.viewInvoiceBG.isHidden = true
        self.viewContactUsTitle.isHidden = true
        self.viewContactUsBG.isHidden = true
        self.scrollViewBG.setContentOffset(CGPoint.zero, animated: false)
        self.view.layoutIfNeeded()
        let imageFull = self.viewBG.takeSnapshot(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: viewPaymentDetailTitle.frame.minY))
        let scale = imageFull.scale
        //UIImageWriteToSavedPhotosAlbum(imageFull, nil, nil, nil)
        
        //Upper
        let rect = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.tableViewItems.frame.maxY + 20 )
        let scaledRect = CGRect(x: rect.origin.x * scale, y: rect.origin.y * scale, width: rect.size.width * scale, height: rect.size.height * scale)
        let full:UIImage = imageFull
        let imageRefUpper: CGImage = full.cgImage!.cropping(to:scaledRect)!
        
        
        //Bottom
        
        let rectBottom =  CGRect.init(x: 0, y: viewCouponInfoBG.frame.origin.y - 10, width: UIScreen.main.bounds.width, height: viewPaymentDetailBG.frame.maxY - viewCouponInfoBG.frame.origin.y)
        let bottomImage:UIImage = UIImage.init(cgImage: imageFull.cgImage!.cropping(to:rectBottom)!)
        
        // MERGE
        
        let topImage = UIImage.init(cgImage: imageRefUpper)
        
        let size = CGSize.init(width: topImage.size.width, height: topImage.size.height + bottomImage.size.height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        topImage.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: topImage.size.height))
        bottomImage.draw(in: CGRect.init(x: 0, y: topImage.size.height, width: size.width, height: bottomImage.size.height))
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        constraintViewInvoiceBGHeight.constant = 40
        self.viewInvoiceBG.isHidden = false
        self.viewContactUsTitle.isHidden = false
        self.viewContactUsBG.isHidden = false
        
        let objectToShare:[Any] = [imageFull]
        let activityVC = UIActivityViewController.init(activityItems: objectToShare, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
        
    }
    
    //MARK: CUSTOM METHODS
    
    @IBAction func btnConfirmCancelationAction() {
        _VKPopOver.closeVKPopoverAction()
        self.callConfirmCancellationService()
    }
    
    @IBAction func btnContactUsAction() {
        
        let dictItem = dictOrderDetail[RES_items]?.lastObject
        let registerProblemVC = RegisterProblemViewController(nibName: "RegisterProblemViewController", bundle: nil)
        registerProblemVC.OrderItems = dictItem as! typeAliasDictionary
        self.navigationController?.pushViewController(registerProblemVC, animated: true)
    }
    
    
    @IBAction func btnInvoiceAction() {
        
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_USER_ID: userInfo[RES_userID] as! String,
                      REQ_ORDER_ID: self.orderId]
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_generateInvoice, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: self.navigationController!.view, onSuccess: { (dict) in
            
            DataModel.setHeaderToken(dict[RES_token] as! String)
            let invoicUrl: String = dict[RES_invoice_url] as! String
            if (!invoicUrl.characters.isEmpty) {
                let webPreviewVC = WebPreviewViewController(nibName: "WebPreviewViewController", bundle: nil)
                webPreviewVC.isShowToolBar = false
                webPreviewVC.stUrl = invoicUrl
                webPreviewVC.stTitle = "Payment Receipt"
                webPreviewVC.isShowSave = true
                self.navigationController?.pushViewController(webPreviewVC, animated: true)}
        }, onFailure: { (code , dict) in
            
        }) {
            self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return
            
        }
    }
    
    
    func setStaticImage(imageName:String) {
        
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: imageName, withExtension: "gif")!)
        guard let source = CGImageSourceCreateWithData(imageData as! CFData, nil) else {
            print("SwiftGif: Source for the image does not exist")
            return
        }
        let count = CGImageSourceGetCount(source)
        var images = [UIImage]()
        
        for i in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }
            
        }
        imageViewStatus.image = images.first
        imageViewStatus.animationImages = images
        imageViewStatus.animationDuration =  4.0
        imageViewStatus.startAnimating()
    }
    
    fileprivate func callGetOrderStatusService(_ isRepeat:Bool) {
        
        let view = isRepeat ? UIView.init() : self.navigationController!.view
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_USER_ID: userInfo[RES_userID] as! String,
                      REQ_ORDER_ID: self.orderId]
        
        self.obj_OperationWeb.callRestApi(methodName: JMETHOD_GetOrderStatus, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: view!, onSuccess: { (dict) in
            DataModel.setHeaderToken(dict[RES_token] as! String)
            let dictOrder:typeAliasDictionary =  dict[RES_order] as! typeAliasDictionary
            self.dictOrderDetail = dictOrder[RES_order_detail] as! typeAliasDictionary
            let orderType = Int(self.dictOrderDetail[RES_orderTypeID] as! String)!
            if  orderType == RECHARGE_TYPE.BUS_BOOKING.rawValue ||  orderType == RECHARGE_TYPE.FLIGHT_BOOKING.rawValue
            { self.isCancelTicket = dict[RES_isCancel] as! String == "0" ? false : true }
            self.alertMessage = dict.isKeyNull(RES_failedAlertMessaage) ? "" : dict[RES_failedAlertMessaage] as! String
            self.setOrderDetail()
            
        }, onFailure: { (code, dict) in
            
        }) { self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return  }
    }
    
    fileprivate func callSingleOrderDetailService(_ isRepeat:Bool) {
        
        let view = isRepeat ? UIView.init() : self.navigationController!.view
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_USER_ID: userInfo[RES_userID] as! String,
                      REQ_ORDER_ID: self.orderId]
        
        self.obj_OperationWeb.callRestApi(methodName: JMETHOD_SingleOrderDetails, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: view!, onSuccess: { (dict) in
            DataModel.setHeaderToken(dict[RES_token] as! String)
            let dictOrder:typeAliasDictionary =  dict[RES_order] as! typeAliasDictionary
            self.dictOrderDetail = dictOrder[RES_order_detail] as! typeAliasDictionary
            let orderType = Int(self.dictOrderDetail[RES_orderTypeID] as! String)!
            if  orderType == RECHARGE_TYPE.BUS_BOOKING.rawValue ||  orderType == RECHARGE_TYPE.FLIGHT_BOOKING.rawValue
            { self.isCancelTicket = dict[RES_isCancel] as! String == "0" ? false : true }
            self.setOrderDetail()
            
        }, onFailure: { (code, dict) in
            
        }) { self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return }
    }
    
    func setOrderDetail() {
        
        tableviewSummary.reloadData()
        self.constraintTableViewSummaryHeight.constant = CGFloat(40 * arrServices.count)
        self.arrItems = self.dictOrderDetail[RES_items] as! Array<typeAliasDictionary>
        
        let stStatus: String = dictOrderDetail[RES_orderStatus] as! String
        self.lblOrderTitle.text = "Payment of \(RUPEES_SYMBOL) \(self.dictOrderDetail[RES_topDisplayAmount] as! String) \(stStatus) !"
        
        self.lblOrderNumber.text = self.dictOrderDetail[RES_orderID] as? String
        let subTotal:Double = Double(self.dictOrderDetail[RES_orderTotalAmount] as! String)!
        
        self.lblOrderDate.text = self.dictOrderDetail[RES_orderDate] as? String
        if self.dictOrderDetail[RES_orderNote] as! String != "" {
            self.lblNote.text = self.dictOrderDetail[RES_orderNote] as? String
            self.constraintLblNoteHeight.constant = (self.lblNote.text?.textHeight(self.lblNote.frame.width, textFont: self.lblNote.font))! + 10
        }
        UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.beginFromCurrentState, animations: { self.tableViewItems.reloadData() }) { (finished) in self.constraintTableViewItemsHeight.constant = self.tableViewItems.contentSize.height }
        let orderStatus: Int = (Int(self.dictOrderDetail[RES_orderStatusID] as! String))!
        
        if !self.isOrderDetailFromOrderHistory && (orderStatus == ORDER_STATUS.SUCCESS.rawValue || orderStatus == ORDER_STATUS.FAILED.rawValue || orderStatus == ORDER_STATUS.REFUNDED.rawValue || orderStatus == ORDER_STATUS.CANCELLED.rawValue || orderStatus == ORDER_STATUS.REFUND_TO_BANK.rawValue) {
            self.pushCheckOutComplete(orderDetail: self.dictOrderDetail)
        }
        
        if orderStatus == ORDER_STATUS.SUCCESS.rawValue {
            
            self.lblOrderTitle.textColor = COLOUR_DARK_GREEN
            for view in viewCollection {
                view.isHidden = false
            }
            self.imageViewStatus.stopAnimating()
            self.constraintViewContactUsTitleTopToViewSummary.priority = PRIORITY_LOW
            self.constraintViewContactUsTitleTopToViewPaymentDetails.priority = PRIORITY_HIGH
            self.constraintViewContactUsTitleTopToLblNote.priority = PRIORITY_LOW
            
            self.viewImageStatusBG.isHidden = true
            self.constraintStatus_LblOrderTitleTopToSuper.priority = PRIORITY_HIGH
            self.constraintStatus_lblOrdertitleTopToImageViewStatus.priority = PRIORITY_LOW
            
            if Int(self.dictOrderDetail[RES_couponID] as! String)! == 0 {
                self.constraintViewSummaryTitleTopToViewInvoice.priority = PRIORITY_HIGH
                self.constraintViewSummaryTitleTopToViewCouponInfo.priority = PRIORITY_LOW
                self.constraintViewSummaryTitleTopToLblNote.priority = PRIORITY_LOW
                viewCouponInfoBG.isHidden = true
            }
            else {
                self.constraintViewSummaryTitleTopToViewInvoice.priority = PRIORITY_LOW
                self.constraintViewSummaryTitleTopToViewCouponInfo.priority = PRIORITY_HIGH
                self.constraintViewSummaryTitleTopToLblNote.priority = PRIORITY_LOW
                viewCouponInfoBG.isHidden = false
                self.lblCouponCode.text = self.dictOrderDetail[RES_couponCode] as? String
                constraintLblCouponCodeWidth.constant = (self.lblCouponCode.text?.textWidth(self.lblCouponCode.frame.height, textFont: self.lblCouponCode.font))! + SIZE_EXTRA_TEXT
                self.lblCouponDescription.text = self.dictOrderDetail[RES_promoNote] as? String
            }
            
            //RATING POP UP 
            if !self.isOrderDetailFromOrderHistory && DataModel.getIsShowReviewPrompt() && !DataModel.getIsNeverShowReviewPrompt() {
                let st = "If you enjoy this app, Please take a moment to rate this app.It won't take more than a minute.Thank you for your support!"
                _KDAlertView.showMessage(message: st, messageType: .RATING)
            }
            
            if !self.isOrderDetailFromOrderHistory {
                self.showFeedBackView()
            }
            
            //SUMMARY
            let stSubTotal = String.init(format: "%.2f", subTotal)
            arrServices = dictOrderDetail[RES_services] as! [typeAliasDictionary]
            tableviewSummary.reloadData()
            self.constraintTableViewSummaryHeight.constant = CGFloat(40 * arrServices.count)
            lblSummary_OrderTotal.text = "\(RUPEES_SYMBOL) \(stSubTotal)"
            
            //PAYMENTS DETAILS
            
            let stTransactionNo: String = self.dictOrderDetail[RES_bankTxnID] as! String
            let walletID:String = self.dictOrderDetail[RES_walletID] as! String
            
            if Int(stTransactionNo) == 0 || stTransactionNo == "" {
                constraintPaidTransactionHeight.constant = 0
                viewPaidAmountTransactionNoBG.isHidden = true
            }
            else {
                constraintPaidTransactionHeight.constant = 40
                viewPaidAmountTransactionNoBG.isHidden = false
                lblPaidAmountTransactionNO.text = "Paid Txn No: \(stTransactionNo)"
                lblPaymentsDetail_PaidAmount.text = "\(RUPEES_SYMBOL)\(dictOrderDetail[RES_orderAmount]!)"
            }
            
            if Int(walletID) == 0 || walletID == "" {
                constraintViewWalletIdHeight.constant = 0
                viewWalletAmountTransactionNoBG.isHidden = true
            }
            else {
                constraintViewWalletIdHeight.constant = 40
                viewWalletAmountTransactionNoBG.isHidden = false
                lblWalletAmountTransactionNo.text =  "Wallet Txn\(walletID)"
                lblPaymentDetaill_WalletAmount.text = "\(RUPEES_SYMBOL)\(dictOrderDetail[RES_walletAmount]!)"
            }
            
            if constraintViewWalletIdHeight.constant == 0 &&  constraintPaidTransactionHeight.constant == 0 {
                constraintViewContactUsTitleTopToViewPaymentDetails.priority = PRIORITY_LOW
                constraintViewContactUsTitleTopToViewSummary.priority = PRIORITY_HIGH
                constraintViewContactUsTitleTopToLblNote.priority = PRIORITY_LOW
            }
            else {
                constraintViewContactUsTitleTopToViewPaymentDetails.priority = PRIORITY_HIGH
                constraintViewContactUsTitleTopToViewSummary.priority = PRIORITY_LOW
                constraintViewContactUsTitleTopToLblNote.priority = PRIORITY_LOW
            }
        }
            
        else if orderStatus == ORDER_STATUS.AWAITING.rawValue {
            
            self.lblOrderTitle.textColor = COLOUR_ORDER_STATUS_AWAITING
            
            //COUPON INFO
            if Int(self.dictOrderDetail[RES_couponID] as! String)! == 0 {
                self.constraintViewSummaryTitleTopToViewInvoice.priority = PRIORITY_HIGH
                self.constraintViewSummaryTitleTopToViewCouponInfo.priority = PRIORITY_LOW
                viewCouponInfoBG.isHidden = true
            }
            else {
                self.constraintViewSummaryTitleTopToViewInvoice.priority = PRIORITY_LOW
                self.constraintViewSummaryTitleTopToViewCouponInfo.priority = PRIORITY_HIGH
                viewCouponInfoBG.isHidden = false
                self.lblCouponCode.text = self.dictOrderDetail[RES_couponCode] as? String
                constraintLblCouponCodeWidth.constant = (self.lblCouponCode.text?.textWidth(self.lblCouponCode.frame.height, textFont: self.lblCouponCode.font))! + SIZE_EXTRA_TEXT
                self.lblCouponDescription.text = self.dictOrderDetail[RES_promoNote] as? String
            }
            
            for view in viewCollection {
                view.isHidden = true
            }
            
            setStaticImage(imageName: "watch")
            
            self.viewImageStatusBG.isHidden = false
            self.constraintStatus_LblOrderTitleTopToSuper.priority = PRIORITY_LOW
            self.constraintStatus_lblOrdertitleTopToImageViewStatus.priority = PRIORITY_HIGH
            
            self.constraintViewContactUsTitleTopToLblNote.priority = PRIORITY_HIGH
            self.constraintViewContactUsTitleTopToViewSummary.priority = PRIORITY_LOW
            self.constraintViewContactUsTitleTopToViewPaymentDetails.priority = PRIORITY_LOW
           
            //UNCOMMENT IT
            self.callGetOrderStatusService(true)
            
        }
            
        else if orderStatus == ORDER_STATUS.PROCESSING.rawValue {
            
            setStaticImage(imageName: "watch")
            self.viewImageStatusBG.isHidden = false
            self.constraintStatus_LblOrderTitleTopToSuper.priority = PRIORITY_LOW
            self.constraintStatus_lblOrdertitleTopToImageViewStatus.priority = PRIORITY_HIGH
            self.lblOrderTitle.textColor = COLOUR_ORDER_STATUS_PROCESSING
        }
            
        else if orderStatus == ORDER_STATUS.QUEUED.rawValue  || orderStatus == ORDER_STATUS.REFUNDED.rawValue || ( orderStatus == ORDER_STATUS.CANCELLED.rawValue && Int(self.dictOrderDetail[RES_orderTypeID] as! String) == Int(VAL_ORDERTYPE_FLIGHT))  {
            
            self.imageViewStatus.stopAnimating()
            self.lblOrderTitle.textColor = COLOUR_ORDER_STATUS_REFUNDED
            self.lblOrderTitle.backgroundColor = .white
            for view in viewCollection {
                view.isHidden = false
            }
            self.constraintViewContactUsTitleTopToViewSummary.priority = PRIORITY_LOW
            self.constraintViewContactUsTitleTopToViewPaymentDetails.priority = PRIORITY_HIGH
            self.constraintViewContactUsTitleTopToLblNote.priority = PRIORITY_LOW
            
            self.viewImageStatusBG.isHidden = true
            self.constraintStatus_LblOrderTitleTopToSuper.priority = PRIORITY_HIGH
            self.constraintStatus_lblOrdertitleTopToImageViewStatus.priority = PRIORITY_LOW
            
            //COUPON INFO
            if Int(self.dictOrderDetail[RES_couponID] as! String)! == 0  {
                self.constraintViewSummaryTitleTopToViewInvoice.priority = PRIORITY_LOW
                self.constraintViewSummaryTitleTopToViewCouponInfo.priority = PRIORITY_LOW
                self.constraintViewSummaryTitleTopToLblNote.priority = PRIORITY_HIGH
                viewCouponInfoBG.isHidden = true
            }
            else {
                self.constraintViewSummaryTitleTopToViewInvoice.priority = PRIORITY_LOW
                self.constraintViewSummaryTitleTopToViewCouponInfo.priority = PRIORITY_LOW
                self.constraintViewSummaryTitleTopToLblNote.priority = PRIORITY_HIGH
                viewCouponInfoBG.isHidden = false
                self.lblCouponCode.text = self.dictOrderDetail[RES_couponCode] as? String
                self.lblCouponDescription.text = self.dictOrderDetail[RES_promoNote] as? String
            }
            
            if orderStatus == ORDER_STATUS.CANCELLED.rawValue && Int(self.dictOrderDetail[RES_orderTypeID] as! String) == Int(VAL_ORDERTYPE_FLIGHT) {
                
                if viewCouponInfoBG.isHidden {
                    self.constraintViewSummaryTitleTopToViewCouponInfo.priority = PRIORITY_LOW
                    self.constraintViewSummaryTitleTopToViewInvoice.priority = PRIORITY_HIGH
                }
                else{
                    self.constraintViewSummaryTitleTopToViewCouponInfo.priority = PRIORITY_HIGH
                    self.constraintViewSummaryTitleTopToViewInvoice.priority = PRIORITY_LOW
                }
                self.constraintViewSummaryTitleTopToLblNote.priority = PRIORITY_LOW
            }
            
            //SUMMARY
            
            let stSubTotal = String.init(format: "%.2f", subTotal)
            arrServices = dictOrderDetail[RES_services] as! [typeAliasDictionary]
            tableviewSummary.reloadData()
            self.constraintTableViewSummaryHeight.constant = CGFloat(40 * arrServices.count)
            lblSummary_OrderTotal.text = "\(RUPEES_SYMBOL) \(stSubTotal)"
            
            //PAYMENTS DETAILS
            
            let stTransactionNo: String = self.dictOrderDetail[RES_bankTxnID] as! String
            let walletID:String = self.dictOrderDetail[RES_walletID] as! String
            
            if Int(stTransactionNo) == 0 || stTransactionNo == "" {
                constraintPaidTransactionHeight.constant = 0
                viewPaidAmountTransactionNoBG.isHidden = true
            }
            else {
                constraintPaidTransactionHeight.constant = 40
                viewPaidAmountTransactionNoBG.isHidden = false
                lblPaidAmountTransactionNO.text = stTransactionNo
            }
            
            if Int(walletID) == 0 || walletID == "" {
                constraintViewWalletIdHeight.constant = 0
                viewWalletAmountTransactionNoBG.isHidden = true
            }
            else {
                constraintViewWalletIdHeight.constant = 40
                viewWalletAmountTransactionNoBG.isHidden = false
                lblWalletAmountTransactionNo.text = walletID
            }
            
            if constraintViewWalletIdHeight.constant == 0 &&  constraintPaidTransactionHeight.constant == 0 {
                constraintViewContactUsTitleTopToViewPaymentDetails.priority = PRIORITY_LOW
                constraintViewContactUsTitleTopToViewSummary.priority = PRIORITY_HIGH
                constraintViewContactUsTitleTopToLblNote.priority = PRIORITY_LOW
            }
            else {
                constraintViewContactUsTitleTopToViewPaymentDetails.priority = PRIORITY_HIGH
                constraintViewContactUsTitleTopToViewSummary.priority = PRIORITY_LOW
                constraintViewContactUsTitleTopToLblNote.priority = PRIORITY_LOW
            }
        }
            
        else {
            
            self.imageViewStatus.stopAnimating()
            if orderStatus == ORDER_STATUS.CANCELLED.rawValue {
                self.lblOrderTitle.textColor = COLOUR_ORDER_STATUS_CANCELLED
            }
            else if orderStatus == ORDER_STATUS.FAILED.rawValue {
                self.lblOrderTitle.textColor = COLOUR_ORDER_STATUS_FAILURE
            }
            
            self.viewImageStatusBG.isHidden = true
            self.constraintStatus_LblOrderTitleTopToSuper.priority = PRIORITY_HIGH
            self.constraintStatus_lblOrdertitleTopToImageViewStatus.priority = PRIORITY_LOW
            
            for view in viewCollection {
                view.isHidden = true
            }
            self.constraintViewContactUsTitleTopToLblNote.priority = PRIORITY_HIGH
            self.constraintViewContactUsTitleTopToViewSummary.priority = PRIORITY_LOW
            self.constraintViewContactUsTitleTopToViewPaymentDetails.priority = PRIORITY_LOW
        }
        
        if orderStatus == ORDER_STATUS.FAILED.rawValue
        {
            self.navigationItem.rightBarButtonItem = nil
            if !isOrderDetailFromOrderHistory && alertMessage != "" && alertMessage != "0" { _KDAlertView.showWebViewAlert(stMessage: alertMessage, messageType: .INTERNET_WARNING, stTitle: "Cubber")}
        }
        else {self.setNavigationBar()}
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: { self.scrollViewBG.alpha = 1 }, completion: nil)
    }
    
    fileprivate func showCancellationDetail(){
        
        lblSeatNo.text = dictCancellationDetails[RES_SeatNames]
        lblRefundAmount.text = RUPEES_SYMBOL + " " + dictCancellationDetails[RES_RefundAmount]!
        lblDeductedAmount.text = RUPEES_SYMBOL + " " + dictCancellationDetails[RES_cancellationCharges]!
        _VKPopOver = VKPopover.init(self.viewCancellationDetails, animation: POPOVER_ANIMATION.popover_ANIMATION_CROSS_DISSOLVE, animationDuration: 0.3, isBGTransparent: false, borderColor: .clear, borderWidth: 0, borderCorner: 5, isOutSideClickedHidden: true)
        _VKPopOver.delegate = self
        obj_AppDelegate.navigationController.view.addSubview(_VKPopOver)
        
    }
    
    fileprivate func callConfirmCancellationService() {
        
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_USER_ID: userInfo[RES_userID] as! String,
                      REQ_ORDER_ID: self.orderId,
                      REQ_PNR_NO:  dictOrderDetail[RES_operatorRefNo] as! String] as [String : Any]
        
        self.obj_OperationWeb.callRestApi(methodName: JMETHOD_ConfirmCancellation, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params as! typeAliasStringDictionary, viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
            
            //GTM PUSH REFUND FOR BUS
            let dictRefundDetails = dict[RES_refundDetails] as! typeAliasDictionary
            let gtmModel = GTMModel()
            let dictItem: typeAliasDictionary = self.arrItems[0]
            gtmModel.id = self.orderId
            gtmModel.product_Id = self.userInfo[RES_userID] as! String
            gtmModel.quantity = dictItem.isKeyNull(RES_qty) ? 1 : Int(dictItem[RES_qty] as! String)!
            gtmModel.price = dictRefundDetails[RES_RefundAmount] as! String
            GTMModel.pushPartialRefund(gtmModel: gtmModel)
            
            self.callGetOrderStatusService(false)
            
        }, onFailure: { (code, dict) in
            self._KDAlertView.showMessage(message: dict[RES_message] as! String, messageType: .WARNING)
        }) { self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return  }
    }
    
    fileprivate func callGetCancelDetail() {
        
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_USER_ID: userInfo[RES_userID] as! String,
                      REQ_ORDER_ID: self.orderId,
                      REQ_PNR_NO: dictOrderDetail[RES_operatorRefNo] as! String ] as [String : Any]
        
        self.obj_OperationWeb.callRestApi(methodName: JMETHOD_GetCancelDetails, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params as! typeAliasStringDictionary, viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
            self.dictCancellationDetails = dict[RES_refundDetails] as! typeAliasStringDictionary
            self.showCancellationDetail()
        }, onFailure: { (code, dict) in
            self._KDAlertView.showMessage(message: dict[RES_message] as! String, messageType: .WARNING)
        }) { self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return  }
    }
    
    fileprivate func callCancelOrderService(orderId:String) {
        
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_USER_ID: userInfo[RES_userID] as! String,
                      REQ_ORDER_ID: self.orderId]
        
        self.obj_OperationWeb.callRestApi(methodName: JMETHOD_CancelOrderRefund, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params , viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
            self.callSingleOrderDetailService(false)
        }, onFailure: { (code, dict) in
            self._KDAlertView.showMessage(message: dict[RES_message] as! String, messageType: .WARNING)
        }) { self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return }
    }
    
    fileprivate func showRechargeView(_ button: UIButton) {
        
        let gtmModel = GTMModel()
        
        let index: Int = Int(button.accessibilityIdentifier!)!
        let dictItem = self.arrItems[index] as typeAliasDictionary
        let category: String = dictOrderDetail[RES_orderTypeID] as! String
        
        let rechargeVC = RechargeViewController(nibName: "RechargeViewController", bundle: nil)
       
        if category == VAL_ORDERTYPE_MOBILE
        {
            let cartPrepaidPostpaid: String = dictOrderDetail[RES_subCategoryId] as! String
            
            rechargeVC.mobile_CardOperator = dictOrderDetail[RES_operatorName] as! String
            rechargeVC.mobile_CardRegionName = dictOrderDetail[RES_regionName] as! String
            rechargeVC.mobile_CardPrepaidPostpaid = cartPrepaidPostpaid == VAL_RECHARGE_PREPAID ? "Prepaid" : "Postpaid"
            rechargeVC.cart_PrepaidPostpaid = cartPrepaidPostpaid
            rechargeVC.cart_PlanTypeID = dictOrderDetail[RES_planTypeId] as! String
            rechargeVC.cart_MobileNo = dictOrderDetail[RES_mobileNo] as! String
            rechargeVC.cart_TotalAmount = dictItem[RES_amount] as! String
            rechargeVC.cart_OperatorId = dictOrderDetail[RES_operatorID] as! String
            rechargeVC.cart_RegionId = dictOrderDetail[RES_regionID] as! String
            rechargeVC.cart_CategoryId = dictOrderDetail[RES_operatorCategoryMasterId] as! String
            rechargeVC.cart_RegionPlanId =  dictItem[RES_regionPlanID] as! String
            rechargeVC.cart_PlanValue =  dictItem[RES_amount] as! String
            rechargeVC.cart_Extra1 = dictItem[RES_extra1] as! String
            rechargeVC.cart_Extra2 = dictItem[RES_extra2] as! String
            rechargeVC._RECHARGE_TYPE = RECHARGE_TYPE.MOBILE_RECHARGE
            
             gtmModel.list = "Mobile Section"
        }
        else if category == VAL_ORDERTYPE_DTH {
            
            rechargeVC.mobile_CardOperator = dictOrderDetail[RES_operatorName] as! String
            rechargeVC.mobile_CardRegionName = dictOrderDetail[RES_regionName] as! String
            rechargeVC.mobile_CardPrepaidPostpaid = VAL_RECHARGE_PREPAID_CAPTION
            rechargeVC.cart_PrepaidPostpaid = VAL_RECHARGE_PREPAID
            rechargeVC.cart_PlanTypeID = dictOrderDetail[RES_planTypeId] as! String
            rechargeVC.cart_MobileNo = dictOrderDetail[RES_mobileNo] as! String
            rechargeVC.cart_TotalAmount = dictItem[RES_amount] as! String
            rechargeVC.cart_OperatorId = dictOrderDetail[RES_operatorID] as! String
            rechargeVC.cart_RegionId = dictOrderDetail[RES_regionID] as! String
            rechargeVC.cart_CategoryId = dictOrderDetail[RES_operatorCategoryMasterId] as! String
            rechargeVC.cart_Extra1 = dictItem[RES_extra1] as! String
            rechargeVC.cart_Extra2 = dictItem[RES_extra2] as! String
            rechargeVC.cart_RegionPlanId =  dictItem[RES_regionPlanID] as! String
            rechargeVC.cart_PlanValue =  dictItem[RES_amount] as! String
            rechargeVC._RECHARGE_TYPE = RECHARGE_TYPE.DTH_RECHARGE
             gtmModel.list = "DTH Section"
        }
            
        else if category == VAL_ORDERTYPE_LANDLINE {
            
            rechargeVC.mobile_CardOperator = dictOrderDetail[RES_operatorName] as! String
            rechargeVC.mobile_CardRegionName = dictOrderDetail[RES_regionName] as! String
            rechargeVC.mobile_CardPrepaidPostpaid = VAL_RECHARGE_POSTPAID_CAPTION
            rechargeVC.cart_PrepaidPostpaid = VAL_RECHARGE_POSTPAID
            rechargeVC.cart_PlanTypeID = "0"
            rechargeVC.cart_TotalAmount = dictItem[RES_amount] as! String
            rechargeVC.cart_OperatorId = dictOrderDetail[RES_operatorID] as! String
            rechargeVC.cart_RegionId = dictOrderDetail[RES_regionID] as! String
            rechargeVC.cart_CategoryId = dictOrderDetail[RES_operatorCategoryMasterId] as! String
            rechargeVC.cart_Extra1 = dictItem[RES_extra1] as! String
            rechargeVC.cart_Extra2 = dictItem[RES_extra2] as! String
            rechargeVC.cart_RegionPlanId = "0"
            rechargeVC.cart_PlanValue =  dictItem[RES_amount] as! String
            rechargeVC._RECHARGE_TYPE = RECHARGE_TYPE.LANDLINE_BROABAND
             gtmModel.list = "Broadband And Landline Section"
        }
            
        else if category == VAL_ORDERTYPE_DATACARD {
            
            let cartPrepaidPostpaid: String = dictOrderDetail[RES_subCategoryId] as! String
            
            rechargeVC.mobile_CardOperator = dictOrderDetail[RES_operatorName] as! String
            rechargeVC.mobile_CardRegionName = dictOrderDetail[RES_regionName] as! String
            rechargeVC.mobile_CardPrepaidPostpaid = cartPrepaidPostpaid == VAL_RECHARGE_PREPAID ? "Prepaid" : "Postpaid"
            rechargeVC.cart_PrepaidPostpaid = cartPrepaidPostpaid
            rechargeVC.cart_PlanTypeID = dictOrderDetail[RES_planTypeId] as! String
            rechargeVC.cart_MobileNo = dictOrderDetail[RES_mobileNo] as! String
            rechargeVC.cart_TotalAmount = dictItem[RES_amount] as! String
            rechargeVC.cart_OperatorId = dictOrderDetail[RES_operatorID] as! String
            rechargeVC.cart_RegionId = dictOrderDetail[RES_regionID] as! String
            rechargeVC.cart_CategoryId = dictOrderDetail[RES_operatorCategoryMasterId] as! String
            rechargeVC.cart_RegionPlanId =  dictItem[RES_regionPlanID] as! String
            rechargeVC.cart_PlanValue =  dictItem[RES_amount] as! String
            rechargeVC._RECHARGE_TYPE = RECHARGE_TYPE.DATA_CARD
             gtmModel.list = "DataCard Section"
        }
            
        else if category == VAL_ORDERTYPE_INSURANCE {
            
            let cartPrepaidPostpaid: String = dictOrderDetail[RES_subCategoryId] as! String
            
            rechargeVC.mobile_CardOperator = dictOrderDetail[RES_operatorName] as! String
            rechargeVC.mobile_CardRegionName = dictOrderDetail[RES_regionName] as! String
            rechargeVC.mobile_CardPrepaidPostpaid = cartPrepaidPostpaid == VAL_RECHARGE_PREPAID ? "Prepaid" : "Postpaid"
            rechargeVC.cart_PrepaidPostpaid = cartPrepaidPostpaid
            rechargeVC.cart_PlanTypeID = dictOrderDetail[RES_planTypeId] as! String
            rechargeVC.cart_MobileNo = dictOrderDetail[RES_mobileNo] as! String
            rechargeVC.cart_TotalAmount = dictItem[RES_amount] as! String
            rechargeVC.cart_OperatorId = dictOrderDetail[RES_operatorID] as! String
            rechargeVC.cart_RegionId = dictOrderDetail[RES_regionID] as! String
            rechargeVC.cart_CategoryId = dictOrderDetail[RES_operatorCategoryMasterId] as! String
            rechargeVC.cart_RegionPlanId =  dictItem[RES_regionPlanID] as! String
            rechargeVC.cart_PlanValue =  dictItem[RES_amount] as! String
            rechargeVC._RECHARGE_TYPE = RECHARGE_TYPE.INSURANCE
             gtmModel.list = "Insurance Section"
        }
            
        else if category == VAL_ORDERTYPE_ADD_MONEY {
            
            rechargeVC.mobile_CardOperator = "Add Money"
            rechargeVC.mobile_CardRegionName = ""
            rechargeVC.mobile_CardPrepaidPostpaid = ""
            rechargeVC.cart_PrepaidPostpaid = VAL_RECHARGE_NONE
            rechargeVC.cart_PlanTypeID = "0"
            rechargeVC.cart_MobileNo = ""
            rechargeVC.cart_TotalAmount = dictItem[RES_amount] as! String
            rechargeVC.cart_OperatorId = "0"
            rechargeVC.cart_RegionId = "0"
            rechargeVC.cart_CategoryId = "0"
            rechargeVC.cart_RegionPlanId =  "0"
            rechargeVC.cart_PlanValue = dictItem[RES_amount] as! String
            rechargeVC._RECHARGE_TYPE = RECHARGE_TYPE.ADD_MONEY
             gtmModel.list = "AddMoney Section"
            
        }
            
        else if category == VAL_ORDERTYPE_BUS_BOOKING
        {
            let dictSource:typeAliasStringDictionary = [RES_sourceId:dictOrderDetail[RES_regionID]! as! String,
                                                        RES_sourceName:dictOrderDetail[RES_sourceName]! as! String]
            let dictDest:typeAliasStringDictionary =    [RES_destinationId:dictOrderDetail[RES_planTypeId]! as! String,
                                                         RES_destinationName:dictOrderDetail[RES_destinationName]! as! String]
            
            let busBookVC = BusBookingViewController(nibName: "BusBookingViewController", bundle: nil)
            busBookVC.dictSource = dictSource
            busBookVC.dictDestination = dictDest
            busBookVC.stSource = dictOrderDetail[RES_sourceName] as! String
            busBookVC.stDestination = dictOrderDetail[RES_destinationName] as! String
            self.navigationController?.pushViewController(busBookVC, animated: true)
            return
        }
        else if category == VAL_ORDERTYPE_FLIGHT
        {
            let dictSource:typeAliasStringDictionary = [RES_AirportCode:dictOrderDetail[RES_sourceId]! as! String,
                                                        RES_regionName:dictOrderDetail[RES_sourceName]! as! String,
                                                        RES_regionID:dictOrderDetail[RES_regionID]! as! String,
                                                        RES_countryID:dictOrderDetail[RES_sourceCountryId]! as! String]
            let dictDest:typeAliasStringDictionary = [RES_AirportCode:dictOrderDetail[RES_destinationId]! as! String,
                                                      RES_regionName:dictOrderDetail[RES_destinationName]! as! String,
                                                      RES_regionID:dictOrderDetail[RES_planTypeId]! as! String,
                                                      RES_countryID:dictOrderDetail[RES_destinationCountryId]! as! String]
            
            let flightVC = FlightBookingViewController(nibName: "FlightBookingViewController", bundle: nil)
            flightVC.dictOrigin = dictSource as typeAliasDictionary
            flightVC.dictDestination = dictDest as typeAliasDictionary
            self.navigationController?.pushViewController(flightVC, animated: true)
            return
        }
        
        // SET GTMMODEL DATA FOR ADD TO CART
        
       
        gtmModel.category = rechargeVC.mobile_CardPrepaidPostpaid
        gtmModel.price = rechargeVC.cart_TotalAmount
        gtmModel.product_Id = DataModel.getUserInfo()[RES_userID] as! String
        gtmModel.brand = rechargeVC.mobile_CardOperator
        gtmModel.variant = rechargeVC.cart_MobileNo
        gtmModel.dimension3 = "\(rechargeVC.mobile_CardOperator):\(rechargeVC.mobile_CardRegionName)"
        gtmModel.dimension4 = "0"
        
        if category == VAL_ORDERTYPE_ADD_MONEY {
            gtmModel.list = "Wallet"
            gtmModel.ee_type = GTM_EE_TYPE_WALLET
            gtmModel.name = GTM_ADDMONEY
            gtmModel.brand = GTM_ADDMONEY
            gtmModel.category = GTM_EE_TYPE_WALLET
        }
       
        if category != VAL_ORDERTYPE_BUS_BOOKING && category != VAL_ORDERTYPE_FLIGHT {

            GTMModel.pushProductDetail(gtmModel: gtmModel)
            GTMModel.pushAddToCart(gtmModel: gtmModel)
        }
        
        rechargeVC.stImageUrl =  dictItem[RES_image] as! String
        self.navigationController?.pushViewController(rechargeVC, animated: true)
    }
    
    //MARK: - GTM CHECK OUT COMPLETE
    func pushCheckOutComplete(orderDetail:typeAliasDictionary) {
        
        let orderStatus = (Int(self.dictOrderDetail[RES_orderStatusID] as! String))!
        let dictItem: typeAliasDictionary = self.arrItems[0]
        let gtmModel =  GTMModel()
        let orderTypeId: Int = (Int(self.dictOrderDetail[RES_orderTypeID] as! String))!
        
        gtmModel.order_type     = dictOrderDetail.isKeyNull(RES_orderStatus) ? "" : dictOrderDetail[RES_orderStatus] as! String
        gtmModel.id             =  dictOrderDetail.isKeyNull(RES_orderID) ? "" : dictOrderDetail[RES_orderID] as! String
        gtmModel.affiliation     = "Cubber iOS"
        gtmModel.tax             =  dictOrderDetail.isKeyNull(RES_ServiceTax) ? "" : dictOrderDetail[RES_ServiceTax] as! String
        gtmModel.shipping        = dictOrderDetail.isKeyNull(RES_convenienceFee) ? "0" : dictOrderDetail[RES_convenienceFee] as! String
        gtmModel.revenue         = "\(dictOrderDetail[RES_orderTotalAmount]!)"
        gtmModel.coupon          =  dictOrderDetail.isKeyNull(RES_couponCode) ? "" : dictOrderDetail[RES_couponCode] as! String != "0" ? dictOrderDetail[RES_couponCode] as! String : "None"
        gtmModel.product_Id      =  DataModel.getUserInfo()[RES_userID] as! String
        gtmModel.price           =  "\(dictItem[RES_displayTotal]!)"
        gtmModel.brand           =  dictOrderDetail.isKeyNull(RES_operatorName) ? "" : dictOrderDetail[RES_operatorName] as! String
        gtmModel.variant         =  dictOrderDetail.isKeyNull(RES_mobileNo) ? "" : dictOrderDetail[RES_mobileNo] as! String
        gtmModel.quantity        = dictItem.isKeyNull(RES_qty) ? 1 : Int(dictItem[RES_qty] as! String)!
        gtmModel.category        =  dictOrderDetail.isKeyNull(RES_subCategoryId) ? "" : dictOrderDetail[RES_subCategoryId] as! String == "1" ? "Prepaid" : "Postpaid"
        gtmModel.dimension4      = "0"
        gtmModel.dimension10     =  dictOrderDetail.isKeyNull(RES_walletAmount) ? "" : dictOrderDetail[RES_walletAmount] as! String
        gtmModel.dimension11     = Double(dictItem[RES_itemCashback] as! String) == 0 ? Double(dictItem[RES_itemDiscount] as! String) == 0 ? "0" : dictItem[RES_itemDiscount] as! String : dictItem[RES_itemCashback] as! String
        gtmModel.payment_method  =  dictOrderDetail.isKeyNull(RES_bankName) ? "" : dictOrderDetail[RES_bankName] as! String
        gtmModel.dimension12     =  dictOrderDetail.isKeyNull(RES_couponCode) ? "" : dictOrderDetail[RES_couponCode] as! String != "0" ? dictOrderDetail[RES_couponCode] as! String : ""
        gtmModel.user_type   = DataModel.getUserInfo()[RES_isReferrelActive] as! String == "1" ? GTM_USER_PRIME : GTM_USER_NON_PRIME
        
        let _RECHARGE_TYPE:RECHARGE_TYPE = RECHARGE_TYPE(rawValue: orderTypeId)!
        
        switch _RECHARGE_TYPE {
        case .MOBILE_RECHARGE:
            gtmModel.ee_type = GTM_EE_TYPE_RECHARGE
            gtmModel.name = GTM_MOBILE_RECHARGE
            
            
            break
        case .DTH_RECHARGE:
            gtmModel.ee_type = GTM_EE_TYPE_RECHARGE
            gtmModel.name = GTM_DTH_RECHARGE
            
            break
            
        case .DATA_CARD:
            gtmModel.ee_type = GTM_EE_TYPE_RECHARGE
            gtmModel.name = GTM_DATACARD_RECHARGE
            
            break
            
        case .LANDLINE_BROABAND:
            gtmModel.ee_type = GTM_EE_TYPE_BILL
            gtmModel.name = GTM_LANDLINE_BILL_PAY
            
            break
            
        case .ELECTRICITY_BILL:
            gtmModel.ee_type = GTM_EE_TYPE_BILL
            gtmModel.name = GTM_ELE_BILL_PAY
            
            break
            
        case .GAS_BILL:
            gtmModel.ee_type = GTM_EE_TYPE_BILL
            gtmModel.name = GTM_GAS_BILL_PAY
            
            break
            
        case .BUS_BOOKING:
            gtmModel.ee_type = GTM_BUS
            gtmModel.name = GTM_BUS_BOOKING
            gtmModel.category =  "\(dictOrderDetail[RES_sourceName] as! String) To \(dictOrderDetail[RES_destinationName] as! String)"
            gtmModel.dimension5 = "\(dictOrderDetail[RES_sourceName] as! String):\(dictOrderDetail[RES_destinationName] as! String)"
            gtmModel.dimension6 = dictOrderDetail[RES_orderDate] as! String
            GTMModel.pushCheckOut_CompleteBus(gtmModel: gtmModel)
            break
            
        case .FLIGHT_BOOKING:
            gtmModel.ee_type = GTM_FLIGHT
            gtmModel.name = GTM_FLIGHT_BOOKING
            gtmModel.category = dictOrderDetail.isKeyNull(RES_sourceName) ? "" : dictOrderDetail.isKeyNull(RES_destinationName) ? "" : "\(dictOrderDetail[RES_sourceName] as! String) To \(dictOrderDetail[RES_destinationName] as! String)"
            gtmModel.dimension5 =  dictOrderDetail.isKeyNull(RES_sourceName) ? "" : dictOrderDetail.isKeyNull(RES_destinationName) ? "" : "\(dictOrderDetail[RES_sourceName] as! String):\(dictOrderDetail[RES_destinationName] as! String)"
            gtmModel.dimension6 = dictOrderDetail[RES_orderDate] as! String
            GTMModel.pushCheckOut_CompleteBus(gtmModel: gtmModel)
            break
            
        case .INSURANCE:
            gtmModel.ee_type = GTM_EE_TYPE_BILL
            gtmModel.name = GTM_INSUARANCE_BILL_PAY
            break
        case .ADD_MONEY:
            gtmModel.ee_type     = GTM_EE_TYPE_WALLET
            gtmModel.name        = GTM_ADDMONEY
            gtmModel.category    = GTM_EE_TYPE_WALLET
            gtmModel.brand       = GTM_ADDMONEY
            gtmModel.variant = userInfo[RES_userMobileNo] as! String
            break
        case .MEMBERSHIP_FEES:
            gtmModel.ee_type = obj_AppDelegate.membershipTitle
            gtmModel.name = obj_AppDelegate.membershipTitle
            gtmModel.brand           = obj_AppDelegate.membershipTitle
            gtmModel.variant = userInfo[RES_userMobileNo] as! String
            break
        case.EVENT:
            gtmModel.ee_type = GTM_EVENT
            gtmModel.name = GTM_EVENT_BOOKING
            gtmModel.category = eventVenue
        case.DONATE_MONEY:
            gtmModel.ee_type = GTM_DONATE_MONEY
            gtmModel.name = GTM_DONATE_MONEY
            gtmModel.category = GTM_EE_TYPE_WALLET
            gtmModel.brand  = GTM_DONATE_MONEY
            gtmModel.variant = userInfo[RES_userMobileNo] as! String
            break
        default:
            break
        }
        
        if _RECHARGE_TYPE != .BUS_BOOKING && _RECHARGE_TYPE != .FLIGHT_BOOKING  {
            gtmModel.dimension3      = dictOrderDetail[RES_regionName] as! String != "" ? "\(dictOrderDetail[RES_operatorName] as! String):\(dictOrderDetail[RES_regionName] as! String)" : ""
            GTMModel.pushCheckOut_Complete(gtmModel: gtmModel)
            if orderStatus == ORDER_STATUS.REFUNDED.rawValue {
                GTMModel.pushRefund(gtmModel: gtmModel)
            }
        }
    }
    
    //MARK: FEEDBACK METHODS
    
    
    @IBAction func btnFeedback_RatiingAction(_ sender: UIButton) {
        
        let stRating:String = sender.tag == 6 ? "" : String(sender.tag)
        let stComment:String = (txtFeedback.text?.trim())!
        txtFeedback.resignFirstResponder()
        if sender.tag == 6 && stComment.isEmpty {
            _KDAlertView.showMessage(message: "Please Enter Feedback", messageType: .WARNING)
            return
        }
        
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_USER_RATING: stRating,
                      REQ_ORDER_ID: self.orderId,
                      REQ_USER_COMMENT: stComment] as [String : Any]
        
        self.obj_OperationWeb.callRestApi(methodName: JMETHOD_userFeedback, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params as! typeAliasStringDictionary, viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
            if sender.tag == 6 {
                self.hideFeedbackView()
            }
            else{
                self.showCommentView()
            }
        }, onFailure: { (code, dict) in
            self._KDAlertView.showMessage(message: dict[RES_message] as! String, messageType: .WARNING)
        }) { self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return  }
        
    }
    
    func showFeedBackView() {
        
        self.viewFeedBackBG.isHidden = false
        viewRating.isHidden = false
        viewComment.isHidden = true
        self.constraintViewSummaryLineTopToViewFeedback.priority = PRIORITY_HIGH
        self.constraintViewSummary_LineToSuper.priority = PRIORITY_LOW
        self.view.layoutIfNeeded()
    }
    
    func hideFeedbackView() {
        self.viewFeedBackBG.isHidden = true
        self.constraintViewSummaryLineTopToViewFeedback.priority = PRIORITY_LOW
        self.constraintViewSummary_LineToSuper.priority = PRIORITY_HIGH
        self.view.layoutIfNeeded()
    }
    
    func showCommentView() {
        
        viewRating.isHidden = true
        viewComment.isHidden = false
        self.constraintViewCommentLeading.constant = 2 * UIScreen.main.bounds.width
        self.view.layoutIfNeeded()
        self.constraintViewCommentLeading.constant = 8
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }) { (completed) in
            
        }
    }
    
    //MARK: UITABLEVIEW DATASOURCE
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return tableView == tableViewItems ?   self.arrItems.count :   arrServices.count }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView == tableViewItems {
            
            let cell: OrderDetailCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_ORDER_DETAIL) as! OrderDetailCell;
            cell.delegate = self
            
            let dictItem: typeAliasDictionary = self.arrItems[(indexPath as NSIndexPath).row]
            let orderTypeId: Int = (Int(self.dictOrderDetail[RES_orderTypeID] as! String))!
            let itemStatus: Int = (Int(self.dictOrderDetail[RES_orderStatusID] as! String))!
            for btn in cell.btnCollection {
                btn.accessibilityIdentifier = String((indexPath as NSIndexPath).row)
                btn.accessibilityLabel = String((indexPath as NSIndexPath).section)
            }
            
            cell.btnCancelTicket.accessibilityIdentifier = String((indexPath as NSIndexPath).row)
            cell.btnCancelTicket.accessibilityLabel = String((indexPath as NSIndexPath).section)
            cell.lblAmount.text = "\(RUPEES_SYMBOL) \(dictItem[RES_displayTotal] as! String)"
            cell.lblItemTitle.text = dictItem[RES_title] as? String
            
            if  self.dictOrderDetail[RES_operatorRefNo] as! String != "0" {
                cell.lblReferenceNumber.text = "Operator Reference Number : \(self.dictOrderDetail[RES_operatorRefNo] as! String)"
                cell.constraintLblReferenceHeight.constant = (cell.lblReferenceNumber.text?.textHeight(cell.lblReferenceNumber.frame.width, textFont: cell.lblReferenceNumber.font))!
            }
            else {
                cell.lblReferenceNumber.text = ""
                cell.constraintLblReferenceHeight.constant = 0
            }
            
            if orderTypeId == RECHARGE_TYPE.EVENT.rawValue {
                cell.lblEventSeats.text = "\(self.dictOrderDetail[RES_eventSeat] as! String)"
                cell.constraintLblEventSeatHeight.constant = (cell.lblEventSeats.text?.textHeight(cell.lblEventSeats.frame.width, textFont: cell.lblEventSeats.font))!
            }
            else {
                cell.lblEventSeats.text = ""
                cell.constraintLblEventSeatHeight.constant = 0
            }
            
            var bgColor: UIColor = UIColor.clear
            var textColor: UIColor = UIColor.white
            
            cell.getStatusActivityIndicator.stopAnimating()
            cell.getStatusActivityIndicator.isHidden = true
            cell.btnCancelOrder.isHidden = true
            cell.constraintBtnCancelOrderHeight.constant = 0
            if orderTypeId == RECHARGE_TYPE.MEMBERSHIP_FEES.rawValue ||  orderTypeId == RECHARGE_TYPE.ELECTRICITY_BILL.rawValue ||  orderTypeId == RECHARGE_TYPE.GAS_BILL.rawValue ||  orderTypeId == RECHARGE_TYPE.EVENT.rawValue || orderTypeId == RECHARGE_TYPE.DONATE_MONEY.rawValue || orderTypeId == RECHARGE_TYPE.SHOPPING_CASHBACK.rawValue {
                cell.btnRepeat.isHidden = true
                cell.btnRetry.isHidden = true
                cell.btnCancelTicket.isHidden = true
                
                if orderTypeId == RECHARGE_TYPE.MEMBERSHIP_FEES.rawValue && itemStatus == ORDER_STATUS.SUCCESS.rawValue{
                    
                    var dictUserInfo:typeAliasDictionary = DataModel.getUserInfo()
                    dictUserInfo[RES_isMemberFeesPay] = "1" as AnyObject
                    dictUserInfo[RES_memberShipFees] = DataModel.getMemberShipFees() as AnyObject
                    DataModel.setUserInfo(dictUserInfo)
                    NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFICATION_MEMBERSHIP_FEE_PAID), object: nil) //POST NOTIFICATION
                }
                
                if itemStatus == ORDER_STATUS.SUCCESS.rawValue { bgColor = COLOUR_ORDER_STATUS_SUCCESS }
                else if itemStatus == ORDER_STATUS.FAILED.rawValue { bgColor = COLOUR_ORDER_STATUS_FAILURE }
                else if itemStatus == ORDER_STATUS.AWAITING.rawValue { bgColor = COLOUR_ORDER_STATUS_AWAITING
                    cell.getStatusActivityIndicator.isHidden = false
                    cell.getStatusActivityIndicator.startAnimating()
                }
                else if itemStatus == ORDER_STATUS.FAILED.rawValue { bgColor = COLOUR_ORDER_STATUS_FAILURE }
                else if itemStatus == ORDER_STATUS.PROCESSING.rawValue { bgColor = COLOUR_ORDER_STATUS_PROCESSING }
                else if itemStatus == ORDER_STATUS.REFUNDED.rawValue { bgColor = COLOUR_ORDER_STATUS_REFUNDED; textColor = UIColor.white
                }
                else if itemStatus == ORDER_STATUS.QUEUED.rawValue { bgColor = COLOUR_ORDER_STATUS_REFUNDED; textColor = UIColor.white
                    cell.btnCancelOrder.isHidden = false
                    cell.constraintBtnCancelOrderHeight.constant = 30
                }
                else if itemStatus == ORDER_STATUS.CANCELLED.rawValue { bgColor = COLOUR_ORDER_STATUS_CANCELLED }
            }
            else {
                cell.btnCancelTicket.isHidden = true
                cell.constraintBtnCancelTicketHeight.constant = 0
                cell.constraintBtnCancelOrderHeight.constant = 0
                if itemStatus == ORDER_STATUS.SUCCESS.rawValue {
                    if orderTypeId == RECHARGE_TYPE.BUS_BOOKING.rawValue || orderTypeId == RECHARGE_TYPE.FLIGHT_BOOKING.rawValue {
                        if isCancelTicket { cell.btnCancelTicket.isHidden = false ;
                            cell.constraintBtnCancelTicketHeight.constant = 30
                        }
                    }
                    cell.btnRepeat.isHidden = false
                    cell.btnRetry.isHidden = true
                    bgColor = COLOUR_ORDER_STATUS_SUCCESS
                }
                else if itemStatus == ORDER_STATUS.FAILED.rawValue {
                    cell.btnRepeat.isHidden = true
                    cell.btnRetry.isHidden = false
                    bgColor = COLOUR_ORDER_STATUS_FAILURE
                }
                else if itemStatus == ORDER_STATUS.AWAITING.rawValue {
                    cell.btnRepeat.isHidden = true
                    cell.btnRetry.isHidden = true
                    cell.getStatusActivityIndicator.isHidden = false
                    cell.getStatusActivityIndicator.startAnimating()
                    bgColor = COLOUR_ORDER_STATUS_AWAITING
                }
                else if itemStatus == ORDER_STATUS.PROCESSING.rawValue {
                    cell.btnRepeat.isHidden = true
                    cell.btnRetry.isHidden = true
                    bgColor = COLOUR_ORDER_STATUS_PROCESSING
                }
                else if itemStatus == ORDER_STATUS.REFUNDED.rawValue {
                    cell.btnRepeat.isHidden = true
                    cell.btnRetry.isHidden = true
                    bgColor = COLOUR_ORDER_STATUS_REFUNDED
                    textColor =  UIColor.white
                }
                else if itemStatus == ORDER_STATUS.REFUNDED.rawValue || itemStatus == ORDER_STATUS.REFUND_TO_BANK.rawValue {
                    cell.btnRepeat.isHidden = true
                    cell.btnRetry.isHidden = true
                    bgColor = COLOUR_ORDER_STATUS_REFUNDED
                    textColor =  UIColor.white
                }
                else if itemStatus == ORDER_STATUS.QUEUED.rawValue {
                    cell.btnRepeat.isHidden = true
                    cell.btnRetry.isHidden = true
                    cell.btnCancelOrder.isHidden = false
                    bgColor = COLOUR_ORDER_STATUS_REFUNDED
                    textColor =  UIColor.white
                    cell.constraintBtnCancelOrderHeight.constant = 30
                }
                else if itemStatus == ORDER_STATUS.CANCELLED.rawValue  {
                    cell.btnRepeat.isHidden = true
                    cell.btnRetry.isHidden = true
                    bgColor = COLOUR_ORDER_STATUS_CANCELLED
                    textColor =  UIColor.white //
                }
                else {
                    cell.btnRepeat.isHidden = true
                    cell.btnRetry.isHidden = true
                }
            }
            
            var stStatus: String = dictItem[RES_orderStatus] as! String
            stStatus = " \(stStatus.trim().uppercased()) "
            cell.btnCancelOrder.accessibilityIdentifier = String(indexPath.row)
            cell.btnItemStatus.setTitle(stStatus, for: UIControlState())
            cell.btnItemStatus.backgroundColor = bgColor
            cell.btnItemStatus.setTitleColor(textColor, for: UIControlState.normal)
            cell.imageViewItem.sd_setImage(with: (dictItem[RES_image] as! String).convertToUrl() as URL!, placeholderImage: nil, options: SDWebImageOptions.progressiveDownload, progress:
                { (receivedSize, expectedSize) in cell.activityIndicator.startAnimating() })
            { (image, error, cacheType, imageURL) in
                
                if image == nil { cell.imageViewItem.image = UIImage(named: "logo") }
                else { cell.imageViewItem.image = image! }
                cell.activityIndicator.stopAnimating()
            }
            cell.layoutIfNeeded()
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
            
            //ORDER SUMMARY TABLE
        else {
            
            let cell : OrderDetailSummaryCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_ORDER_DETAIL_SUMMARY_CELL) as! OrderDetailSummaryCell
            let dict = arrServices[indexPath.row]
            cell.lblName.text = dict[RES_Name] as! String?
            cell.lblValue.text = "\(RUPEES_SYMBOL) \(dict[RES_value] as! String)"
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
    }
    
    //MARK: UITABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        if tableView == tableViewItems {
            return UITableViewAutomaticDimension
        }
        else { return 40 }
    }
    
    func tableView(_ tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath) { cell.separatorInset = UIEdgeInsets.zero; cell.preservesSuperviewLayoutMargins = false; cell.layoutMargins = UIEdgeInsets.zero }
    
    //MARK: ORDER CELL DELEGATE
    func btnOrderDetailCell_RepeatAction(_ button: UIButton) { self.showRechargeView(button) }
    
    func btnOrderDetailCell_RetryAction(_ button: UIButton) { self.showRechargeView(button) }
    
    func btnOrderDetailCell_CancelTicketAction(_ button: UIButton) {
        let orderType = Int(self.dictOrderDetail[RES_orderTypeID] as! String)!
        if  orderType == RECHARGE_TYPE.BUS_BOOKING.rawValue {
            callGetCancelDetail()
        }
        else if orderType == RECHARGE_TYPE.FLIGHT_BOOKING.rawValue
        {
            let flichCancelVC = FlightCancelDetailViewController(nibName: "FlightCancelDetailViewController", bundle: nil)
            flichCancelVC.delegate = self
            flichCancelVC.orderId = self.dictOrderDetail[RES_orderID] as! String
            self.navigationController?.pushViewController(flichCancelVC, animated: true)
            return
        }
    }
    
    func btnOrderDetailCell_CancelOrderAction(_ button: UIButton){
        let ind :Int = Int(button.accessibilityIdentifier!)!
        let dictItem: typeAliasDictionary = self.arrItems[ind]
        self.callCancelOrderService(orderId: dictItem[RES_orderID] as! String)
    }
    
    //MARK: VKPOPOVER DELEGATE
    func vkPopoverClose() { }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    //MARK FLIGHTCANCELVC DELEGATE
    
    func FlightCancelView_refreshOrder() {
        self.callGetOrderStatusService(false)
    }
    
}
