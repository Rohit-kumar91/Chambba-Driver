//
//  Constant.swift
//  Abba Taxi
//
//  Created by Rishabh Arora on 10/26/18.
//  Copyright © 2018 Rishabh Arora. All rights reserved.
//

import UIKit
import Foundation

typealias JSONDictionary = [String:Any]
typealias JSONArray = [JSONDictionary]
typealias APIServiceFailureCallback = ((Error?) -> ())
typealias JSONArrayResponseCallback = ((JSONArray?) -> ())
typealias JSONDictionaryResponseCallback = ((JSONDictionary?) -> ())

let appName = "Chambba"
let reachability = Reachability()

let ACCEPTABLE_CHARACTERS = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"



let STRIPE_BASE_URL = "https://chambba.xicom.us/api/"

//https://chambba.xicom.us/api/provider/stripe/account
let CALLBACK_STRIPE =  "chambba.xicom.us"//"chambba.xicom.us"
let BASE_URL = "http://14.141.175.109/chambba/"
let SOCKET_URL = "http://45.55.236.119:7000"
//let BASE_URL = "http://dev2.xicom.us/chambba/"
//let SOCKET_URL = "http://dev2.xicom.us:3000"


let appId = "trainwaker/id1401895046"
let apiKey = "d1608c2419512fcd32912cce3e73ea13"
let shareUrl = "https://itunes.apple.com/app/\(appId)?mt=8"

let GMSMAP_KEY = "AIzaSyB6uLaW29x4dAs5FGATQJbAwd9qfD8iKCI"//"AIzaSyBKwV2w7uWSf3bpgZeRNbMTBKdRbqnmQew"
let GMSPLACES_KEY = "AIzaSyB6uLaW29x4dAs5FGATQJbAwd9qfD8iKCI"//"AIzaSyCqcpaTcjy1vKoImiftj6GgQJs8ult59V8"

//MARK:- Constants
let WINDOW_WIDTH = UIScreen.main.bounds.width
let WINDOW_HEIGHT = UIScreen.main.bounds.height
let phoneMinLength = 10
let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
let storyboard = UIStoryboard(name: "Main", bundle: nil)
let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)

let OtherStoryboard = UIStoryboard(name: "Other", bundle: nil)

let APPOUTGOINGCHATCOLOR = UIColor.init(red: (118/255.0), green: (117/255.0), blue: (135/255.0), alpha: 1.0)
let APPINCOMINGCHATCOLOR = UIColor.init(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1.0)
let APPCHATCELLBACKGROUNDCOLOR = UIColor.init(red: (242/255.0), green: (243/255.0), blue: (245/255.0), alpha: 1.0)

let UPDATE = "UPDATE"
let CONTINUE = "CONTINUE"
let kMessage = "message"
let kInternetConnection = "Internet connection not available, you must turn on to download app content."
let kLocationAccess = "Location Access Requested"
let kLocationUnavailable = "Location services are disabled, you must turn on Location Services from Settings."

let PROFILE_IMAGE = "picture"
let ACCESS_TOKEN = "access_token"
let ID = "id"
let SOS = "sos"
let TOKEN_TYPE = "token_type" 
let REFRESH_TOKEN = "ref_token"
let DEVICE_TOKEN = "DeviceToken"
let DEVICE_TYPE = "ios"
let CLIENT_ID = "11"
let CLIENT_SECRET = "rt8ARpmeGo8IL0hiGMwxeLoWjPfAGPi6tO5lKMM6"
let STRIPE_CLIENT_ID =  "ca_EoHsphg9yFv4sKtOzjsLm5nPyWsPox5F" //"ca_E1flL8GSUK3k5eqGrDGPNbzFRjpqMEVs"

// API Paramter
let API_Login = "api/provider/oauth/token"
let API_GetProfile = "api/provider/profile"
let API_GetTripHistory = "api/provider/requests/history"
let API_UPComingTrip = "api/provider/requests/upcoming"
let API_Update_Profile = "api/provider/profile"
let API_ChangePasword = "api/provider/profile/password"
let API_ForgotPassword = "api/provider/forgot/password"
let API_RESETPASSWORD = "api/provider/reset/password"
let API_PROVIDER_REGISTER = "api/provider/register"
let API_INCOMING_REQUEST = "api/provider/trip"
let API_SUMMARY = "api/provider/summary"
let API_EARNING = "api/provider/target"
let API_PROFILE_AVAILABILITY = "api/provider/profile/available"
let API_HISTORY_DETAILS = "api/provider/requests/history/details"
let API_UPCOMING_HISTORY_DETAILS = "api/provider/requests/upcoming/details"
let API_REQUEST_UPDATE_DESTINATION = "api/provider/request-update-destination"
let API_REQUEST_PROVIDER_UPDATE_SERVICE = "api/provider/update-service"
let API_REQUEST_CANCEL = "api/provider/cancel"
let API_STRIPE = "provider/stripe/account"
let API_STRIPE_CONNECT = "api/provider/stripe/account"

let kResetPassword = "Enter email to reset your password."
let WORKINPROGRESS = "Work in progress"
let kOk = "OK"
let CANCEL = "CANCEL"
let SUBMIT = "SUBMIT"
let cameraNotSupported = "Camera Is Not Supported"
let gallery = "Gallery"
let cancel = "Cancel"
let camera = "Camera"
let image = "image"
let blankEmailAddress = "Please enter email."
let inValidEmailAddress = "Please enter valid email."
let blankPassword = "Please enter password."
let inValidPassword = "Password must be more than 6 characters."
let blankFullName = "Please enter fullname."
let blankMobileNumber = "Please enter phone number."
let inValidMobileNumber = "Please enter valid phone number."
let passwordNotMatch = "Confirm password does'nt match."
let profileUpdate = "Profile update successfully."
let blankOtp = "Please enter OTP."
let wrongOtp = "Please enter the correct OTP"
let registerImageIsNull = "Please Select the register image."
let licenseImageFrontIsNull = "Please Select the front license image."
let licenseImageBackIsNull = "Please Select the back license image."
let InsuranceFormIsNull = "Please select the inssurance form."



