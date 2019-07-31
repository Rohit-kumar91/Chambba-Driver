//
//  MenuVC.swift
//  Chambba
//
//  Created by Mayur chaudhary on 29/01/19.
//  Copyright © 2019 Mayur chaudhary. All rights reserved.
//

import UIKit
import SDWebImage
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit

class MenuVC: UIViewController {
    
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var editProfileBtn: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var acitveStatus: UIView!
    
    var staticTextArray = [String]()
    var staticImageArray = [UIImage]()
    
    //MARK:- UIViewController Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        customInit()
    }

    func customInit(){
        staticTextArray = ["Your Trips","Earnings","Summary","Help","Share","Logout"]
        staticImageArray = [#imageLiteral(resourceName: "payments"),#imageLiteral(resourceName: "serviceHistory"),#imageLiteral(resourceName: "coupon"),#imageLiteral(resourceName: "wallet"),#imageLiteral(resourceName: "help"),#imageLiteral(resourceName: "share"),#imageLiteral(resourceName: "logout")]
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("nameSetUp"), object: nil)

    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
      
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        
        //UserDefaults.standard.set("1", forKey: "Active")
        
        guard let fullname = UserDefaults.standard.string(forKey: "fullName") else { return }
        self.userNameLabel.text = fullname
        
        guard let imageUrl = UserDefaults.standard.string(forKey: PROFILE_IMAGE) else {
            userImage.image = #imageLiteral(resourceName: "userProfileIcon")
            return
        }
        
        let imageURL = BASE_URL + "storage/app/public/" + imageUrl
        print("!!",imageURL)
        
        userImage?.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "userProfileIcon"))

    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        if let dict = notification.userInfo as NSDictionary? {
            
            //Set the username
            if let name = dict["name"] as? String{
                self.userNameLabel.text = name
            }
            
        }
    }

    
    //MARK:- Memory Warning Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- IBACtion Method
    @IBAction func editProfileBtnAction(_ sender: UIButton) {
        APPDELEGATE.sideMenuController.closeSlider(.left, animated: false) { (value) in
        }
        let profileVC = mainStoryboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
}

extension MenuVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return staticTextArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.statictextLabel.text = staticTextArray[indexPath.row]
        cell.staticImg.image = staticImageArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        APPDELEGATE.sideMenuController.closeSlider(.left, animated: false) { (value) in
        }
        switch indexPath.row {
            
        case 0:
            //Your Trips
            let yourTripsVC = mainStoryboard.instantiateViewController(withIdentifier: "YourTripsVC") as! YourTripsVC
            self.navigationController?.pushViewController(yourTripsVC, animated: true)
            break
        
        case 1:
            //Earning
            let earningVC = mainStoryboard.instantiateViewController(withIdentifier: "EarningVC") as! EarningVC
            self.navigationController?.pushViewController(earningVC, animated: true)
            break
        case 2:
            //Summary
            let summaryVC = mainStoryboard.instantiateViewController(withIdentifier: "SummaryVC") as! SummaryVC
            self.navigationController?.pushViewController(summaryVC, animated: true)
            break
        
        case 3:
            //HELP
            let helpVC = mainStoryboard.instantiateViewController(withIdentifier: "HelpVC") as! HelpVC
            self.navigationController?.pushViewController(helpVC, animated: true)
            break
        case 4:
            //SHARE
            let image = UIImage(named: "logoIcon")
            let imageToShare = [ image! ]
            let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
            self.present(activityViewController, animated: true, completion: nil)
            break
        case 5:
            //LOGOUT
            AlertController.alert(title: "Chambba", message: "Are you sure want to logout?", buttons: ["NO","YES"]) { (value, index) in
                if index == 1 {
                    UserDefaults.standard.set(false, forKey: "isLoggedin")
                    GIDSignIn.sharedInstance().signOut()
                    FBSDKLoginManager().logOut()
                    APPDELEGATE.setInitialController()
                }
            }
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
