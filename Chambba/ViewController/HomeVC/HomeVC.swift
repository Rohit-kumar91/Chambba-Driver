//
//  HomeVC.swift
//  Chambba
//
//  Created by Mayur chaudhary on 29/01/19.
//  Copyright © 2019 Mayur chaudhary. All rights reserved.
//

import UIKit
import GoogleMaps
import SocketIO
import HCSStarRatingView
import AVFoundation
import Alamofire
import SwiftyJSON

class HomeVC: UIViewController {
    
    //MARK: UIView Outlets
    @IBOutlet weak var offlineView: UIView!
    @IBOutlet weak var gifSuperView: UIView!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var notifyView: UIView!
    @IBOutlet weak var commonRateView: UIView!
    @IBOutlet weak var SKUView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var rating_user: HCSStarRatingView!
    @IBOutlet weak var stackPaymentModeOutlet: UIStackView!
    
    //MARK: UIImageView Outlets
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var arrivedImg: UIImageView!
    @IBOutlet weak var pickupImg: UIImageView!
    @IBOutlet weak var finishedImg: UIImageView!
    @IBOutlet weak var userImg: UIImageView!
    
    //MARK: UIButton Outlets
    @IBOutlet weak var currentLocationBtn: UIButton!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var goOnlineButton: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var statusBtn: UIButton!
   
   //MARK: UILabel Outlets
    @IBOutlet weak var invoiceIdLbl: UILabel!
    @IBOutlet weak var scheduleLbl: UILabel!
    @IBOutlet weak var pickUpAddressLbl: UILabel!
    @IBOutlet weak var dropAddressLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var rateNameLbl: UILabel!
    @IBOutlet weak var distanceValueLbl: UILabel!
    @IBOutlet weak var baseValueLbl: UILabel!
    @IBOutlet weak var totalValueLbl: UILabel!
    @IBOutlet weak var taxValueLbl: UILabel!
    @IBOutlet weak var invoice_WalletAmt: UILabel!
    @IBOutlet weak var waitingLbl: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var confirmPaymentButton: UIButton!
    @IBOutlet weak var bookingID: UILabel!
    
   
    @IBOutlet weak var notifyBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var SKUHeightConstrint: NSLayoutConstraint!
    @IBOutlet weak var ratingScrollView: UIScrollView!
    @IBOutlet weak var ratingViewBottonConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var ratingStarView: HCSStarRatingView!
    @IBOutlet weak var ratingTextView: UITextView!
    
    @IBOutlet weak var walletDeductionStack: UIStackView!
    @IBOutlet weak var discountStack: UIStackView!
    @IBOutlet weak var invoiceBottomConstraint: NSLayoutConstraint!
    
    
    //MARK: Properties
    private let locationManager = CLLocationManager()
    let manager = SocketManager(socketURL: URL(string: SOCKET_URL)!, config: [.log(true), .compress])
 
    
    var locationCor = CLLocation()
    var CurrentLocation = CLLocation()
    var myLocation = CLLocation()
    var startLocation = CLLocation()
    var oldLocation = CLLocation()
    var newLocaton = CLLocation()
    var bounds = GMSCoordinateBounds()
    let markerCarLocation = GMSMarker()
    
    var secondsLeft = 0
    var hours = 0
    var minutes = 0
    var timer: Timer?
    var timerForReqProgress: Timer?
    var lat = ""
    var long = ""
    var sourceLat = ""
    var sourceLong = ""
    var locName = ""
    var serviceArray = [UserInfo]()
    var selectedIndex = 500
    var carActiveArray = [#imageLiteral(resourceName: "microActiveIcon"),#imageLiteral(resourceName: "sedanActiveIcon"),#imageLiteral(resourceName: "miniActiveIcon")]
    var accountStatus = String()
    var arrayPolylineBlack = NSMutableArray()
    var polylineTimer = Timer()
    
    var s_Lat = String()
    var s_Long = String()
    var d_Lat = String()
    var d_Long = String()
    var dM_Lat = String()
    var dM_Long = String()
    var schduleStr = String()
    var globalStatus = String()
    var mobileStr = String()
    var travelStatus = String()
    var locationString = String()
    var switchMapStr = String()
    var startRideTime = String()
    
    var distance = String()
    var fixed = String()
    var total = String()
    var tax = String()
    
    var locationMapped = Bool()
    var getLocation = Bool()
    var moveNextLocation = Bool()
    var isSchedule = Bool()
    var socketConnectFlag = Bool()
    var checkWalletStatus = Bool()
    //var startLocationMarker = GMSMarker()
    //var endLocationMarker = GMSMarker()
    var totalDistance = String()
    var scheduleStr = "false"
    var StartLocationTaken = false
    var player: AVAudioPlayer?
    
    var path2 = GMSMutablePath()
    var i = 0
    var polylineBlack = GMSPolyline()
    var polyline = GMSPolyline()
    var checkSourceLatLong = false
    let sourceMarker = GMSMarker()
    let destMarker = GMSMarker()

    var totalM = 0.0
    var totalKM = 0.0
    var flag = true
    
    var sourceCo_Distance = CLLocation()
    var destinationCo_Distance = CLLocation()
    var calCulateOneTime = true
    
    //MARK:- UIViewController Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ratingStarView.value = 1
        self.ratingImageView.clipsToBounds = true
        
        self.invoiceBottomConstraint.constant = -300
        UIView.animate(withDuration: 0.45, animations: {
            print("View UP")
            self.view.layoutIfNeeded()
        })
        
        //self.SKUHeightConstrint.constant = 0
        rating_user.value = 0.0
        socketConnectFlag = false
        socketConnect()
        updateLocation()
        playSound()
       
        customInit()
        countdownTimer()
        getIncomingRequest()
        timerView.dropShadow(color: .gray, opacity: 0.7, offSet: CGSize(width: 3, height: 3), radius: 4, scale: true)

        timerForReqProgress = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(getIncomingRequest), userInfo: nil, repeats: true)
        
    }
    
    
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "sound", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    func socketConnect() {
       
        let socket = manager.defaultSocket
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            self.socketConnectFlag = true
        }
        
        socket.on(clientEvent: .disconnect) {data, ack in
            print("socket connected")
            self.socketConnectFlag = false
        }
        
        socket.connect()
    }
    
    
    func countdownTimer() {
        secondsLeft = 0
        hours = 0
        minutes = 0
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter() {
        if secondsLeft > 0 {
            secondsLeft = secondsLeft - 1
            hours = secondsLeft / 3600
            minutes = (secondsLeft % 3600) / 60
            print("Second Left", secondsLeft)
            print("Minutes",minutes)
            timeLabel.text = String(secondsLeft)
        } else {
            secondsLeft = 0
        }
    }
    
    
    @objc func getIncomingRequest() {

        let param = [
            "latitude" : String(format: "%.8f", myLocation.coordinate.latitude),
            "longitude" : String(format: "%.8f", myLocation.coordinate.longitude)
        ] as [String : AnyObject]
        
        print("Parameters ssss",param)
        ServiceHelper.sharedInstance.createGetRequest(isShowHud: false, params: param, apiName: API_INCOMING_REQUEST) { (response, error) in
            
            if error != nil {
                //AlertController.alert(title: appName, message: (error?.description)!)
                return
            }
            
            if response != nil {
                let result = response as! Dictionary<String, AnyObject>
                print("Home Result",result)
                
                let account_Status = result.validatedValue("account_status", expected: "" as AnyObject) as! String
                let serviceStatus = result.validatedValue("service_status", expected: "" as AnyObject) as! String
                
                UserDefaults.standard.set(account_Status, forKey: "status")
                
                if account_Status == "onboarding" || account_Status == "banned" {
                    // Nothing to do....
                    self.goOnlineButton.isHidden = true
                    self.offlineViewSetup()
                    
                } else if account_Status == "approved" {
                    
                    
                    print("Service Status",serviceStatus)
                    
                    if serviceStatus == "active" || serviceStatus == "riding" {
                        UserDefaults.standard.set("1", forKey: "Active")
                        
                        print("Account Status",self.accountStatus)
                        if self.accountStatus == account_Status {
                            
                        } else {
                            self.accountStatus = account_Status
                            self.getStatusMethod(with: self.accountStatus)
                        }
                        
                        let requestArray = result["requests"] as! Array<AnyObject>
                        
                        print("Request Array",requestArray)
                        
                        if requestArray.count == 0 {
                            self.locationMapped = false
                            self.moveNextLocation = false
                            
                            let polyLine = GMSPolyline()
                            polyLine.map = nil
                            self.mapView.clear()
                            self.globalStatus = ""
                            
                            self.totalDistance = ""
                            self.totalM = 0.0
                            self.totalKM = 0.0
                            
                            self.notifyBottomConstraint.constant = -300
                            UIView.animate(withDuration: 0.45, animations: {
                                print("View Down")
                                self.view.layoutIfNeeded()
                            })
                            
                            self.ratingScrollView.isHidden = true
                            self.ratingViewBottonConstraint.constant = -300
                            UIView.animate(withDuration: 0.45, animations: {
                                print("View UP")
                                self.view.layoutIfNeeded()
                            })
                            
                            
                            guard let player = self.player else { return }
                            player.stop()
                            
                            
                            if self.schduleStr == "true" {
                                self.schduleStr = "false"
                                self.isSchedule = false
                                //Navigate to you trip view controller.
                            } else {
                                
                            }
                            
                        } else {
                           
                            guard let second = requestArray[0]["time_left_to_respond"] as? Int else {
                                print("Error in request dict")
                                return
                            }
                            
                            print("second Left", second)
                            self.secondsLeft = second
                            
                            
                            guard let requestDict = requestArray[0]["request"] as? Dictionary<String, AnyObject> else {
                                print("Error in request dict")
                                return
                            }
                            
                            guard let userDict = requestDict["user"] as? Dictionary<String, AnyObject> else {
                                print("Error in userDict")
                                return
                            }
                            
                            guard let request_id = requestArray[0]["request_id"] as? Int else {
                                print("Error in request_id")
                                return
                            }
                            
                            guard let provider_id = requestArray[0]["provider_id"] as? Int else {
                                print("Error in provider_id")
                                return
                            }
                            
                            UserDefaults.standard.set(request_id , forKey: "request_id")
                            UserDefaults.standard.set(provider_id , forKey: "provider_id")
                           // self.invoiceIdLbl.text = "INVOICE ID - " + (requestDict.validatedValue("booking_id", expected: "" as AnyObject) as! String)
                            
                            let status = requestDict.validatedValue("status", expected: "" as AnyObject) as! String
                            print("GLOBAL STATUS",self.globalStatus)
                            print("== STATUS",status)
                            
                            if self.globalStatus == status {
                                
                                self.globalStatus = ""
                                if status == "SEARCHING" {
                                    //Do Nothing....
                                } else {
                                    //Stop Audio Player....
                                    guard let player = self.player else { return }
                                    player.stop()
                                }
                                
                                
                                if  status == "STARTED" || status == "ARRIVED" || status == "PICKEDUP" || status == "DROPPED" {
                                    
                                    //Update map with driver and the dertination location....
                                    
                                    guard let destinationLat = Double(self.dM_Lat) else {return}
                                    guard let destinationLong = Double(self.dM_Long) else {return}
                                    self.destinationCo_Distance = CLLocation(latitude: destinationLat, longitude: destinationLong)
                                    
                                    let lat = self.myLocation.coordinate.latitude
                                    let long = self.myLocation.coordinate.longitude
                                    let navi_location = CLLocationCoordinate2D(latitude: lat, longitude: long)
                                    let old = self.markerCarLocation.position
                                    let new = navi_location
                                    
                                    
                                    self.markerCarLocation.position = navi_location
                                    self.markerCarLocation.icon = #imageLiteral(resourceName: "car")
                                    self.markerCarLocation.map = self.mapView
                                    
                                    
                                    CATransaction.begin()
                                    CATransaction.animationDuration()
                                    self.markerCarLocation.position = navi_location
                                    CATransaction.commit()
                                    
                                    self.makeRoute(sourceLat: navi_location.latitude, sourceLong: navi_location.longitude, destinationLat: destinationLat, destinationLong:  destinationLong, mapView: self.mapView, sourceMarkerImage: #imageLiteral(resourceName: "mapDestIcon"), destinationMarkerImage: #imageLiteral(resourceName: "mapDestIcon"))
                                    
                                    let getAngle = self.angleFromCoordinate(first: old, toCoordinate: new)
                                    self.markerCarLocation.rotation = getAngle * (180 / 3.14159265358979323846264338327950288)
                                    
                                    //self.getPath()
                                    //self.makeRoute(sourceLat: self.myLocation.coordinate.latitude, sourceLong: self.myLocation.coordinate.longitude, destinationLat: destinationLat, destinationLong: destinationLong, mapView: self.mapView, sourceMarkerImage: #imageLiteral(resourceName: "mapDestIcon"), destinationMarkerImage: #imageLiteral(resourceName: "finish-selected") )
                                    
                                   
                                }
                                
                                
                                
                            } else {
                                
                                self.globalStatus = ""
                                self.globalStatus = status
                                let paid = Int(requestDict.validatedValue("paid", expected: "" as AnyObject) as! String)
                                self.timerView.isHidden = true
                                //self.statusView.isHidden = true
                                self.rejectBtn.isHidden = true
                                self.acceptBtn.isHidden = true
                                self.SKUView.isHidden = true
                               // self.SKUHeightConstrint.constant = 0
                                
                                let scheduleString = requestDict.validatedValue("schedule_at", expected: "" as AnyObject) as! String
                                if scheduleString == "" {
                                    self.scheduleLbl.isHidden = true
                                    self.isSchedule = false
                                } else {
                                    self.scheduleLbl.isHidden = false
                                    self.scheduleLbl.text = "Schedule Request-" + scheduleString
                                    self.isSchedule = true
                                }
                                
                                self.d_Lat = requestDict.validatedValue("d_latitude", expected: "" as AnyObject) as! String
                                self.d_Long = requestDict.validatedValue("d_longitude", expected: "" as AnyObject) as! String
                                
                                self.dM_Lat = requestDict.validatedValue("s_latitude", expected: "" as AnyObject) as! String
                                self.dM_Long = requestDict.validatedValue("s_longitude", expected: "" as AnyObject) as! String
                                
                                print(self.dM_Lat,self.dM_Long)
                                
                                self.s_Lat = requestDict.validatedValue("s_latitude", expected: "" as AnyObject) as! String
                                self.s_Long = requestDict.validatedValue("s_longitude", expected: "" as AnyObject) as! String
                                
                                let s_address = requestDict.validatedValue("s_address", expected: "" as AnyObject) as! String
                                let d_address = requestDict.validatedValue("d_address", expected: "" as AnyObject) as! String
                                
                                ///////////////////
                                //rating user here
                                //////////////////
                                if let ratingValue = userDict["rating"] as? CGFloat {
                                     self.rating_user.value = ratingValue
                                }
                               
                                
                                self.pickUpAddressLbl.text = s_address
                                self.dropAddressLbl.text = d_address
                                
                                let firstName = userDict.validatedValue("first_name", expected: "" as AnyObject) as! String
                                let lastName = userDict.validatedValue("last_name", expected: "" as AnyObject) as! String
                                self.nameLbl.text = firstName + " " + lastName
                                self.rateNameLbl.text = "Rate your trip with " + firstName + " " + lastName
                                self.mobileStr = userDict.validatedValue("mobile", expected: "" as AnyObject) as! String
                                
                                var imageUrl = requestDict.validatedValue("picture", expected: "" as AnyObject) as! String
                                if imageUrl == "" {
                                    if imageUrl.contains("http") {
                                        imageUrl = userDict["picture"] as! String
                                    } else {
                                        let url = userDict["picture"] as! String
                                        imageUrl = BASE_URL + "public/storage/" + url
                                    }
                                    
                                    //////////////
                                    //Set Image
                                    //userImg
                                    //rateUserImg
                                    /////////////
                                    print("Image Url",imageUrl)
                                    
                                    self.userImg.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "userProfileIcon"))
                                    self.ratingImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "userProfileIcon"))
                                    
                                } else {
                                    self.userImg.image = #imageLiteral(resourceName: "userProfileIcon")
                                    self.ratingImageView.image = #imageLiteral(resourceName: "userProfileIcon")
                                }
                                
                                if  status == "STARTED" || status == "ARRIVED" || status == "PICKEDUP" || status == "DROPPED" {
                                   
                                    if self.socketConnectFlag {
                                        //Already connected
                                    } else {
                                        let socket = self.manager.defaultSocket
                                        socket.connect()
                                    }
                                }
                                
                                if status == "SEARCHING" {
                                    self.acceptBtn.setTitle("ACCEPT", for: .normal)
                                    self.rejectBtn.setTitle("REJECT", for: .normal)
                                    print("Seconds Left",self.secondsLeft)
                                    
                                    if self.secondsLeft <= 0 {
                                        
                                        self.notifyBottomConstraint.constant = -287
                                        UIView.animate(withDuration: 0.45, animations: {
                                            print("down")
                                             self.view.layoutIfNeeded()
                                        })
                                    } else {
                                        
                                        //////////////////
                                        //Audio File here
                                        //////////////////
                                        guard let player = self.player else { return }
                                        player.play()
                                        
                                        self.notifyBottomConstraint.constant = 0
                                        UIView.animate(withDuration: 0.45, animations: {
                                            print("View UP")
                                             self.view.layoutIfNeeded()
                                        })
                                    }
                                    
                                    self.timerView.isHidden = false
                                    //self.statusView.isHidden = false
                                    self.rejectBtn.isHidden = false
                                    self.acceptBtn.isHidden = false
                                    self.callBtn.isHidden = true
                                    
                                } else if status == "STARTED" {
                                    
                                    //self.statusView.isHidden = false
                                    self.rejectBtn.isHidden = false
                                    self.acceptBtn.isHidden = false
                                    
                                    //////////////////////
                                    //Stop Audio Player...
                                    //////////////////////
                                    guard let player = self.player else { return }
                                    player.stop()
                                    
                                    self.SKUView.isHidden = false
                                    //self.SKUHeightConstrint.constant = 50
                                    self.acceptBtn.setTitle("ARRIVED", for: .normal)
                                    self.rejectBtn.setTitle("CANCEL", for: .normal)
                                    self.statusBtn.setTitle("ARRIVED", for: .normal)
                                    
                                    self.notifyBottomConstraint.constant = 0
                                    UIView.animate(withDuration: 0.45, animations: {
                                        print("View UP")
                                        self.view.layoutIfNeeded()
                                    })
                                    
                                    
                                } else if status == "ARRIVED" {
                                    //self.statusView.isHidden = false
                                    self.rejectBtn.isHidden = false
                                    self.acceptBtn.isHidden = false
                                    self.SKUView.isHidden = false
                                    //self.SKUHeightConstrint.constant = 50
                                    
                                    self.acceptBtn.setTitle("PICKEDUP", for: .normal)
                                    self.rejectBtn.setTitle("CANCEL", for: .normal)
                                    self.statusBtn.setTitle("PICKEDUP", for: .normal)
                                    self.arrivedImg.isHighlighted =  true
                                    
                                    
                                    self.notifyBottomConstraint.constant = 0
                                    UIView.animate(withDuration: 0.45, animations: {
                                        print("View UP")
                                        self.view.layoutIfNeeded()
                                    })
                                    
                                } else if status == "PICKEDUP" {
                                    
                                    guard let requestDict = requestArray[0]["request"] as? Dictionary<String, AnyObject> else {
                                        print("Error in request dict")
                                        return
                                    }
                                    
                                    let startedAt = requestDict.validatedValue("started_at", expected: "" as AnyObject) as! String
                                    
                                    self.startRideTime = startedAt
                                    self.travelStatus = "driving"
                                    self.locationMapped = false
                                    self.SKUView.isHidden = false
                                    self.arrivedImg.isHighlighted = true
                                    self.pickupImg.isHighlighted = true
                                    self.acceptBtn.isHidden = true
                                    self.rejectBtn.isHidden = true
                                    self.statusBtn.isHidden = false
                                    self.statusBtn.setTitle("TAP WHEN DROPPED", for: .normal)
                                    
                                    self.notifyBottomConstraint.constant = 0
                                    UIView.animate(withDuration: 0.45, animations: {
                                        print("View UP")
                                        self.view.layoutIfNeeded()
                                    })
                                    
                                } else if status == "DROPPED" && paid == 0  {
                                    
                                    self.travelStatus = "stopped"
                                    self.arrivedImg.isHighlighted = true
                                    self.pickupImg.isHighlighted = true
                                    self.finishedImg.isHighlighted = true
                                    self.statusBtn.setTitle("ARRIVED", for: .normal)
                                    
                                    
                                    guard let currency = UserDefaults.standard.string(forKey: "currency") else {
                                        print("Error in geeting currency")
                                        return
                                    }
                                    
                                    guard let paymentDict = requestDict["payment"] as? Dictionary<String, AnyObject> else {
                                        print("Error in geeting paymentDict")
                                        return
                                    }

                                
                                    let fixed = paymentDict.validatedValue("fixed", expected: "" as AnyObject) as! String
                                    let total = paymentDict.validatedValue("total", expected: "" as AnyObject) as! String
                                    let tax = paymentDict.validatedValue("tax", expected: "" as AnyObject) as! String
                                    let distance = paymentDict.validatedValue("distance", expected: "" as AnyObject) as! String
                                    let bookId = requestDict.validatedValue("booking_id", expected: "" as AnyObject) as! String
                                
                                    self.distanceValueLbl.text = currency + distance
                                    self.baseValueLbl.text = currency + fixed
                                    self.totalValueLbl.text = currency + total
                                    self.taxValueLbl.text = currency + tax
                                    self.bookingID.text = bookId
                                    self.confirmPaymentButton.isHidden = false
                                    self.invoiceBottomConstraint.constant = 0
                                    
                                    UIView.animate(withDuration: 0.45, animations: {
                                        print("View UP")
                                        self.view.layoutIfNeeded()
                                    })
                                    
                                } else if status == "DROPPED" && paid == 1 {
                                    
                                    self.ratingScrollView.isHidden = false
                                    self.statusBtn.isHidden = true
                                    self.ratingViewBottonConstraint.constant = 0
                                    UIView.animate(withDuration: 0.45, animations: {
                                        print("View UP")
                                        self.view.layoutIfNeeded()
                                    })
                                    
                                } else if status == "COMPLETED" {
                                    
                                    //self.confirmPaymentButton.isHidden = false
                                    self.invoiceBottomConstraint.constant = -300
                                    UIView.animate(withDuration: 0.45, animations: {
                                        print("View UP")
                                        self.view.layoutIfNeeded()
                                    })

                                    self.notifyBottomConstraint.constant = -300
                                    UIView.animate(withDuration: 0.45, animations: {
                                        print("View UP")
                                        self.view.layoutIfNeeded()
                                    })

                                    self.ratingScrollView.isHidden = false
                                    self.statusBtn.isHidden = true
                                    self.ratingViewBottonConstraint.constant = 0
                                    UIView.animate(withDuration: 0.45, animations: {
                                        print("View UP")
                                        self.view.layoutIfNeeded()
                                    })
//
                                    
                                    //Check the payment mode for wallet payment.
//                                    let requestArray = result["requests"] as! Array<AnyObject>
//
//                                    guard let requestDict = requestArray[0]["request"] as? Dictionary<String, AnyObject> else {
//                                        print("Error in request dict")
//                                        return
//                                    }
//
//                                    let paymentMode = requestDict.validatedValue("payment_mode", expected: "" as AnyObject) as! String
//
//                                    if paymentMode == "CASH" {
//
//                                        guard let currency = UserDefaults.standard.string(forKey: "currency") else {
//                                            print("Error in geeting currency")
//                                            return
//                                        }
//
//                                        guard let payment = requestDict["payment"] as? Dictionary<String, AnyObject> else {
//                                            print("Error in userDict")
//                                            return
//                                        }
//
//                                        let fixed = payment.validatedValue("fixed", expected: "" as AnyObject) as! String
//                                        let total = payment.validatedValue("total", expected: "" as AnyObject) as! String
//                                        let tax = payment.validatedValue("tax", expected: "" as AnyObject) as! String
//                                        let distance = payment.validatedValue("distance", expected: "" as AnyObject) as! String
//
//                                        self.distanceValueLbl.text = currency + distance
//                                        self.baseValueLbl.text = currency + fixed
//                                        self.totalValueLbl.text = currency + total
//                                        self.taxValueLbl.text = currency + tax
//
//                                        self.stackPaymentModeOutlet.isHidden = true
//                                        self.confirmPaymentButton.isHidden = false
//                                        self.confirmPaymentButton.setTitle("Done", for: .normal)
//
//
//                                        self.notifyBottomConstraint.constant = -300
//                                        UIView.animate(withDuration: 0.45, animations: {
//                                            print("View UP")
//                                            self.view.layoutIfNeeded()
//                                        })
//
//
//                                        self.invoiceBottomConstraint.constant = -300
//                                        UIView.animate(withDuration: 0.45, animations: {
//                                            print("View UP")
//                                            self.view.layoutIfNeeded()
//                                        })
//
//
//
//                                        self.ratingScrollView.isHidden = false
//                                        self.statusBtn.isHidden = true
//                                        self.ratingViewBottonConstraint.constant = 0
//                                        UIView.animate(withDuration: 0.45, animations: {
//                                            print("View UP")
//                                            self.view.layoutIfNeeded()
//                                        })
//
//
//                                    } else {
//                                        self.invoiceBottomConstraint.constant = -300
//                                        UIView.animate(withDuration: 0.45, animations: {
//                                            print("View UP")
//                                            self.view.layoutIfNeeded()
//                                        })
//
//                                        self.notifyBottomConstraint.constant = -300
//                                        UIView.animate(withDuration: 0.45, animations: {
//                                            print("View UP")
//                                            self.view.layoutIfNeeded()
//                                        })
//
//                                        self.ratingScrollView.isHidden = false
//                                        self.statusBtn.isHidden = true
//                                        self.ratingViewBottonConstraint.constant = 0
//                                        UIView.animate(withDuration: 0.45, animations: {
//                                            print("View UP")
//                                            self.view.layoutIfNeeded()
//                                        })
//                                    }
                                }
                                
                                if self.locationMapped || self.moveNextLocation {
                                    //Location mapped already
                                } else {
                                    
                                    if status == "SEARCHING" || status == "STARTED" || status == "ARRIVED" {
                                        
                                        let polyLine = GMSPolyline()
                                        polyLine.map = nil
                                        self.mapView.clear()
                                        
                                        self.locationMapped = true
                                        self.switchMapStr = "Driver"
                                        self.d_Lat = ""
                                        self.d_Long =  ""
                                        
                                        self.d_Lat = String(self.s_Lat)
                                        self.d_Long = String(self.s_Long)
                                        
                                        self.s_Lat = String(format: "%.8f", self.myLocation.coordinate.latitude)
                                        self.s_Long = String(format: "%.8f", self.myLocation.coordinate.longitude)
                                        
                                    } else {
                                        let polyLine = GMSPolyline()
                                        polyLine.map = nil
                                        self.mapView.clear()
                                        self.moveNextLocation = true
                                        self.switchMapStr = "User"
                                    }
                                    
                                    if self.s_Lat.length == 0 || self.s_Lat == "<null>" || self.s_Lat == " " || self.s_Lat == "<nil>" || self.s_Lat == "" || self.d_Lat.length == 0 || self.d_Lat == "<null>" || self.d_Lat == " " || self.d_Lat == "<nil>" || self.d_Lat == ""  {
                                        print("s_Lat.length d_Lat")
                                    } else {
                                        
                                        
                                        guard let sourceLat = Double(self.s_Lat) else {return}
                                        guard let sourceLong = Double(self.s_Long) else {return}
                                        
                                        guard let destinationLat = Double(self.dM_Lat) else {return}
                                        guard let destinationLong = Double(self.dM_Long) else {return}
                                        
//                                        self.startLocationMarker.map = nil
//                                        self.startLocationMarker = GMSMarker()
//                                        self.startLocationMarker.position = CLLocationCoordinate2DMake(sourceLat, sourceLong)
//                                        self.startLocationMarker.icon = #imageLiteral(resourceName: "mapDestIcon")
//                                        self.startLocationMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
//                                        self.startLocationMarker.appearAnimation = GMSMarkerAnimation.pop
//                                        self.bounds = self.bounds.includingCoordinate(self.startLocationMarker.position)
//
//                                        self.endLocationMarker.map = nil
//                                        self.endLocationMarker = GMSMarker()
//                                        self.endLocationMarker.position = CLLocationCoordinate2DMake(destinationLat, destinationLong)
//                                        self.endLocationMarker.icon = #imageLiteral(resourceName: "mapDestIcon")
//                                        self.endLocationMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
//                                        self.endLocationMarker.appearAnimation = GMSMarkerAnimation.pop
//                                        self.bounds = self.bounds.includingCoordinate(self.endLocationMarker.position)
//
//                                        self.startLocationMarker.map = self.mapView
//                                        self.endLocationMarker.map = self.mapView
                                        
                                        print("Source",self.s_Lat,self.s_Long)
                                        print("destination",self.d_Lat,self.d_Long)
                                        
                                        
                                        //self.getPath()
                                        self.makeRoute(sourceLat: sourceLat, sourceLong: sourceLong, destinationLat: destinationLat, destinationLong: destinationLong, mapView: self.mapView, sourceMarkerImage: #imageLiteral(resourceName: "mapDestIcon"), destinationMarkerImage: #imageLiteral(resourceName: "finish-selected") )
                                        
                                    }
                                }
                            }
                        }
                    } else {
                       

                        UserDefaults.standard.set("0" , forKey: "Active")
                        self.offlineViewSetup()
                        self.goOnlineButton.isHidden = false
                        
                    }
                }
            } else {
                //call logout method here.....
            }
        }
        
        
    }
    
    
    func angleFromCoordinate(first: CLLocationCoordinate2D, toCoordinate second: CLLocationCoordinate2D) -> Double {
        let deltaLongitude = second.longitude - first.longitude
        let deltaLatitude =  second.latitude - first.latitude
        let angle =  (3.14159265358979323846264338327950288 * 0.5) - atan(deltaLatitude/deltaLongitude)
        
        if deltaLongitude > 0 {
            return angle
        } else if deltaLongitude < 0 {
            return angle + 3.14159265358979323846264338327950288
        } else if deltaLatitude < 0 {
            return 3.14159265358979323846264338327950288
        }
        
        return 0.0
        
    }

    
    func getStatusMethod(with statusStr: String) {
        
        goOnlineButton.isHidden = false
        offlineView.isHidden = true
        
        if statusStr == "onboarding" || statusStr == "banned" {
            waitingLbl.isHidden = false
            goOnlineButton.isHidden = true
            offlineViewSetup()
            offlineView.isHidden = false
            
        } else if statusStr == "approved" {
            guard let activeStatus = UserDefaults.standard.string(forKey: "Active") else { return }
            if activeStatus == "1" {
                goOnlineButton.setTitle("GO OFFLINE", for: .normal)
                onlineViewSetup()
            } else {
                goOnlineButton.setTitle("GO ONLINE", for: .normal)
                offlineViewSetup()
            }
        } else {
            
            goOnlineButton.isHidden = true
            
        }
        
    }
    
    func offlineViewSetup() {
        currentLocationBtn.isHidden = true
        offlineView.isHidden = false
        guard let status = UserDefaults.standard.string(forKey: "status") else { return }
        
        if status == "onboarding" || status == "banned" {
            waitingLbl.isHidden = false
        } else {
            waitingLbl.isHidden = true
        }
        
        goOnlineButton.setTitle("GO ONLINE", for: .normal)
    }
    
    func onlineViewSetup(){
        currentLocationBtn.isHidden = false
        waitingLbl.isHidden = false
        offlineView.isHidden = true
        goOnlineButton.isHidden = false
        goOnlineButton.setTitle("GO OFFLINE", for: .normal)
    }
    
    
    
    func customInit() {
        goOnlineButton.layer.cornerRadius = 20
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "driver", withExtension: "gif")!)
        let gif = UIImage.gifImageWithData(imageData!)
        gifImageView.image = gif
    }
    
    
    //MARK:- Memory Warning Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Location Update Method
    @objc func updateLocation(){
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    //MARK:- IBAction Method
    @IBAction func menuBtnAction(_ sender: UIButton) {
        self.toggleSlider()
    }
    
    @IBAction func currentLocationBtnAction(_ sender: UIButton) {
        mapView.camera = GMSCameraPosition(target: myLocation.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
    }
    
    @IBAction func goOnlineOfflineBtnAction(_ sender: UIButton) {
        
        globalStatus = ""
        var statusStr = ""
        guard let player = player else { return }
        player.stop()
        
        if goOnlineButton.titleLabel?.text == "GO ONLINE" {
            statusStr = "active"
            getIncomingRequest()
        } else {
            statusStr = "offline"
        }
        updateAvailablity(status: statusStr)
    }
    
    
    @IBAction func acceptBtn(_ sender: UIButton) {
        
        guard let player = player else { return }
        player.stop()
        
        if acceptBtn.currentTitle == "ARRIVED" {
            statusBtn.setTitle("ARRIVED", for: .normal)
            statusBtnAction(self)
        } else if acceptBtn.currentTitle == "PICKEDUP" {
            statusBtn.setTitle("PICKEDUP", for: .normal)
            statusBtnAction(self)
        } else if  acceptBtn.currentTitle == "ACCEPT" {
            
            calCulateOneTime = true
            if isSchedule {
                scheduleStr = "true"
                
                self.notifyBottomConstraint.constant = -300
                UIView.animate(withDuration: 0.45, animations: {
                    print("View UP")
                    self.view.layoutIfNeeded()
                })
                
            } else {
                scheduleStr = "false"
            }
            
            guard let request_id = UserDefaults.standard.string(forKey: "request_id") else {
                print("Cannnot get requestid in accept btn.")
                return
            }
            
            let url = API_INCOMING_REQUEST + "/" + request_id
            
            ServiceHelper.sharedInstance.createPostRequest(isShowHud: true, params: [:], apiName: url) { (response, error) in
                if error != nil {
                    AlertController.alert(title: appName, message: (error?.description)!)
                    return
                }
                
                if response != nil {
                    if self.scheduleStr == "true" {
                        self.acceptBtn.isHidden = true
                        self.rejectBtn.isHidden = true
                    }
                    
                    self.getIncomingRequest()
                    self.timerView.isHidden = true
                    
                } else {
                    print("Handle Nil response here..")
                }
            }
        }
    }
    
    @IBAction func rejectBtn(_ sender: UIButton) {
        guard let player = player else { return }
        player.stop()
        
        if rejectBtn.currentTitle == "CANCEL" {
            //Call Cancel Action
            cancelRide()
        } else {
            scheduleStr = "false"
            
            guard let request_id = UserDefaults.standard.string(forKey: "request_id") else {
                print("Cannnot get requestid in accept btn.")
                return
            }
            
            let url = API_INCOMING_REQUEST + "/" + request_id
            ServiceHelper.sharedInstance.createDeleteRequest(isShowHud: true, params: [:], apiName: url) { (response, error) in
                if error != nil {
                    AlertController.alert(title: appName, message: (error?.description)!)
                    return
                }
                
                if response != nil {
                    let polyline = GMSPolyline()
                    polyline.map = nil
                    self.mapView.clear()
                    
                    //self.startLocationMarker.map = nil
                    //self.startLocationMarker = GMSMarker()
                    
                    //self.endLocationMarker.map = nil
                    //self.endLocationMarker = GMSMarker()
                    
                     self.mapView.camera = GMSCameraPosition(target: self.myLocation.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
                    
                    //Do Something with noitfy view
                } else {
                    //Handle Nil response.
                }
            }
        }
    }
    
    @IBAction func paymentButtonAction(_ sender: UIButton) {
        self.updateStatus(status: "COMPLETED")
    }
    
    func cancelRide() {
        
        
        guard let request_id = UserDefaults.standard.string(forKey: "request_id") else {
            print("Cannnot get requestid in cancelRide.")
            return
        }
        
        let url = "api/provider/cancel"
        let param = [
            "id" : request_id
        ]
        
        ServiceHelper.sharedInstance.createPostRequest(isShowHud: true, params: param as [String : AnyObject], apiName: url) { (response, error) in
            if error != nil {
                AlertController.alert(title: appName, message: (error?.description)!)
                return
            }
            
            if response != nil {
                let polyline = GMSPolyline()
                polyline.map = nil
                self.mapView.clear()
                
                //self.startLocationMarker.map = nil
                //self.startLocationMarker = GMSMarker()
                
                //self.endLocationMarker.map = nil
                //self.endLocationMarker = GMSMarker()
                
                self.mapView.camera = GMSCameraPosition(target: self.myLocation.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
                
                self.notifyBottomConstraint.constant = -300
                UIView.animate(withDuration: 0.45, animations: {
                    print("View UP")
                    self.view.layoutIfNeeded()
                })
            }
        }
        
    }
    
    
    @IBAction func statusBtnAction(_ sender: Any) {
        
        if statusBtn.currentTitle == "ARRIVED" {
            self.updateStatus(status: "ARRIVED")
        } else if statusBtn.currentTitle == "PICKEDUP" {
             self.updateStatus(status: "PICKEDUP")
        } else if statusBtn.currentTitle == "TAP WHEN DROPPED" {
            self.updateStatus(status: "DROPPED")
        } else if statusBtn.currentTitle == "COMPLETED" {
            self.updateStatus(status: "COMPLETED")
        }
        
    }
    
    
    @IBAction func callButtonWasTapped(_ sender: UIButton) {
        
        if mobileStr == "" {
            AlertController.alert(message: "User was not gave the mobile number")
        } else {
            callNumber(phoneNumber: mobileStr)
        }
        
        
    }
    
    func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    
    func updateStatus(status: String) {
        
        
        if status == "DROPPED" {
            
            //Geting distance
            
            let lat = self.myLocation.coordinate.latitude
            let long = self.myLocation.coordinate.longitude
            self.sourceCo_Distance = CLLocation(latitude: lat, longitude: long)
            self.totalM = self.totalM + self.sourceCo_Distance.distance(from: self.destinationCo_Distance)
            self.totalM = self.totalM / 1000
            print("Total Distance ==", String(format: "%.01f", totalM))
            
            
            let ceo = CLGeocoder()
            ceo.reverseGeocodeLocation(CurrentLocation) { (placemarks, error) in
                
                guard let placemark = placemarks?[0] else {
                    self.locationString = ""
                    print("Plcemark Error in update status")
                    return
                }
                
                var locatedAt : String = ""
                if placemark.subLocality != nil {
                    locatedAt = locatedAt + placemark.subLocality! + ", "
                }
                if placemark.thoroughfare != nil {
                    locatedAt = locatedAt + placemark.thoroughfare! + ", "
                }
                if placemark.locality != nil {
                    locatedAt = locatedAt + placemark.locality! + ", "
                }
                if placemark.country != nil {
                    locatedAt = locatedAt + placemark.country! + ", "
                }
                if placemark.postalCode != nil {
                    locatedAt = locatedAt + placemark.postalCode! + " "
                }
                
                guard let name = placemark.name else {
                    return
                }
                
                guard let locality = placemark.locality else {
                    return
                }
                
                guard let subAdministrativeArea = placemark.subAdministrativeArea else {
                    return
                }
                
                
                self.locationString = name + "," + locality + "," + subAdministrativeArea
                
                guard let request_id = UserDefaults.standard.string(forKey: "request_id") else {
                    print("Cannnot get requestid in accept btn.")
                    return
                }
                
                
                
                
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ssz"
                
                let myString = formatter.string(from: Date()) // string purpose I add here
                // convert your string to date
                let yourDate = formatter.date(from: myString)
                //then again set the date format whhich type of output you need
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                // again convert your date to string
                let myStringafd = formatter.string(from: yourDate!)
              
                
                let mins = self.timeGapBetweenDates(previousDate : self.startRideTime, currentDate : myStringafd)
                print(mins)
                
                let param = [
                    "d_address" : self.locationString,
                    "d_latitude" :String(format: "%.8f", self.CurrentLocation.coordinate.latitude),
                    "d_longitude" : String(format: "%.8f", self.CurrentLocation.coordinate.longitude),
                    "distance" : String(format: "%.01f", self.totalM),
                    "request_id" : request_id,
                    "finished_at" : myStringafd,
                    "ride_time" : mins
                    
                    ] as [String : Any]
                
                //self.statusUpdateMethod(parameter: param)
                print("Update Status Param",param)
                
                ServiceHelper.sharedInstance.createPostRequest(isShowHud: true, params: param as [String : AnyObject], apiName: API_REQUEST_UPDATE_DESTINATION) { (response, error) in
                    
                    if error != nil {
                        //AlertController.alert(title: appName, message: (error?.description)!)
                        return
                    }
                    
                    if response != nil {
                        
                        let param = [
                            "status" : "DROPPED",
                        ]
                        self.statusUpdateMethod(parameter: param)
                        
                    } else {
                        //HANDLE NIL RESPONSE...
                    }
                }
            }
        }  else {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ssz"
            
            let myString = formatter.string(from: Date()) // string purpose I add here
            // convert your string to date
            let yourDate = formatter.date(from: myString)
            //then again set the date format whhich type of output you need
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            // again convert your date to string
            let myStringafd = formatter.string(from: yourDate!)
            print("Converted Date",myStringafd)
            
            let param = [
                "status" : status,
                "started_at" : myStringafd
            ]
            self.statusUpdateMethod(parameter: param)
        }
    }
    
    
    
    
    func statusUpdateMethod(parameter: [String: Any]) {
        
        guard let request_id = UserDefaults.standard.string(forKey: "request_id") else {
            print("Cannnot get requestid in accept btn.")
            return
        }
        
        let url = API_INCOMING_REQUEST + "/" + request_id
        
        ServiceHelper.sharedInstance.createPatchRequest(isShowHud: true, params: parameter as [String : AnyObject], apiName: url) { (response, error) in
            
            if error != nil {
                AlertController.alert(title: appName, message: (error?.description)!)
                return
            }
            
            if response != nil {
                self.getIncomingRequest()
            } else {
                print("Response is empty.")
            }
        }
    }
    
    
    func updateAvailablity(status: String) {
        
        let param = [
            "service_status" : status
        ]
        
        ServiceHelper.sharedInstance.createPostRequest(isShowHud: true, params: param as [String : AnyObject], apiName: API_PROFILE_AVAILABILITY) { (response, error) in
            if error != nil {
                AlertController.alert(title: appName, message: (error?.description)!)
                return
            }
            
            if response != nil {
                
                let jsonResponse = JSON(response as Any)
                let firstname = jsonResponse["first_name"].stringValue
                let lastname = jsonResponse["last_name"].stringValue
                let avatar = jsonResponse["avatar"].stringValue
                let serviceArray = jsonResponse["service"].arrayValue
                let serviceStatus = serviceArray[0]["status"].stringValue
                
                if serviceStatus == "active" {
                    
                    self.mapView.isHidden = false
                    self.offlineView.isHidden = true
                    self.goOnlineButton.setTitle("GO OFFLINE", for: .normal)
                    self.onlineViewSetup()
                    
                } else {
                    
                    self.mapView.isHidden = true
                    self.offlineView.isHidden = false
                    self.goOnlineButton.setTitle("GO ONLINE", for: .normal)
                    self.offlineViewSetup()
                    
                }
                
                UserDefaults.standard.set(firstname , forKey: "first_name")
                UserDefaults.standard.set(lastname , forKey: "last_name")
                UserDefaults.standard.set(avatar , forKey: "avatar")
                UserDefaults.standard.set(status , forKey: "status")
                
            } else {
                //Handle when the response is nil.
            }
        }
    }
    
    
    
    @IBAction func submitReviewBtnTapped(_ sender: Any) {
        
        guard let request_ID = UserDefaults.standard.string(forKey: "request_id")  else {
            print(" In Submit review")
            AlertController.alert(message: "Review Not Submit")
            return
        }
        
        let rating = Int(ratingStarView.value)
        
        let param = [
            "rating" : rating,
            "comment" : ratingTextView.text
            ] as [String : Any]
        
        let api = "api/provider/trip/" + request_ID + "/rate"
        print("Review API", api)
        
        ServiceHelper.sharedInstance.createPostRequest(isShowHud: true, params: param as [String : AnyObject], apiName: api) { (response, error) in
            
            if error != nil {
                AlertController.alert(title: appName, message: (error?.description)!)
                return
            }
            
            if response != nil {
                self.ratingTextView.text = ""
                self.ratingStarView.value = 1
                self.checkWalletStatus = false
                
                
                self.ratingViewBottonConstraint.constant = -300
                UIView.animate(withDuration: 0.45, animations: {
                    print("View UP")
                    self.view.layoutIfNeeded()
                })
                
                self.ratingScrollView.isHidden = true
                self.mapView.camera = GMSCameraPosition(target: self.myLocation.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
                self.getIncomingRequest()
            }
        }
    }
    
}


extension HomeVC: CLLocationManagerDelegate,GMSMapViewDelegate {
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        case .denied:
            showAcessDeniedAlert()
        case .notDetermined:
            locationManager.delegate = self
            locationManager.requestAlwaysAuthorization()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
        
        print("In Did update Locations")
        myLocation = location
        
        let socket = self.manager.defaultSocket
        if socket.status.rawValue == 3 {
            
            guard let strReqID = UserDefaults.standard.string(forKey: "request_id") else {
                print("Error in request_id didUpdateLocations")
                return
            }
            
            guard let strproID = UserDefaults.standard.string(forKey: "provider_id") else {
                print("Error in request_id didUpdateLocations")
                return
            }
            
            let emitData = [
                "latitude" : String(format: "%.8f", myLocation.coordinate.latitude),
                "longitude" : String(format: "%.8f", myLocation.coordinate.longitude),
                "request_id" : strReqID,
                "provider_id" : strproID
            ]
            
            socket.emit("update location", with: [emitData])
            
        }
        
        
        let loc = locations.last
        CurrentLocation = CLLocation(latitude: (loc?.coordinate.latitude)!, longitude: (loc?.coordinate.longitude)!)
        
        if travelStatus == "driving" {
            if StartLocationTaken == false {
                StartLocationTaken = true
                startLocation = CLLocation(latitude: CurrentLocation.coordinate.latitude, longitude: CurrentLocation.coordinate.longitude)
                
                newLocaton = CLLocation()
                oldLocation = CLLocation()
                oldLocation = startLocation
            }
            newLocaton = CurrentLocation
            
            if newLocaton.coordinate.latitude == oldLocation.coordinate.latitude &&
                newLocaton.coordinate.longitude == oldLocation.coordinate.longitude {
                print("same Location")
            } else {
                totalM = totalM + newLocaton.distance(from: oldLocation)
            }
            
            
            totalKM = totalM / 1000
            oldLocation = newLocaton
            
            let distance2 = totalM * 0.000621371
            totalDistance = ""
            totalDistance = String(format: "%.2f", distance2)
            
           
            
        }
        
        
        
       
//        reverseGeocodeCoordinate(location.coordinate)
//        lat = "\(location.coordinate.latitude)"
//        long = "\(location.coordinate.longitude)"
//        sourceLat = "\(location.coordinate.latitude)"
//        sourceLong = "\(location.coordinate.longitude)"
//        mapView.clear()
//        let marker = PlaceMarker(place: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), image: "UserIcon")
//        marker.map = mapView
        if flag {
            flag = false
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        }
          mapView.isMyLocationEnabled = true
        
//        locationManager.stopUpdatingLocation()
    }
    
    
    // MARK: - MapviewDelegate
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
        sourceLat = "\(position.target.latitude)"
        sourceLong = "\(position.target.longitude)"
    }
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            //self.locName = lines.joined(separator: "\n")
            //self.yourLocationLabel.numberOfLines = 2
            //self.yourLocationLabel.text = self.locName
            
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    func showAcessDeniedAlert() {
        
        let alertController = UIAlertController(title: kLocationAccess,
                                                message: kLocationUnavailable,
                                                preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (alertAction) in
            if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(appSettings as URL)
            }
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(settingsAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){ (alertAction) in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {

        layer.shadowColor = color.cgColor
        layer.shadowOffset = offSet
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
}

extension HomeVC {
    
    func makeRoute(sourceLat: Double, sourceLong: Double, destinationLat: Double, destinationLong: Double, mapView:GMSMapView,
                   sourceMarkerImage: UIImage, destinationMarkerImage: UIImage){
        
        let source = "\(sourceLat),\(sourceLong)"
        let dest = "\(destinationLat),\(destinationLong)"
        
        if (reachability?.isReachable)! {
            
            let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(source)&destination=\(dest)&mode=driving&key=\(GMSPLACES_KEY)"
            
            Alamofire.request(url).responseJSON { response in
                
                debugPrint(response)
                if response.result.value != nil{
                    //let source = "\(37.331246),\(-122.030725)"
                    //let dest = "\(37.334452),\(-122.005446)"
                    
                   
                    self.sourceMarker.position = CLLocationCoordinate2D(latitude: sourceLat, longitude: sourceLong)
                    self.sourceMarker.icon =  sourceMarkerImage
                    //self.sourceMarker.map = self.mapView
                    
                   
                    self.destMarker.position = CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLong)
                    self.destMarker.icon =  destinationMarkerImage
                    self.destMarker.map = self.mapView
                    
                    
                    
                    if let json = response.result.value! as? NSDictionary{
                        if let routes = json["routes"] as? NSArray{
                            
                            for route in routes
                            {
                                
                                
                                let routeOverviewPolyline:NSDictionary = (route as! NSDictionary).value(forKey: "overview_polyline") as! NSDictionary
                                let points = routeOverviewPolyline.object(forKey: "points") as! String
                                if let path = GMSPath.init(fromEncodedPath: points){
                                    
                                    
                                    self.polyline.map = nil
                                    self.polyline = GMSPolyline(path: path)
                                    self.polyline.strokeColor = .lightGray
                                    self.polyline.strokeWidth = 3.0
                                    self.polyline.map = mapView
                                    
                                    self.polylineTimer.invalidate()
                                    self.polylineTimer = Timer.scheduledTimer(withTimeInterval: 0.005, repeats: true, block: { timer in
                                        self.animate(path)
                                    })
                                    
                                    let bounds = GMSCoordinateBounds(path: path)
                                    let cameraUpdate = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 70, left: 50, bottom: 70, right: 50))
                                    self.mapView.animate(with: cameraUpdate)
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func animate(_ path: GMSPath) {
        DispatchQueue.main.async {
            let pathCount = path.count()
            if self.i < pathCount {
                self.path2.add(path.coordinate(at: UInt(self.i)))
                self.polylineBlack = GMSPolyline(path: self.path2)
                self.polylineBlack.strokeColor = #colorLiteral(red: 0.2233502538, green: 0.2233502538, blue: 0.2233502538, alpha: 1)
                self.polylineBlack.strokeWidth = 3
                self.polylineBlack.map = self.mapView
                self.arrayPolylineBlack.add(self.polylineBlack)
                self.i += 1
            } else {
                self.i = 0
                self.path2 = GMSMutablePath()
                self.polylineTimer.invalidate()
            }
        }
    }
    
    
    
    
    func timeGapBetweenDates(previousDate : String,currentDate : String) -> Int
    {
        let dateString1 = previousDate
        let dateString2 = currentDate
        
        let Dateformatter = DateFormatter()
        Dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        
        let date1 = Dateformatter.date(from: dateString1)
        let date2 = Dateformatter.date(from: dateString2)
        
        
        let distanceBetweenDates: TimeInterval? = date2?.timeIntervalSince(date1!)
        let secondsInAnHour: Double = 3600
        let minsInAnHour: Double = 60
        let secondsInDays: Double = 86400
        let secondsInWeek: Double = 604800
        let secondsInMonths : Double = 2592000
        let secondsInYears : Double = 31104000
        
        let minBetweenDates = Int((distanceBetweenDates! / minsInAnHour))
        let hoursBetweenDates = Int((distanceBetweenDates! / secondsInAnHour))
        let daysBetweenDates = Int((distanceBetweenDates! / secondsInDays))
        let weekBetweenDates = Int((distanceBetweenDates! / secondsInWeek))
        let monthsbetweenDates = Int((distanceBetweenDates! / secondsInMonths))
        let yearbetweenDates = Int((distanceBetweenDates! / secondsInYears))
        let secbetweenDates = Int(distanceBetweenDates!)
        
        
        
        
        if yearbetweenDates > 0
        {
            print(yearbetweenDates,"years")//0 years
        }
        else if monthsbetweenDates > 0
        {
            print(monthsbetweenDates,"months")//0 months
        }
        else if weekBetweenDates > 0
        {
            print(weekBetweenDates,"weeks")//0 weeks
        }
        else if daysBetweenDates > 0
        {
            print(daysBetweenDates,"days")//5 days
        }
        else if hoursBetweenDates > 0
        {
            print(hoursBetweenDates,"hours")//120 hours
        }
        else if minBetweenDates > 0
        {
            print(minBetweenDates,"minutes")//7200 minutes
        }
        else if secbetweenDates > 0
        {
            print(secbetweenDates,"seconds")//seconds
        }
        
        
        return minBetweenDates
    }
}
