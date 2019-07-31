//
//  UploadDocumentVC.swift
//  Chambba
//
//  Created by Rohit Kumar on 01/03/19.
//  Copyright © 2019 Mayur chaudhary. All rights reserved.
//

import UIKit
import AccountKit

class UploadDocumentVC: UIViewController {
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var singUpBtn: UIButton!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var downloadSpinner: UIActivityIndicatorView!
    
    var picker = UIImagePickerController()
    var registerationImage = UIImage()
    var licenseImageFront = UIImage()
    var licenseImageBack = UIImage()
    var senderTagValue = 45
    let userObj = UserInfo()
   
    
    
    var email: String?
    var password: String?
    var fullName: String?
    var phoneNumebr: String?
    
    var urlLink: URL!
    var defaultSession: URLSession!
    var downloadTask: URLSessionDownloadTask!
    var insuranceUrl: URL?
    var fileName = ""
    var uploadDocData = Data()
    
    
    
    var accountKit: AKFAccountKit!
    var imageArray = [#imageLiteral(resourceName: "upload_Icons"),#imageLiteral(resourceName: "upload_Icons"),#imageLiteral(resourceName: "upload_Icons"),#imageLiteral(resourceName: "upload_Icons")]
    var placeholderArray = ["Upload Registration Certificate","Upload Driving Licence Front","Upload Driving Licence Back", "Upload Insurance"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: "backgroundSession")
        defaultSession = Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
        progress.setProgress(0.0, animated: false)
        // Do any additional setup after loading the view.
        customInit()
    }
    
    //MARK:- Helper Method
    func customInit(){
        tableView.aroundShadow()
        singUpBtn.shadowAtBottom(red: 255, green: 235, blue: 2)
        
        if accountKit == nil {
            accountKit = AKFAccountKit(responseType: .accessToken)
        }
    }
    

    @IBAction func commonButtonActiom(_ sender: UIButton) {
        
        self.view.endEditing(true)
        switch sender.tag {
        case 100:                   // Back Btn
            self.navigationController?.popViewController(animated: true)
            break
            
        case 101:                   // SignUp Btn
            if isAllFieldVerified() {
               loginWithPhone()
            }
            break
            
        case 102:                   // SignIn Btn
            break
            
        case 103:                   // Download Doc Btn
            startDownloading ()
            break
            
       
            
        case 0:                   // Upload Registeration Certificate Btn
            senderTagValue = sender.tag
            imagePickerMethod()
            break
            
        case 1:                   // Upload Driving License Btn
            senderTagValue = sender.tag
            imagePickerMethod()
            break
            
        case 2:                   // Upload Driving License Btn
            senderTagValue = sender.tag
            imagePickerMethod()
            break
        
        case 3:
            
            AlertController.alert(title: "Select Document", message: "Select the downloaded insurance form after fill it completely.", buttons: ["Cancel", "Ok"]) { (action, index) in
                
                if index == 1 {
                    let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.text", "com.apple.iwork.pages.pages", "public.data"], in: .import)
                    
                    documentPicker.delegate = self
                    self.present(documentPicker, animated: true, completion: nil)
                }
                
                if index == 0 {
                    
                }
                
            }
            
           
        break
            
        
        default:
            break
        }
    }
    
    func downloadDocument() {
        //http://dev2.xicom.us/chambba/public/asset/img/user/documents/sample.doc
        guard let url = URL(string: "https://www.tutorialspoint.com/swift/swift_tutorial.pdf") else { return }
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    
    func isAllFieldVerified() -> Bool{
        if !imageIsNullOrNot(imageName: registerationImage) {
            userObj.errorString = registerImageIsNull
        }else if !imageIsNullOrNot(imageName: licenseImageFront){
            userObj.errorString = licenseImageFrontIsNull
        }else if !imageIsNullOrNot(imageName: licenseImageBack){
            userObj.errorString = licenseImageBackIsNull
        }else if insuranceUrl == nil {
            userObj.errorString = InsuranceFormIsNull
        }else{
            userObj.errorString = ""
            return true
        }
        AlertController.alert(title: "", message: userObj.errorString, buttons: ["OK"]) { (UIAlertAction, index) in
        }
        tableView.reloadData()
        return false
    }
    
}

extension UploadDocumentVC: UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UploadDocumentCell", for: indexPath) as! UploadDocumentCell
        
        cell.buttonStaticText.titleLabel?.numberOfLines = 0
        cell.buttonStaticText.titleLabel?.lineBreakMode = .byWordWrapping
        cell.buttonStaticText.tag = indexPath.row
        
        print(placeholderArray[indexPath.row])
        cell.buttonStaticText.setTitle(placeholderArray[indexPath.row],for: .normal)
        
        print(imageIsNullOrNot(imageName: registerationImage))
        
        if indexPath.row == 0 {
             cell.documentImageView.contentMode = .scaleAspectFit
            cell.documentImageView.image = imageIsNullOrNot(imageName: registerationImage) ?  registerationImage : #imageLiteral(resourceName: "upload_Icons")
            if imageIsNullOrNot(imageName: registerationImage) {
                cell.documentImageView.layer.borderColor = UIColor.gray.cgColor
                cell.documentImageView.layer.borderWidth = 2
            }
        } else if indexPath.row == 1 {
             cell.documentImageView.contentMode = .scaleAspectFit
            cell.documentImageView.image = imageIsNullOrNot(imageName: licenseImageFront) ? licenseImageFront : #imageLiteral(resourceName: "upload_Icons")
            if imageIsNullOrNot(imageName: licenseImageFront) {
                cell.documentImageView.layer.borderColor = UIColor.gray.cgColor
                cell.documentImageView.layer.borderWidth = 2
            }
        } else if indexPath.row == 2 {
            cell.documentImageView.contentMode = .scaleAspectFit
            cell.documentImageView.image = imageIsNullOrNot(imageName: licenseImageBack) ? licenseImageBack : #imageLiteral(resourceName: "upload_Icons")
            if imageIsNullOrNot(imageName: licenseImageBack) {
                cell.documentImageView.layer.borderColor = UIColor.gray.cgColor
                cell.documentImageView.layer.borderWidth = 2
            }
        }
            
        else if indexPath.row == 3 {
            cell.documentImageView.image = #imageLiteral(resourceName: "upload_Icons")
            
            if fileName == "" {
                cell.buttonStaticText.setTitle("Upload Document", for: .normal)
                
            } else {
                cell.buttonStaticText.setTitle(fileName, for: .normal)
                
            }
            
            
            
        }

        return cell
    }
    
    func imageIsNullOrNot(imageName : UIImage)-> Bool {
        
        let size = CGSize(width: 0, height: 0)
        if (imageName.size.width == size.width)
        {
            return false
        }
        else
        {
            return true
        }
    }
}

extension UploadDocumentVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerMethod(){
        let alert = UIAlertController()
        alert.addAction(UIAlertAction(title: "Choose Camera", style: .default , handler:{ (UIAlertAction)in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
                self.picker.delegate = self
                self.picker.sourceType = UIImagePickerControllerSourceType.camera;
                self.picker.allowsEditing = true
                self.present(self.picker, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Choose from gallery", style: .default , handler:{ (UIAlertAction)in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: {
                })
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:{ (UIAlertAction)in
        }))
        self.present(alert, animated: true, completion: {
            
        })
    }
    
    //MARK: - Camera delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            if senderTagValue == 0 {
                registerationImage = image
            } else if senderTagValue == 1 {
                licenseImageFront = image
            } else if senderTagValue == 2 {
                licenseImageBack = image
            }
            
        } else {
        }
        self.dismiss(animated: true, completion: nil)
        self.tableView.reloadData()
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        senderTagValue = 45
        picker.dismiss(animated: true, completion: nil)
    }
}


//MARK:- Account Kit SetUp Method
extension UploadDocumentVC: AKFViewControllerDelegate {
    
    func prepareLoginViewController(loginViewController: AKFViewController) {
        loginViewController.delegate = self
        //UI Theming - Optional
        loginViewController.uiManager = AKFSkinManager.init(skinType: .translucent, primaryColor: RGBA(r: 253, g: 234, b: 64, a: 1.0), backgroundImage: nil, backgroundTint: .white, tintIntensity: 1.0)
        loginViewController.uiManager.theme!()?.buttonBackgroundColor = RGBA(r: 253, g: 234, b: 64, a: 1.0)
        loginViewController.uiManager.theme!()?.buttonTextColor = UIColor.black
    }
    
    func loginWithPhone(){
        let inputState = UUID().uuidString
        let vc = (accountKit?.viewControllerForPhoneLogin(with: nil, state: inputState))!
        vc.enableSendToFacebook = true
        self.prepareLoginViewController(loginViewController: vc)
        self.present(vc as UIViewController, animated: true, completion: nil)
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        print("did complete login with access token \(accessToken.tokenString) state \(String(describing: state))")
        self.accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
        accountKit.requestAccount {
            (account, error) -> Void in
            if let phoneNumber = account?.phoneNumber{
                self.userObj.phoneNumebr = phoneNumber.stringRepresentation()
                self.userObj.phoneNumberCountryCode = (account?.phoneNumber?.countryCode)!;
            }
            self.signUpAPi()
        }
        accountKit.logOut()
        
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didFailWithError error: Error!) {
        // ... implement appropriate error handling ...
        print("\(String(describing: viewController)) did fail with error: \(error.localizedDescription)")
    }
    
    func viewControllerDidCancel(_ viewController: (UIViewController & AKFViewController)!) {
        // ... handle user cancellation of the login process ...
    }
}

//MARK: API Implementation
extension UploadDocumentVC {
    
    func signUpAPi() {
        let uDID = UUID().uuidString
        guard let fullName = fullName else { return }
        guard let email = email else { return }
       // guard let phoneNumebr = phoneNumebr else { return }
        guard let password = password else { return }
        
            let paramDic = [
                            "first_name": fullName,
                            "email" : email,
                            "mobile": self.userObj.phoneNumebr,
                            "password": password,
                            "device_id": uDID,
                            "device_type": DEVICE_TYPE,
                            "device_token": UserDefaults.standard.value(forKey: DEVICE_TOKEN)!,
                            ] as Dictionary<String, Any>
    
        let selectedDocument = [registerationImage, licenseImageFront, licenseImageBack]
        let imageUplaodedKeys = ["registration_proof","front_driving_licence","back_driving_license", "insurance_form"]
        print("Parameter PR",paramDic)
        
        
        
        ServiceHelper.sharedInstance.createRequestToUploadMultipleDataWithString(additionalParams: paramDic , imageList: selectedDocument, imageUploadKeys: imageUplaodedKeys, uploadDocData: uploadDocData, apiName: API_PROVIDER_REGISTER) { (response, error) in
            
            if error != nil {
                AlertController.alert(title: appName, message: (error?.description)!)
                return
            }
            if (response != nil) {
                if let result = response!["email"] as? [String] {
                    if result.count > 0 {
                        if result[0] == "The email has already been taken." {
                            AlertController.alert(title: appName, message: "The email has already been taken.")
                        }
                    }else {
                        self.loginAPI()
                    }
                }else{
                    self.loginAPI()
                }
                
            }else{
                AlertController.alert(title: appName, message: "Something went wrong.")
            }
        }
        
    }
    
    func loginAPI() {
        
        let uDID = UUID().uuidString
        let paramDic = ["email" :email,
                        "password": password,
                        "device_token": UserDefaults.standard.value(forKey: DEVICE_TOKEN),
                        "device_id": uDID,
                        "device_type": DEVICE_TYPE,
                        "client_id":CLIENT_ID,
                        "client_secret":CLIENT_SECRET] as Dictionary<String, AnyObject>
        
        
        print("loging in", paramDic)
        
        ServiceHelper.sharedInstance.createPostRequest(isShowHud: true, params: paramDic, apiName: API_Login) { (response, error) in
            if error != nil {
                AlertController.alert(title: appName, message: (error?.description)!)
                return
            }
            if (response != nil) {
                
                let result = response as! Dictionary<String, AnyObject>
                let message = result.validatedValue("error", expected: "" as AnyObject) as! String
                if message == "The email address or password you entered is incorrect."{
                    AlertController.alert(title: appName, message: message)
                } else {
                    
                    
                   
                    let firstName = result.validatedValue("first_name", expected: "" as AnyObject) as! String
                    let avatar = result.validatedValue("avatar", expected: "" as AnyObject) as! String
                    let status = result.validatedValue("status", expected: "" as AnyObject) as! String
                    let currency = result.validatedValue("currency", expected: "" as AnyObject) as! String
                    let socialID = result.validatedValue("social_unique_id", expected: "" as AnyObject) as! String
                    let lastName = result.validatedValue("last_name", expected: "" as AnyObject) as! String
                    
                    let tokenValue = result.validatedValue("token_type", expected: "" as AnyObject) as! String
                    let accessToken = result.validatedValue("access_token", expected: "" as AnyObject) as! String
                    let refreshToken = result.validatedValue("refresh_token", expected: "" as AnyObject) as! String
                    
                    /*
                     let tokenValue = result.validatedValue("token_type", expected: "" as AnyObject) as! String
                     let accessToken = result.validatedValue("access_token", expected: "" as AnyObject) as! String
                     let refreshToken = result.validatedValue("refresh_token", expected: "" as AnyObject) as! String
                     UserDefaults.standard.set(tokenValue , forKey: TOKEN_TYPE)
                     UserDefaults.standard.set(accessToken, forKey: ACCESS_TOKEN)
                     UserDefaults.standard.set(refreshToken, forKey: REFRESH_TOKEN)
                     UserDefaults.standard.set(true, forKey: "isLoggedin")
                     UserDefaults.standard.synchronize()
                     */
                    
                    UserDefaults.standard.set(accessToken, forKey: ACCESS_TOKEN)
                    UserDefaults.standard.set(tokenValue , forKey: TOKEN_TYPE)
                    UserDefaults.standard.set(refreshToken, forKey: REFRESH_TOKEN)
                    UserDefaults.standard.set(firstName, forKey: "fullName")
                    UserDefaults.standard.set(avatar, forKey: "avatar")
                    UserDefaults.standard.set(status, forKey: "status")
                    UserDefaults.standard.set(currency, forKey: "currency")
                    UserDefaults.standard.set(socialID, forKey: "socialID")
                    UserDefaults.standard.set(lastName, forKey: "lastName")
                    UserDefaults.standard.set(true, forKey: "isLoggedin")
                    self.navigationController?.pushViewController(APPDELEGATE.sideMenuController, animated: true)
                    UserDefaults.standard.synchronize()
                    
                }
            }else{
                AlertController.alert(title: appName, message: "Something went wrong.")
            }
        }
    }
    
        /*
    func getProfileApi(){
        
        let uDID = UUID().uuidString
        let params = [
            "device_token" : UserDefaults.standard.value(forKey: DEVICE_TOKEN),
            "device_id" : uDID,
            "device_type" : DEVICE_TYPE,
            ]
        
        
        ServiceHelper.sharedInstance.createGetRequest(isShowHud: true, params: params as [String : AnyObject], apiName: API_GetProfile) { (response, error) in
            let result = response as! Dictionary<String, AnyObject>
            if error != nil {
                AlertController.alert(title: appName, message: (error?.description)!)
                return
            }
            if (response != nil) {
                debugPrint(response ?? "No Value")
                let fullName = result.validatedValue("first_name", expected: "" as AnyObject) as! String
                UserDefaults.standard.set(fullName, forKey: "fullName")
                
                let email = result.validatedValue("email", expected: "" as AnyObject) as! String
                UserDefaults.standard.set(email, forKey: "email")
                
                let mobile = result.validatedValue("mobile", expected: "" as AnyObject) as! String
                UserDefaults.standard.set(mobile, forKey: "mobile")
                
                UserDefaults.standard.synchronize()
                
                //I think there is no need of the NotificationCenter Here.
                let nameDict:[String: String] = ["name": fullName]
                NotificationCenter.default.post(name: Notification.Name("nameSetUp"), object: nil,userInfo: nameDict)
                self.navigationController?.pushViewController(APPDELEGATE.sideMenuController, animated: true)
                
            }else{
                AlertController.alert(title: appName, message: "Something went wrong.")
            }
        }*/
        
    }



extension UploadDocumentVC: URLSessionDownloadDelegate,UIDocumentInteractionControllerDelegate {
    
    func startDownloading () {
        downloadSpinner.isHidden = false
        let url = URL(string: "https://www.tutorialspoint.com/swift/swift_tutorial.pdf")!
        downloadTask = defaultSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    // MARK:- URLSessionDownloadDelegate
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        print(downloadTask)
        print("File download succesfully")
        downloadSpinner.isHidden = true
        
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectoryPath:String = path[0]
        let fileManager = FileManager()
        let destinationURLForFile = URL(fileURLWithPath: documentDirectoryPath.appendingFormat("/file.pdf"))
        
        if fileManager.fileExists(atPath: destinationURLForFile.path){
            showFileWithPath(path: destinationURLForFile.path)
            print(destinationURLForFile.path)
        }
        else{
            do {
                try fileManager.moveItem(at: location, to: destinationURLForFile)
                // show file
                showFileWithPath(path: destinationURLForFile.path)
            }catch{
                print("An error occurred while moving file to destination url")
            }
        }
        
        
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        progress.setProgress(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite), animated: true)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        downloadTask = nil
        progress.setProgress(0.0, animated: true)
        if (error != nil) {
            print("didCompleteWithError \(error?.localizedDescription ?? "no value")")
        }
        else {
            print("The task finished successfully")
        }
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController
    {
        return self
    }
    
    func showFileWithPath(path: String){
        let isFileFound:Bool? = FileManager.default.fileExists(atPath: path)
        if isFileFound == true{
            let viewer = UIDocumentInteractionController(url: URL(fileURLWithPath: path))
            viewer.delegate = self
            viewer.presentPreview(animated: true)
        }
        
    }
}

extension UploadDocumentVC: UIDocumentPickerDelegate{
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        let cico = url as URL
        print(cico)
        print(url)
        insuranceUrl = url
        fileName = url.lastPathComponent
        
        DispatchQueue.global(qos: .background).async {
            do
            {
                self.uploadDocData  = try Data.init(contentsOf: self.insuranceUrl!)
            }
            catch {
                // error
            }
        }
        self.tableView.reloadData()
        print(url.lastPathComponent)
        print(url.pathExtension)
        
    }
}

