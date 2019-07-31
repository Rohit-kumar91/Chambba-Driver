//
//  StripeAdaptivePaymentVC.swift
//  Chambba
//
//  Created by Rohit Kumar on 04/04/19.
//  Copyright © 2019 Mayur chaudhary. All rights reserved.
//

import UIKit
import Stripe
import SwiftyJSON

class StripeAdaptivePaymentVC: UIViewController {

    @IBOutlet weak var stripeWebView: UIWebView!
    
    
    var callBackUrl = String()
    var authorizationCode = String()
    var userID = String()
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        activityIndicator.startAnimating()
        stripeWebView.addSubview(activityIndicator)
        stripeIntialServices()
    }
    
    
    func stripeIntialServices() {
        
        callBackUrl =   STRIPE_BASE_URL + API_STRIPE
        let url = "https://connect.stripe.com/oauth/authorize?response_type=code&stripe_landing=login&client_id=\(STRIPE_CLIENT_ID)&scope=read_write&redirect_uri=\(callBackUrl)"
        
        print(url)
        
        stripeWebView.loadRequest(URLRequest(url: URL(string: url)!))
        
    }
    
    
    

    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

}


extension StripeAdaptivePaymentVC : UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        
        let requestURl = String(format: "%@", (request.url?.host)!)
        print("url",requestURl)

        if  requestURl == CALLBACK_STRIPE {
            authorizationCode = ""
            userID = ""

            if let urlParam = request.url?.query?.components(separatedBy: "&")  {
                print(urlParam)

                for param in urlParam {

                    let keyValue = param.components(separatedBy: "=")
                  
                    
                    let key = keyValue[0]
                     print(key)
                     print(keyValue[1])
                    
                    
                    if key == "code" {
                        authorizationCode = keyValue[1]
                        break
                    }
                    
                    if key == "user_id" {
                        
                    }
                    
                }

                if authorizationCode != "" {
                    self.stripeConnect()
                }
            }

           return true

        }
        return true
        
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    
    
    func stripeConnect() {
        
        guard let id = UserDefaults.standard.string(forKey: "providerID") else {
            print("Cannnot get requestid in accept btn.")
            return
        }
        
        
        let param = [
            "code" : authorizationCode,
            "user_id" : id
        ]
        
        print(param)
        
        ServiceHelper.sharedInstance.createGetRequest(isShowHud: true, params: param as [String : AnyObject], apiName:API_STRIPE_CONNECT) { (response, error) in
            
            if error != nil {
                AlertController.alert(title: appName, message: (error?.description)!)
                return
            }
            
            if response != nil {
                let responseJson = JSON(response as Any)
                
                let statusString = responseJson["status"].stringValue
                UserDefaults.standard.set(statusString, forKey: "status_string")
                if statusString == "true" {
                    UserDefaults.standard.set(self.authorizationCode, forKey: "stripe_acc_id")
                    
                    AlertController.alert(message: responseJson["message"].stringValue)
                    
                    //Profile screen.....
                    self.navigationController?.popViewController(animated: true)
                    
                } else {
                    AlertController.alert(message: responseJson["message"].stringValue)
                }
            }
        }
    }
}
