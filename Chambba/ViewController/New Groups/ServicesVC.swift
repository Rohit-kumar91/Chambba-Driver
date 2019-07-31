//
//  ServicesVC.swift
//  Chambba
//
//  Created by Rohit Kumar on 19/03/19.
//  Copyright © 2019 Mayur chaudhary. All rights reserved.
//

import UIKit
import SwiftyJSON

class ServicesVC: UIViewController {

    @IBOutlet weak var serviceTableView: UITableView!
    
    var serviceData = JSON()
    var serviceArray = [JSON]()
    var selectedRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("Service Array",serviceArray)
        
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func checkUncheckBtn(_ sender: UIButton) {
        
//       updateServiceType(id: self.serviceArray[sender.tag]["id"].stringValue, indexValue: sender.tag)
        
    }
    
    
    func updateServiceType(id: String, indexValue: Int) {
        
        let param = [
            "provider_service_id" : Int(id)
        ]
        
        ServiceHelper.sharedInstance.createPostRequest(isShowHud: true, params: param as [String : AnyObject], apiName: API_REQUEST_PROVIDER_UPDATE_SERVICE) { (response, error) in
            
            if error != nil {
                AlertController.alert(title: appName, message: (error?.description)!)
                return
            }
            
            if response != nil {
                
                
                for (index, _) in self.serviceArray.enumerated() {
                    print(index)
                    print(indexValue)
                    if index == indexValue {
                       self.serviceArray[index]["selected_service"] = 1
                    } else {
                        self.serviceArray[index]["selected_service"] = 0
                    }
                }

                print( self.serviceArray)
                self.serviceTableView.reloadData()
                
            }
        }
    }
}

extension ServicesVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return serviceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServicesCell", for: indexPath) as! ServicesCell
        
        cell.checkButton.tag = indexPath.row
        cell.serviceImageView.sd_setImage(with: URL(string: serviceArray[indexPath.row]["service_type"]["image"].stringValue), placeholderImage: #imageLiteral(resourceName: "userProfileIcon"))
        cell.nameLbl.text = serviceArray[indexPath.row]["service_type"]["name"].stringValue
        cell.providerLbl.text = serviceArray[indexPath.row]["service_type"]["provider_name"].stringValue
        cell.descriptionLbl.text = serviceArray[indexPath.row]["service_type"]["description"].stringValue
        
//        if serviceArray[indexPath.row]["selected_service"].boolValue {
//            cell.checkUncheckImageView.image = #imageLiteral(resourceName: "check")
//        } else {
//              cell.checkUncheckImageView.image = #imageLiteral(resourceName: "unCheck")
//        }
        
        return cell
    }
}

