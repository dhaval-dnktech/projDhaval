 //
//  FBAndGoogleLogin.swift
//  Cubber
//
//  Created by Vyas Kishan on 27/07/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

let SOCIAL_ID                           = "SOCIAL_ID"
let SOCIAL_TOKEN                        = "SOCIAL_TOKEN"
let SOCIAL_EMAIL                        = "SOCIAL_EMAIL"
let SOCIAL_NAME                         = "SOCIAL_NAME"
let SOCIAL_PROFILE_IMAGE                = "SOCIAL_PROFILE_IMAGE"

import UIKit
import Google
import FirebaseAuth


protocol FBAndGoogleLoginDelegate {
    func getSocialProfile(_ dictUserInfo: typeAliasDictionary)
}

class FBAndGoogleLogin: NSObject, GIDSignInDelegate, GIDSignInUIDelegate {

    //MARK: PROPERTIES
    var delegate: FBAndGoogleLoginDelegate! = nil
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate var viewController: UIViewController!
    fileprivate var _KDAlertView = KDAlertView()
    
    //MARK: CUSTOME METHODS
    internal func performFBLoginAction(_ viewController: UIViewController) {
        self.viewController = viewController
        obj_AppDelegate._SOCIAL_LOGIN = SOCIAL_LOGIN.FACEBOOK
        DesignModel.startActivityIndicator(self.viewController.navigationController!.view)
        let arrPermission: Array = ["public_profile", "email"]
        let loginManager: FBSDKLoginManager = FBSDKLoginManager.init()
        loginManager.loginBehavior = FBSDKLoginBehavior.native
        loginManager.logOut()
        loginManager.logIn(withReadPermissions: arrPermission, from: self.viewController) { (result, error) in
            if error != nil { DesignModel.stopActivityIndicator()
                self._KDAlertView.showMessage(message: "Permission denied.", messageType: MESSAGE_TYPE.FAILURE)
                return
            }
            else if (result?.isCancelled)! { DesignModel.stopActivityIndicator()
                self._KDAlertView.showMessage(message: "Permission denied.", messageType: MESSAGE_TYPE.FAILURE)
                return
            }
            else { if (result?.grantedPermissions.contains("public_profile"))! { self.getFacebookProfileDetail() } }
        }
    }
    
    internal func performGoogleLoginAction(_ viewController: UIViewController) {
        self.viewController = viewController
        obj_AppDelegate._SOCIAL_LOGIN = SOCIAL_LOGIN.GOOGLE
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        let signIn: GIDSignIn = GIDSignIn.sharedInstance()
        signIn.signOut()
        signIn.shouldFetchBasicProfile = true
        
        //LOCAL
       // signIn.clientID = "842460959194-1lqeeog3d7jbmkol7sd2ne18oi3knueb.apps.googleusercontent.com"
        //LIVE
        signIn.clientID = "105016344861-14ohq0sndqmmscsthrf23gjqdjdm8keh.apps.googleusercontent.com"
        signIn.scopes = ["https://www.googleapis.com/auth/plus.login"]
        signIn.delegate = self
        signIn.uiDelegate = self
        signIn.signIn()
    }
    
    fileprivate func getFacebookProfileDetail() {
        let dictParamaters = ["fields":"id, name, email, picture.type(large), token_for_business"]
        let request: FBSDKGraphRequest = FBSDKGraphRequest.init(graphPath: "me", parameters: dictParamaters)
        request.start { (connection, result, error) in
            let dictUserInfo = result as! typeAliasDictionary
            
            let stId: String = dictUserInfo["id"] != nil ? dictUserInfo["id"] as! String : ""
            let stToken: String = dictUserInfo["token_for_business"] != nil ? dictUserInfo["token_for_business"] as! String : ""
            let stEmail: String = dictUserInfo["email"] != nil ? dictUserInfo["email"] as! String : ""
            let stName: String = dictUserInfo["name"] != nil ? dictUserInfo["name"] as! String : ""
            
            var dictInfo: typeAliasDictionary = [SOCIAL_ID: stId as AnyObject,
                                                 SOCIAL_TOKEN: stToken as AnyObject,
                                                 SOCIAL_EMAIL: stEmail as AnyObject,
                                                 SOCIAL_NAME: stName as AnyObject]

            let dictImage:typeAliasDictionary = dictUserInfo["picture"]?["data"] as! typeAliasDictionary
            let stImageUrl:String = dictImage["url"] as! String
            if !stImageUrl.isEmpty && dictImage["is_silhouette"] as! Bool == false{
                
                do {
                    let imageData = try Data.init(contentsOf: NSURL.init(string: stImageUrl) as! URL)
                    let imagProfile = UIImage.init(data: imageData)
                    dictInfo[SOCIAL_PROFILE_IMAGE] = imagProfile
                }
                catch{print("error")}
            }
            
            DesignModel.stopActivityIndicator()
            self.delegate.getSocialProfile(dictInfo)
        }
        
        //["token_for_business": AbxBOoxv4mM3yx8v, "email": vyaskishan55@gmail.com, "id": 1240860825946391, "name": Vyas Kishan]
    }
    
    
    //MARK: GID SIGNIN UI DELEGATE
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) { DesignModel.startActivityIndicator(self.viewController.navigationController!.view) }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) { self.viewController.present(viewController, animated: true, completion: nil) }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.viewController.dismiss(animated: true, completion: nil)
        DesignModel.stopActivityIndicator()
    }
    
    //MARK: GID SIGNIN DELEGATE
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        DesignModel.stopActivityIndicator()
        if (error == nil) {
            // Perform any operations on signed in user here.
            /*let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email*/
            
            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                           accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                 print(user?.displayName!)
            })
            
            let stId: String = user.userID != nil ? user.userID : ""
            let stToken: String = user.authentication.idToken != nil ? user.authentication.idToken : ""
            let stEmail: String = user.profile.email != nil ? user.profile.email : ""
            let stName: String = user.profile.name != nil ? user.profile.name : ""
            var dictInfo: typeAliasDictionary = [SOCIAL_ID: stId as AnyObject,
                                                 SOCIAL_TOKEN: stToken as AnyObject,
                                                 SOCIAL_EMAIL: stEmail as AnyObject,
                                                 SOCIAL_NAME: stName as AnyObject]
                                                 
            if user.profile.hasImage{
                let imageUrl:URL = user.profile.imageURL(withDimension: 100)
                
                do {
                    let imageData = try Data.init(contentsOf: imageUrl)
                    let imagProfile = UIImage.init(data: imageData)
                    dictInfo[SOCIAL_PROFILE_IMAGE] = imagProfile
                    
                }
                catch{print("error")}
                
            }
            

            self.delegate.getSocialProfile(dictInfo)
        }
        else { print("\(error.localizedDescription)") }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) { DesignModel.stopActivityIndicator() }
}
