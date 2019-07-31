
import Foundation
import Alamofire
//: header

let headers = [
    "Accept-Language" : "en",
    "q":"1",
    "Authorization" : "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjMzLCJpc3MiOiJodHRwOi8vMTQuMTQxLjE3NS4xMDkvY2hhbWJiYS9hcGkvcHJvdmlkZXIvb2F1dGgvdG9rZW4iLCJpYXQiOjE1NTI1NTc5MTUsImV4cCI6MTU1MjkxNzkxNSwibmJmIjoxNTUyNTU3OTE1LCJqdGkiOiJWYThxODJlVXFTU2gwa08yIn0.Q84aeRcHAweVHCU2r3-tyipUG0jnBEY_ilj54arVvns",
    "User-Agent" : "Provider/1.3 (iPhone; iOS 12.0; Scale/3.00)",
    "X-Requested-With" : "XMLHttpRequest"
]

final class ServiceHelper {
    
//       let baseURL =  "http://dev1.xicom.us/kawafilapp/product/"
    
    // Specifying the Headers we need
    class var sharedInstance: ServiceHelper {
        
        struct Static {
            static let instance = ServiceHelper()
        }
        return Static.instance
    }
    
    func setMyHeader() -> [String : String] {
        
        var accessTokenValue = ""
        var tokenValue = ""
        if let accessToken = UserDefaults.standard.value(forKey: ACCESS_TOKEN){
            accessTokenValue = accessToken as! String
        }
        if let tokenvalue = UserDefaults.standard.value(forKey: TOKEN_TYPE){
            tokenValue = tokenvalue as! String
        }
        let fullTokenValue = tokenValue + " " + accessTokenValue
        
        let headers = [
           // "Accept-Language" : "en",
           // "q":"1",
            "Authorization" : "Bearer " +  fullTokenValue,
           // "User-Agent" : "Provider/1.3 (iPhone; iOS 12.0; Scale/3.00)",
            "X-Requested-With" : "XMLHttpRequest"
        ]
        
        return headers
    }
    
    func setHeaders(_ apiName : String) -> [String : String]
    {
        var header = [String : String]()
        header["X-Requested-With"] = "XMLHttpRequest"
        var accessTokenValue = ""
        var tokenValue = ""
        if let accessToken = UserDefaults.standard.value(forKey: ACCESS_TOKEN){
            accessTokenValue = accessToken as! String
        }
        if let tokenvalue = UserDefaults.standard.value(forKey: TOKEN_TYPE){
            tokenValue = tokenvalue as! String
        }
        let fullTokenValue = tokenValue + " " + accessTokenValue
        
        if accessTokenValue.count != 0 {
            header["Authorization"] = fullTokenValue
        }
        
        return header
    }
    
    
    
    
    //Create Get and send request
    func createGetRequest(isShowHud: Bool, params: [String : AnyObject]!,apiName : String, completion: @escaping (_ response: AnyObject?, _ error: NSError?) -> Void) {
        
        if !APPDELEGATE.checkReachablility() {
            completion(nil,NSError.init(domain: "Please check your internet connection!", code: 000, userInfo: nil))
            return
        }
        if isShowHud {
            showHud()
        }
        let url = BASE_URL + apiName
        
        
        let parameterDict = params as Dictionary
        print( "\n\n Request URL  >>>>>>\(url)")
        print( "\n\n Request Parameters >>>>>>\n\(parameterDict)")
        
        let header : [String : String] = self.setHeaders(apiName)
        logInfo(message: "\n\n HEADER IN API >>>>>>>>>>>>\(header)")
        logInfo(message: "\n\n MY HEADER IN API >>>>>>>>>>>>\( setMyHeader())")
      
        
        
        Alamofire.request(URL.init(string: url)!, method: HTTPMethod.get, parameters: parameterDict, encoding: URLEncoding.default, headers: setMyHeader()).validate().responseJSON { response in
            switch response.result {
            case .success(_):
                print( "\nsuccess:\n Response From Server >>>>>>\n\(response)")
                RappleActivityIndicatorView.stopAnimation()
                completion(response.result.value as AnyObject?, nil)
            case .failure(_):
                print( "\nfailure:\n failure Response From Server >>>>>>\n\(String(describing: response.result.error))")
                RappleActivityIndicatorView.stopAnimation()
                completion(nil, response.result.error as NSError?)
            }
        }
    }
    
    
    //Create Post and send request
    func createPostRequestWithUserId(isShowHud: Bool, params: [String : AnyObject]!,apiName : String, completion: @escaping (_ response: AnyObject?, _ error: NSError?) -> Void)
    {
        if !APPDELEGATE.checkReachablility() {
            completion(nil,NSError.init(domain: "Please check your internet connection!", code: 000, userInfo: nil))
            return
        }
        if isShowHud {
            showHud()
        }
        
        let url = BASE_URL + apiName
        let parameterDict = params as NSDictionary
        logInfo(message: "\n\n Request URL  >>>>>>\(url)")
        logInfo(message: "\n\n Request Parameters >>>>>>\n\(parameterDict)")
        
        let header : [String : String] = self.setHeaders(apiName)
        logInfo(message: "\n\n HEADER IN API >>>>>>>>>>>>\(header)")
        logInfo(message: "\n\n MY HEADER IN API >>>>>>>>>>>>\( setMyHeader())")
        
        Alamofire.request(URL.init(string: url)!, method: HTTPMethod.post, parameters: parameterDict as? Parameters, encoding: JSONEncoding.default, headers: setMyHeader()).responseJSON { response in
            switch response.result {
            case .success(_):
                logInfo(message: "\nsuccess:\n Response From Server >>>>>>\n\(response)")
                RappleActivityIndicatorView.stopAnimation()
                if response.response?.statusCode == 200 {
                    if let jsonData = response.result.value as? NSDictionary {
                        let status = jsonData.value(forKey: "status") as? NSNumber
                        if (status == 203)
                        {
                            let message = jsonData.value(forKey: "message") as! String
                            AlertController.alert(message: message)
                           // APPDELEGATE.setLogOutController()
                        }else {
                            completion(response.result.value as AnyObject?, nil)
                        }
                    }else {
                        completion(nil, response.result.error as NSError?)
                    }
                }else {
                    completion(nil, response.result.error as NSError?)
                }
            case .failure(_):
                logInfo(message: "\nfailure:\n failure Response From Server >>>>>>\n\(String(describing: response.result.error))")
                RappleActivityIndicatorView.stopAnimation()
                completion(nil, response.result.error as NSError?)
            }
        }
    }
    
    func createPostRequest(isShowHud: Bool, params: [String : AnyObject]!,apiName : String, completion: @escaping (_ response: AnyObject?, _ error: NSError?) -> Void)
    {
        if !APPDELEGATE.checkReachablility() {
            completion(nil,NSError.init(domain: "Please check your internet connection!", code: 000, userInfo: nil))
            return
        }
        if isShowHud {
            showHud()
        }
        
        let url = BASE_URL + apiName
        let parameterDict = params as NSDictionary
        logInfo(message: "\n\n Request URL  >>>>>>\(url)")
        logInfo(message: "\n\n Request Parameters >>>>>>\n\(parameterDict)")

        let header : [String : String] = self.setHeaders(apiName)
        logInfo(message: "\n\n HEADER IN API >>>>>>>>>>>>\(header)")
        logInfo(message: "\n\n MY HEADER IN API >>>>>>>>>>>>\( setMyHeader())")
        
        Alamofire.request(URL.init(string: url)!, method: HTTPMethod.post, parameters: parameterDict as? Parameters, encoding: JSONEncoding.default, headers: setMyHeader()).responseJSON { response in
            switch response.result {
            case .success(_):
                logInfo(message: "\nsuccess:\n Response From Server >>>>>>\n\(response)")
                RappleActivityIndicatorView.stopAnimation()
                completion(response.result.value as AnyObject?, nil)
            case .failure(_):
                logInfo(message: "\nfailure:\n failure Response From Server >>>>>>\n\(String(describing: response.result.error))")
                RappleActivityIndicatorView.stopAnimation()
                completion(nil, response.result.error as NSError?)
            }
        }
    }
    
    
    func createDeleteRequest(isShowHud: Bool, params: [String : AnyObject]!,apiName : String, completion: @escaping (_ response: AnyObject?, _ error: NSError?) -> Void)
    {
        if !APPDELEGATE.checkReachablility() {
            completion(nil,NSError.init(domain: "Please check your internet connection!", code: 000, userInfo: nil))
            return
        }
        if isShowHud {
            showHud()
        }
        
        let url = BASE_URL + apiName
        let parameterDict = params as NSDictionary
        logInfo(message: "\n\n Request URL  >>>>>>\(url)")
        logInfo(message: "\n\n Request Parameters >>>>>>\n\(parameterDict)")
        
        let header : [String : String] = self.setHeaders(apiName)
        logInfo(message: "\n\n HEADER IN API >>>>>>>>>>>>\(header)")
        logInfo(message: "\n\n MY HEADER IN API >>>>>>>>>>>>\( setMyHeader())")
        
        Alamofire.request(URL.init(string: url)!, method: HTTPMethod.delete, parameters: parameterDict as? Parameters, encoding: JSONEncoding.default, headers: setMyHeader()).responseJSON { response in
            switch response.result {
            case .success(_):
                logInfo(message: "\nsuccess:\n Response From Server >>>>>>\n\(response)")
                RappleActivityIndicatorView.stopAnimation()
                completion(response.result.value as AnyObject?, nil)
            case .failure(_):
                logInfo(message: "\nfailure:\n failure Response From Server >>>>>>\n\(String(describing: response.result.error))")
                RappleActivityIndicatorView.stopAnimation()
                completion(nil, response.result.error as NSError?)
            }
        }
    }
    
    
    func createPatchRequest(isShowHud: Bool, params: [String : AnyObject]!,apiName : String, completion: @escaping (_ response: AnyObject?, _ error: NSError?) -> Void)
    {
        if !APPDELEGATE.checkReachablility() {
            completion(nil,NSError.init(domain: "Please check your internet connection!", code: 000, userInfo: nil))
            return
        }
        if isShowHud {
            showHud()
        }
        
        let url = BASE_URL + apiName
        let parameterDict = params as NSDictionary
        logInfo(message: "\n\n Request URL  >>>>>>\(url)")
        logInfo(message: "\n\n Request Parameters >>>>>>\n\(parameterDict)")
        
        let header : [String : String] = self.setHeaders(apiName)
        logInfo(message: "\n\n HEADER IN API >>>>>>>>>>>>\(header)")
        logInfo(message: "\n\n MY HEADER IN API >>>>>>>>>>>>\( setMyHeader())")
        
        Alamofire.request(URL.init(string: url)!, method: HTTPMethod.patch, parameters: parameterDict as? Parameters, encoding: JSONEncoding.default, headers: setMyHeader()).responseJSON { response in
            switch response.result {
            case .success(_):
                logInfo(message: "\nsuccess:\n Response From Server >>>>>>\n\(response)")
                RappleActivityIndicatorView.stopAnimation()
                completion(response.result.value as AnyObject?, nil)
            case .failure(_):
                logInfo(message: "\nfailure:\n failure Response From Server >>>>>>\n\(String(describing: response.result.error))")
                RappleActivityIndicatorView.stopAnimation()
                completion(nil, response.result.error as NSError?)
            }
        }
    }
    

    func createRequestToUploadDataWithString(additionalParams : Dictionary<String,Any>,dataContent : Data?,strName : String,strFileName : String,strType : String ,apiName : String,completion: @escaping (_ response: AnyObject?, _ error: NSError?) -> Void) {
        if !APPDELEGATE.checkReachablility() {
            completion(nil,NSError.init(domain: "Please check your internet connection!", code: 000, userInfo: nil))
            return
        }
        self.showHud()
        let url = BASE_URL + apiName
        logInfo(message: "\n\n Request URL  >>>>>>\(url)")
        
        let parameterDict = additionalParams as NSDictionary
        logInfo(message: "\n\n Request Parameters >>>>>>\n\(parameterDict)")
        
        let header : [String : String] = self.setHeaders(apiName)
        logInfo(message: "\n\n HEADER IN API >>>>>>>>>>>>\(header)")
        logInfo(message: "\n\n MY HEADER IN API >>>>>>>>>>>>\( setMyHeader())")
       // header = ["Content-Type" : "multipart/form-data"]
        
        let URL = try! URLRequest(url: url, method: .post, headers: setMyHeader())
        
        Alamofire.upload(multipartFormData: { (multipartData) in
            for (key,value) in additionalParams {
                multipartData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            if dataContent != nil {
                multipartData.append(dataContent!, withName:strName, fileName: strFileName, mimeType: strType)
            }
        }, with: URL) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    RappleActivityIndicatorView.stopAnimation()
                    if response.response?.statusCode == 200 {
                        if let jsonData = response.result.value as? NSDictionary {
                            let status = jsonData.value(forKey: "status") as? NSNumber
                            if (status == 203)
                            {
                                let message = jsonData.value(forKey: "message") as! String
                                AlertController.alert(message: message)
                               // APPDELEGATE.setLogOutController()
                            }else {
                                completion(response.result.value as AnyObject?, nil)
                            }
                        }else {
                            completion(nil, response.result.error as NSError?)
                        }
                    }else {
                        completion(nil, response.result.error as NSError?)
                    }
                }
                break
                
            case .failure(let encodingError):
                RappleActivityIndicatorView.stopAnimation()
                RappleActivityIndicatorView.stopAnimation(completionIndicator: .none, completionLabel: "", completionTimeout: 1.0)
                completion(nil, encodingError as NSError?)
                break
            }
        }
    }
    
    func createRequestToUploadMultipleDataWithString(additionalParams : Dictionary<String,Any>,
                                                     imageList: [UIImage],
                                                     imageUploadKeys: [String],
                                                     uploadDocData: Data?,
                                                     apiName : String,
                                                     completion: @escaping (_ response: AnyObject?, _ error: NSError?) -> Void) {
        if !APPDELEGATE.checkReachablility() {
            completion(nil,NSError.init(domain: "Please check your internet connection!", code: 000, userInfo: nil))
            return
        }
        self.showHud()
        let url = BASE_URL + apiName
        print( "\n\n Request URL  >>>>>>\(url)")
        let header : [String : String] = self.setHeaders(apiName)
        logInfo(message: "\n\n HEADER IN API >>>>>>>>>>>>\(header)")
        logInfo(message: "\n\n MY HEADER IN API >>>>>>>>>>>>\( setMyHeader())")
        //header = ["Content-Type" : "multipart/form-data"]
        
        let URL = try! URLRequest(url: url, method: .post, headers: setMyHeader())
        
        Alamofire.upload(multipartFormData: { (multipartData) in
            for (key,value) in additionalParams {
                multipartData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            
            if imageList.count > 0{
                for index in 0...imageList.count-1{
                    let imageData = UIImageJPEGRepresentation(imageList[index], 0.5)!
                    multipartData.append(imageData, withName: imageUploadKeys[index], fileName: "image\(index+1).jpg", mimeType: "image/jpeg")
                }
            }
            
            
            print("Data Doc",uploadDocData!, imageUploadKeys[3])
            if let data = uploadDocData {
                print(data)
                let uDID = UUID().uuidString
                multipartData.append(data, withName: imageUploadKeys[3], fileName: "\(uDID).doc", mimeType: "application/msword")
            }
            
        }, with: URL) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Success ------ \(response)")
                    RappleActivityIndicatorView.stopAnimation()
                    if response.response?.statusCode == 200 {
                        if let jsonData = response.result.value as? NSDictionary {
                            let status = jsonData.value(forKey: "status") as? NSNumber
                            if (status == 203)
                            {
                                let message = jsonData.value(forKey: "message") as! String
                                AlertController.alert(message: message)
                              //  APPDELEGATE.setLogOutController()
                            }else {
                                completion(response.result.value as AnyObject?, nil)
                            }
                        }else {
                            completion(nil, response.result.error as NSError?)
                        }
                    }else {
                        completion(nil, response.result.error as NSError?)
                    }
                }
                break
                
            case .failure(let encodingError):
                print("Error ------- \(encodingError)")
                RappleActivityIndicatorView.stopAnimation()
                RappleActivityIndicatorView.stopAnimation(completionIndicator: .none, completionLabel: "", completionTimeout: 1.0)
                completion(nil, encodingError as NSError?)
                break
            }
        }
    }
    
    func showHud() {
        let attribute = RappleActivityIndicatorView.attribute(style: RappleStyleCircle, tintColor: .white, screenBG: nil, progressBG: .black, progressBarBG: .lightGray, progreeBarFill: .yellow)
        RappleActivityIndicatorView.startAnimating(attributes: attribute)
    }
}
