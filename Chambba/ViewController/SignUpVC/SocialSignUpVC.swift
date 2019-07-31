//
//  SocialSignUpVC.swift
//  Chambba
//
//  Created by Rohit Kumar on 28/02/19.
//  Copyright © 2019 Mayur chaudhary. All rights reserved.
//

import UIKit
import GoogleSignIn
import AccountKit
import FBSDKLoginKit
import FBSDKCoreKit


class SocialSignUpVC: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate{
   
    
    @IBOutlet weak var socialSignupTableview: UITableView!
    
    var signupArray = ["Google","Facebook"]
    var imageArray = [#imageLiteral(resourceName: "google") , #imageLiteral(resourceName: "facebook")]
    var userObj = UserInfo()
   // var accountKit: AKFAccountKit!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
//        if accountKit == nil {
//            accountKit = AKFAccountKit(responseType: .accessToken)
//        }
    }

    @IBAction func commonButtonAction(_ sender: UIButton) {
        
        switch sender.tag {
            
        case 100:       // Back Btn
            self.navigationController?.popViewController(animated: true)
            break
            
        default:
            break
        }
        
    }
    
}



//MARK: Tableview Delegate Method
extension SocialSignUpVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return signupArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SocialCell
        
        cell.socialLabel.text = signupArray[indexPath.row]
        cell.imageview.image  = imageArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            //Google SignIn
            GIDSignIn.sharedInstance().signIn()
        } else if indexPath.row == 1 {
            //Facebook SighIn
            let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
            fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
                
                if (error == nil){
                    
                    let fbloginresult : FBSDKLoginManagerLoginResult = result!
                    if fbloginresult.grantedPermissions != nil {
                        if fbloginresult.grantedPermissions.contains("email")
                        {
                            self.getFBUserData()
                            //fbLoginManager.logOut()
                        }
                    }
                } else {
                    AlertController.alert(title: "", message: error!.localizedDescription, buttons: ["OK"]) { (UIAlertAction, index) in
                    }
                }
            }
        }
    }
    
    //MARK: Facebook SignIn Parameter
    func getFBUserData(){
        
        
        if FBSDKAccessToken.current() != nil {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                
                if error != nil {
                    print("error facebook",FBSDKAccessToken.current())
                } else {
                    print("LoggedIn")
                    let dict = result as! [String : AnyObject]
                    print(result!)
                    print(dict)
                    
                    guard let name = dict["name"] else { return }
                    guard let id = dict["id"] else { return }
                    
                    if let profilePicture = dict["picture"]  {
                        if let data = profilePicture["data"] as? [String: Any] {
                            if let url = data["url"] as? String {
                                self.userObj.socialImageUrl = url
                            }
                        }
                    }
                    
                    if let email = dict["email"] as? String {
                        self.userObj.email = email
                    } else {
                        let UID = id as! String
                        self.userObj.email = UID + "@gmail.com"
                    }
                    
                    self.userObj.fullName = name as! String
                    self.userObj.signInMethod = "facebook"
                    self.userObj.socialId = id as! String
                    //self.loginWithPhone()
                    
                    let uploadDocument = mainStoryboard.instantiateViewController(withIdentifier: "UploadDocumentVC") as! UploadDocumentVC
                    uploadDocument.email = self.userObj.email
                    uploadDocument.password = self.userObj.socialId
                    uploadDocument.fullName = self.userObj.fullName
                    self.navigationController?.pushViewController(uploadDocument, animated: true)
                }
            })
        }
    }
}
    
  

//MARK: Google SignIn

extension SocialSignUpVC {
    
    // pressed the Sign In button
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error?) {
        //myActivityIndicator.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            userObj.email = user.profile.email
            userObj.fullName = user.profile.name
            userObj.signInMethod = "google"
            userObj.socialId = user.userID
            
            print("USER DATA", user.profile.email, user.profile.name, user.userID)
            
            if user.profile.hasImage{
                // crash here !!!!!!!! cannot get imageUrl here, why?
                // let imageUrl = user.profile.imageURLWithDimension(120)
                let imageUrl = signIn.currentUser.profile.imageURL(withDimension: 120)
                userObj.socialImageUrl = (imageUrl?.absoluteString)!
            }
            
           
            
            let uploadDocument = mainStoryboard.instantiateViewController(withIdentifier: "UploadDocumentVC") as! UploadDocumentVC
            uploadDocument.email = user.profile.email
            uploadDocument.password = user.userID
            uploadDocument.fullName = user.profile.name
            self.navigationController?.pushViewController(uploadDocument, animated: true)
            
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}


