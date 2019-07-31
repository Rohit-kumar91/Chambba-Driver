//
//  SummaryVC.swift
//  Chambba
//
//  Created by Rohit Kumar on 12/03/19.
//  Copyright © 2019 Mayur chaudhary. All rights reserved.
//

import UIKit
import SwiftyJSON

class SummaryVC: UIViewController {
    
    var summaryResponse = JSON()
    @IBOutlet weak var summaryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getSummaryData()
    }
    
    func getSummaryData() {
        
        ServiceHelper.sharedInstance.createPostRequest(isShowHud: true, params: [:], apiName: API_SUMMARY) { (response, error) in
            if error != nil {
                AlertController.alert(title: appName, message: (error?.description)!)
                return
            }
            if (response != nil) {
                print(response!)
                self.summaryResponse = JSON(response as Any)
               
                self.summaryTableView.reloadData()
            }else{
                AlertController.alert(title: appName, message: "Something went wrong.")
            }
        }
    }
    
    
    @IBAction func commonButtonAction(_ sender: UIButton) {
        switch sender.tag {
        case 100:                   // Back Btn
            self.navigationController?.popViewController(animated: true)
            break
       
        default:
            break
        }
    }
}


extension SummaryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryCell", for: indexPath) as! SummaryCell
        
        if indexPath.row % 2 == 0
        {
            cell.backgroundview.backgroundColor = UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0)
        }
        else
        {
            cell.backgroundview.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        }
        
        if indexPath.row == 0  {
            
            cell.nameLabel.text = "TOTAL NUMBER OF RIDES"
            cell.staticImageView.image =  #imageLiteral(resourceName: "summary-total-rides")
            let ride = summaryResponse["rides"].floatValue
            cell.currencyLabel.isHidden = true
            cell.countLabel.text = String(format: "%.1f", ride)
            
        }
        
        if indexPath.row == 1  {
            
            cell.nameLabel.text = "REVENUE"
            cell.staticImageView.image =  #imageLiteral(resourceName: "summary-revenue")
            let revenue = summaryResponse["revenue"].floatValue
            cell.countLabel.text = String(format: "%.1f", revenue)
        }
        
        if indexPath.row == 2 {
            cell.nameLabel.text = "NO OF SCHEDULED RIDES"
            cell.staticImageView.image =  #imageLiteral(resourceName: "summary-schedule")
            let schduleRide = summaryResponse["scheduled_rides"].floatValue
            cell.currencyLabel.isHidden = true
            cell.countLabel.text = String(format: "%.1f", schduleRide)
        }
        
        if indexPath.row == 3 {
            cell.nameLabel.text = "CANCELLED RIDES"
            cell.staticImageView.image =  #imageLiteral(resourceName: "summary-cancel")
            let cancelRide = summaryResponse["cancel_rides"].floatValue
            cell.currencyLabel.isHidden = true
            cell.countLabel.text = String(format: "%.1f", cancelRide)
        }
            
        return cell
    }
}
