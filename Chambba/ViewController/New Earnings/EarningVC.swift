//
//  EarningVC.swift
//  Chambba
//
//  Created by Rohit Kumar on 12/03/19.
//  Copyright © 2019 Mayur chaudhary. All rights reserved.
//

import UIKit
import SwiftyJSON
import CircleProgressBar

class EarningVC: UIViewController {

    var earningArray = [JSON]()
    var responseData = JSON()
    
    @IBOutlet weak var earningTableView: UITableView!
    @IBOutlet weak var circularProgressBAr: CircleProgressBar!
    @IBOutlet weak var totalEarning: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getEarningData()
    }
    
    func getEarningData() {
        ServiceHelper.sharedInstance.createGetRequest(isShowHud: true, params: [:], apiName: API_EARNING) { (response, error) in
            if error != nil {
                AlertController.alert(title: appName, message: (error?.description)!)
                return
            }
            if (response != nil) {
                
                self.responseData = JSON(response as Any)
                self.earningArray = JSON(response![
                    "rides"] as Any).arrayValue
                
                print(self.earningArray)
                self.earningTableView.reloadData()
                
                let target = self.responseData["target"].stringValue
                let count: CGFloat = CGFloat(self.responseData["rides_count"].floatValue / 10)
                
                
                self.circularProgressBAr.setProgress(count, animated: true, duration: 1)
                self.circularProgressBAr.setHintTextGenerationBlock({ (progress) -> String? in
                    return "\(self.responseData["rides_count"].stringValue)/\(target)"
                })
                
                var sum = 0.0
                for total in self.earningArray {
                    sum = sum + total["payment"]["total"].doubleValue
                }
                
                
                if let currencySymbol = UserDefaults.standard.value(forKey: "currency") as? String {
                    self.totalEarning.text = currencySymbol + String(sum)
                }
                
            } else{
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

extension EarningVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return earningArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EarningCell", for: indexPath) as! EarningCell
        
        
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0)
        }else {
            cell.contentView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        }
        cell.innerView.layer.cornerRadius = 5.0
        cell.distanceLabel.text = earningArray[indexPath.row]["distance"].stringValue + self.responseData["distance_unit"].stringValue
        cell.timeLabel.text =  convertTimeFormat(timeString: earningArray[indexPath.row]["assigned_at"].stringValue)
        
        if let currencySymbol = UserDefaults.standard.value(forKey: "currency") as? String {
            cell.amountLabel.text = currencySymbol + String(format: "%.2f", earningArray[indexPath.row]["payment"]["total"].doubleValue)
        }
        
        
        
        return cell
    }
    
    func convertTimeFormat(timeString: String) -> String {
        
        let splitStringArray = timeString.components(separatedBy: " ")
        let startTimeVal = splitStringArray[1]
        let startTimeFormatter1 = DateFormatter()
        startTimeFormatter1.dateFormat = "HH:mm:ss"
        let local: Locale = Locale.current
        
        let dateStartTime = startTimeFormatter1.date(from: startTimeVal)
        startTimeFormatter1.locale = local
        startTimeFormatter1.dateFormat = "hh:mm a"
        let startTimeString = startTimeFormatter1.string(from: dateStartTime ?? Date())
        return startTimeString
    }
}
