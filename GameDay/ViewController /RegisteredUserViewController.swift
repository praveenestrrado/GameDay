//
//  RegisteredUserViewController.swift
//  GameDay
//
//  Created by MAC on 04/01/21.
//

import UIKit
import AuthenticationServices
// import GoogleSignIn module
import GoogleSignIn
import MobileCoreServices
import Alamofire
import SwiftyJSON
import CoreLocation
import CryptoSwift
import FBSDKLoginKit
import ImageSlideshow
import Alamofire
import SwiftyJSON
class RegisteredUserViewController: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding,UITextFieldDelegate, UIGestureRecognizerDelegate, LoginButtonDelegate {
    
    @IBOutlet var imgValidationPassword: UIImageView!
    
    @IBOutlet var imgValidationName: UIImageView!
    let sharedData = SharedDefault()
    var presentWindow : UIWindow?


    
    @IBOutlet weak var btnSignUpNow: UIButton!
    @IBOutlet weak var btnLoginWithGoogle: UIButton!
//    @IBOutlet weak var btnLoginWithFacebook: UIButton!
    
    @IBOutlet weak var btnLoginWithFacebook: UIButton!
    
    @IBOutlet var btnFacebookLogin: FBLoginButton!
    // @IBOutlet var btnFacebookLogin: FBLoginButton!
    @IBOutlet weak var btnLoginWithAppleId: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnTextGo: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var imgPassword: UIImageView!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var imgGameDayName: UIImageView!
    @IBOutlet weak var txtGameDayName: UITextField!
    @IBOutlet weak var viewGameDayName: UIView!
    @IBOutlet weak var lblAppName: UILabel!
    @IBOutlet weak var lblSignin: UILabel!
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    var loginResponseModel:LoginResponseModel?
    var forgotPasswordResponseModel : ForgotPasswordResponseModel?

    var loginData: LoginData?

    
    var sSelectedDate:String?
    var sBookingID:String?
    var sPitchId:String?

    var iBookType:Int?
    var iDeviceToken:Int?
    var iNo_of_Weeks:Int?
    var iTotalAmount:Int?
    var sDuration:String?
    var sDurationId:String?
    var sPitchName:String?
    var sPitchAddress:String?
    var sStartTime:String?
    var sEndTime:String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        // 1
        
        presentWindow = UIApplication.shared.keyWindow
        UIView.hr_setToastThemeColor(color: UIColor.white)
        UIView.hr_setToastFontColor(color: self.hexStringToUIColor(hex: "#6fc13a"))
        UIView.hr_setToastFontName(fontName: "TTOctosquares-Medium")
        
        
//        if let token = AccessToken.current,
//                !token.isExpired {
//                // User is logged in, do work such as go to next view controller.
//
//            let token = token.tokenString
//            let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields":"email, name"], tokenString: token, version: nil, httpMethod: .get)
//            request.start(completionHandler: { connection, result, error in
//
//                print("login Results:","\(result)")
//            })
//
//
//
//            }
//        else
//        {
        
        
//        self.iDeviceToken = 8047 + 1

        
        
        self.btnFacebookLogin.imageView?.image = UIImage(named: "")
            self.btnFacebookLogin.delegate = self
            self.btnFacebookLogin.permissions = ["public_profile", "email"]
//        }
        // Disable swipe-to-pop gesture
                navigationController?.interactivePopGestureRecognizer?.delegate = self
                navigationController?.interactivePopGestureRecognizer?.isEnabled = false

                // Detect swipe gesture to load next entry
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipeNextEntry)))
        
        self.viewPassword.layer.borderWidth = 1.0
        self.viewPassword.layer.borderColor = UIColor.white.cgColor
        self.viewGameDayName.layer.borderWidth = 1.0
        self.viewGameDayName.layer.borderColor  = UIColor.white.cgColor
        // Do any additional setup after loading the view.
        btnTextGo.backgroundColor = hexStringToUIColor(hex: "#6FC13A")

        txtGameDayName.attributedPlaceholder = NSAttributedString(string: "GameDay Name",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Password",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        // Register notification to update screen after user successfully signed in
          NotificationCenter.default.addObserver(self,
                                                 selector: #selector(userDidSignInGoogle(_:)),
                                                 name: .signInGoogleCompleted,
                                                 object: nil)
        
//        GIDSignIn.sharedInstance()?.presentingViewController = self
//        updateScreen()

        
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        
        let token = result?.token?.tokenString
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields":"email, name"], tokenString: token, version: nil, httpMethod: .get)
        request.start(completionHandler: { connection, result, error in
            
            print("login Results:","\(result)")
            
            
             
            
            if result == nil
            {
                
            }
            else
            {
            var sDataDict = NSDictionary()
            
            sDataDict = result as! NSDictionary
            
            print(sDataDict.object(forKey: "name") ?? "")
            print(sDataDict.object(forKey: "id") ?? "")
            print(sDataDict.object(forKey: "email") ?? "")

            
            self.txtGameDayName.text = (sDataDict.object(forKey: "email") as! String)
            self.txtPassword.text = (sDataDict.object(forKey: "name") as! String)
                self.LoginSocial_Account_Service(social_Media: "facebook", loginId: sDataDict.object(forKey: "id") as! String, email: sDataDict.object(forKey: "email") as! String, fname: sDataDict.object(forKey: "name") as! String, lname: "")
            }
        })
        
  
        
        
        
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
        print("login Results:Logout")

        
    }
    @objc func swipeNextEntry(_ sender: UIPanGestureRecognizer) {
          print("[DEBUG] Pan Gesture Detected")

          if (sender.state == .ended) {
              let velocity = sender.velocity(in: self.view)

              if (velocity.x > 0) { // Coming from left
                self.navigationController?.popViewController(animated: true)

              }
          }
      }
    func getFBUserData()
        {

        if((AccessToken.current) != nil)
            {
            GraphRequest(graphPath: "me",
                         parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email , gender"]).start(
                            completionHandler: { (connection, result, error) -> Void in


                    if (error == nil)
                    {
                       print(result)
                        if result == nil
                        {
                            
                        }
                        else
                        {
                        var sDataDict = NSDictionary()
                        
                        sDataDict = result as! NSDictionary
                        
                        print(sDataDict.object(forKey: "name") ?? "")
                        print(sDataDict.object(forKey: "id") ?? "")
                        print(sDataDict.object(forKey: "email") ?? "")

                        
                        self.txtGameDayName.text = (sDataDict.object(forKey: "email") as! String)
                        self.txtPassword.text = (sDataDict.object(forKey: "name") as! String)
//                            self.LoginSocial_Account_Service(social_Media: "facebook", loginId: sDataDict.object(forKey: "id") as! String, email: sDataDict.object(forKey: "email") as! String, name: sDataDict.object(forKey: "first_name") as! String, lname: name,: sDataDict.object(forKey: "last_name") as! String)
                            
                            self.LoginSocial_Account_Service(social_Media: "facebook", loginId: sDataDict.object(forKey: "id") as! String, email: sDataDict.object(forKey: "email") as! String, fname: sDataDict.object(forKey: "first_name") as! String, lname: sDataDict.object(forKey: "last_name") as! String)
                        }
                    }
                })
            }
        }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK:- Button action
      @objc func signInButtonTapped(_ sender: UIButton) {
          GIDSignIn.sharedInstance()?.signIn()
      }

      @objc func signOutButtonTapped(_ sender: UIButton) {
          GIDSignIn.sharedInstance()?.signOut()
          
          // Update screen after user successfully signed out
          updateScreen()
      }

      // MARK:- Notification
      @objc private func userDidSignInGoogle(_ notification: Notification) {
          // Update screen after user successfully signed in
          updateScreen()
      }
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            return self.view.window!
     }

    @IBAction func ActionLetsGo(_ sender: Any)
    {
//        let next = self.storyboard?.instantiateViewController(withIdentifier: "PaymentFirstViewController") as! PaymentFirstViewController
//        next.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
//        self.present(next, animated: false, completion: nil)
//        
//
        self.view.endEditing(true)

        
        
        if Reachability.isConnectedToNetwork()
        {
       
       
         if txtGameDayName.text?.count == 0
        {
            self.viewGameDayName.layer.borderColor = UIColor.red.cgColor
            self.viewGameDayName.layer.borderWidth = 1.5
            self.imgValidationName.isHidden = false
//            self.showToast(message: "Please enter User name")
            self.presentWindow?.makeToast(message: "Please enter User name", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.


        }
           else if txtPassword.text?.count == 0
            {
                self.viewPassword.layer.borderColor = UIColor.red.cgColor
                self.viewPassword.layer.borderWidth = 1.5
                self.imgValidationPassword.isHidden = false
//                self.showToast(message: "Please enter password")
            self.presentWindow?.makeToast(message: "Please enter password", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

            }
        
        else
        {
            self.view.endEditing(true)

            self.LoginService()
        }
        }
        else
        {
//            self.showToast(message:Constants.connectivityErrorMsg)
            self.presentWindow?.makeToast(message: Constants.connectivityErrorMsg, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

        }
        
//        self.navigationController?.pushViewController(next, animated: false)
    }
    
    
    func ForgertPasswordAPI()
    {
     
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = ["email":self.txtGameDayName.text!
        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.ForgetPasswordURL
        print("loginURL",loginURL)
        
        AF.request(loginURL, method: .post, parameters: postDict, encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
            print("Response:***:",data.description)
            
            switch (data.result) {
            case .failure(let error) :
                self.view.activityStopAnimating()
               
                
                if error._code == NSURLErrorTimedOut {
//                    self.showToast(message: "Request timed out! Please try again!")
                    self.presentWindow?.makeToast(message: "Request timed out! Please try again!", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                }
                else if error._code == 4 {
//                    self.showToast(message: "Internal server error! Please try again!")
                    self.presentWindow?.makeToast(message: "Internal server error! Please try again!", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                }
                else if error._code == -1003 {
//                    self.showToast(message: "Server error! Please contact support!")
                    self.presentWindow?.makeToast(message: "Server error! Please contact support!", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                }
            case .success :
                do {
                    
                    let response = JSON(data.data!)
                    self.forgotPasswordResponseModel = ForgotPasswordResponseModel(response)
////
//                    self.filter_datas = self.filterResponseModel?.filterData?.filter_datas
//                    self.filter_masters = self.filterResponseModel?.filterData?.filter_masters
//                    self.durations = self.filter_masters?.durations
//                    self.pitch_sizes = self.filter_masters?.pitch_sizes
//                    self.pitch_turfs = self.filter_masters?.pitch_turfs
//                    self.pitch_types = self.filter_masters?.pitch_types
//                    self.user_details = self.filterResponseModel?.filterData?.user_details

                    
                    
                    //
                    let statusCode = Int((self.forgotPasswordResponseModel?.httpcode)!)
                    if statusCode == 200{
                        print("registerResponseModel ----- ",self.forgotPasswordResponseModel)
 
//
//                        print("Pitch list count:--->", self.pitch_list.count)
//                        print("Duration list count:--->", self.durations?.count ?? "0")
                        
                        
//                        self.showToast(message:(self.forgotPasswordResponseModel?.forgotPassword?.message)!)
                        self.presentWindow?.makeToast(message: (self.forgotPasswordResponseModel?.forgotPassword?.message)!, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                        
                    
                    }
                    if statusCode == 400{

//                        self.showToast(message:(self.forgotPasswordResponseModel?.message)!)
                        self.presentWindow?.makeToast(message: (self.forgotPasswordResponseModel?.message)!, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                    }
//
                    
                    self.view.activityStopAnimating()
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
    
    
    @IBAction func ActionForgotPassword(_ sender: Any) {
        if self.txtGameDayName.text!.count > 0
        {
            self.ForgertPasswordAPI()
        }
        else
        {
//            self.showToast(message: "Please enter your email id")
            self.presentWindow?.makeToast(message: "Please enter your email id", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

        }
    }
    @IBAction func ActionLoginWithFacebookID(_ sender: Any)
    {
        
        
        
        
        
        
        let fbLoginManager : LoginManager = LoginManager()
           
        
        fbLoginManager.logIn(permissions: [.publicProfile,.email], viewController: self, completion: {(result) in
//

                switch result {

                case .cancelled :
                print("User cancelled login process")
                break

                case .success(granted: let granted, declined: let declined, token: let token):
                    print("Access Token == ", token as Any)
                    print("granted == ", granted as Any)
                    print("declined == ", declined as Any)
                    self.getFBUserData()


                case .failed(let error):
                    print("User failed login process with error = ", error.localizedDescription)
                    break

                }
            })

        
        
        
//        // 1
//        let loginManager = LoginManager()
//
//        if let _ = AccessToken.current {
//            // Access token available -- user already logged in
//            // Perform log out
//
//            // 2
//            loginManager.logOut()
//
//        } else {
//            // Access token not available -- user already logged out
//            // Perform log in
//
//            // 3
////            loginManager.logIn(permissions: ["public_profile", "email", "password"], from: self) { [weak self] (result, error) in
////
////                // 4
////                // Check for error
////                guard error == nil else {
////                    // Error occurred
////                    print(error!.localizedDescription)
////                    return
////                }
////
////                // 5
////                // Check for cancel
////                guard let result = result, !result.isCancelled else {
////                    print("User cancelled login")
////                    return
////                }
////
////                // Successfully logged in
////                // 6
////
////                // 7
////                Profile.loadCurrentProfile { (profile, error) in
////
////
////
////
////                    print("Profile Name:", Profile.current?.name)
////                }
////            }
//
//
//
//
//            loginManager.logIn(permissions: [.publicProfile,.email], viewController: self, completion: {(result) in
//
//
//                switch result {
//
//                case .cancelled :
//                print("User cancelled login process")
//                break
//
//                case .success(granted: let granted, declined: let declined, token: let token):
//                    print("Access Token == ", token as Any)
//                    print("granted == ", granted as Any)
//                    print("declined == ", declined as Any)
//
//
//                case .failed(let error):
//                    print("User failed login process with error = ", error.localizedDescription)
//                    break
//
//                }
//            })
//
//
//
//        }
        
        
        
       
        
        
    }
    
    @IBAction func ActionLoginWithGoogleID(_ sender: Any)
    {
        
        
        
        GIDSignIn.sharedInstance().presentingViewController = self


        GIDSignIn.sharedInstance()?.signIn()
        
        //    GIDSignIn.sharedInstance()?.signOut()


    }
    @IBAction func ActionLoginWithAppleID(_ sender: Any)
    {
       
        if #available(iOS 13.0, *) {
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            
            controller.delegate = self
            controller.presentationContextProvider = self
            
            controller.performRequests()
        } else {
            // Fallback on earlier versions
        }
            

    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if #available(iOS 13.0, *) {
            switch authorization.credential {
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                let userIdentifier = appleIDCredential.user
                var fullname = appleIDCredential.fullName
                var email = appleIDCredential.email
                var user = appleIDCredential.user
                var realUser = appleIDCredential.realUserStatus

                self.txtGameDayName.text = email
                self.txtPassword.text = String(describing: fullname)
                let defaults = UserDefaults.standard
                defaults.set(userIdentifier, forKey: "userIdentifier1")
                print("User Id is \(userIdentifier) \n full Name is \(String(describing: fullname))  \n Email is \(String(describing: email))")
                var sFullName:String = String()
                var sLastName:String = String()
                
                sFullName = String(describing: fullname)

                if email == nil
                {
                    email = ""
                }
                else if   fullname == nil
                {
                    email = ""
                }

                
                if sFullName == "Optional()" || sFullName == "optional()"
                {
                    sFullName = email!
                }
                self.LoginSocial_Account_Service(social_Media: "apple", loginId: userIdentifier, email: email!, fname:sFullName, lname: sLastName)

                
                
                break
            default:
                break
            }
        } else {
            // Fallback on earlier versions
        }
    }

    
    @IBAction func ActionSignUpNew(_ sender: Any) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "RegitrationViewController") as! RegitrationViewController
        
        next.sSelectedDate = self.sSelectedDate
        next.sBookingID = self.sBookingID
        next.sPitchId = self.sPitchId
        next.iBookType = self.iBookType
        next.iNo_of_Weeks = self.iNo_of_Weeks
        next.sDuration = self.sDuration
        next.sDurationId = self.sDurationId
        next.sPitchName = self.sPitchName
        next.sPitchAddress = self.sPitchAddress
        next.sStartTime = self.sStartTime
        next.sEndTime = self.sEndTime
        next.iTotalAmount = self.iTotalAmount
        
        self.navigationController?.pushViewController(next, animated: false)
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    
    private func updateScreen() {
        
        if let user = GIDSignIn.sharedInstance()?.currentUser {
            // User signed in
            
            // Show greeting message
          print("Hello \(user.profile.givenName!)! ✌️")
            
            let userId = user.userID                  // For client-side use only!
              let idToken = user.authentication.idToken // Safe to send to the server
              let fullName = user.profile.name
              let givenName = user.profile.givenName
              let familyName = user.profile.familyName
              let email = user.profile.email
            self.txtGameDayName.text = user.profile.email
            self.txtPassword.text = user.profile.givenName
            
            self.LoginSocial_Account_Service(social_Media: "google", loginId: userId!, email: email!, fname: givenName!, lname: familyName!)
            
            
        } else {
            // User signed out
            
            // Show sign in message
            print("Hello Please sign in... 🙂")

        }
    }

    
    func LoginService(){
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        

        
        postDict = [
            "email":txtGameDayName.text!,
            "password":txtPassword.text!,
            "os":"ios",
            "device_token":"8047",


        ]
        
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.loginURL
        print("loginURL",loginURL)
        
        AF.request(loginURL, method: .post, parameters: postDict, encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
            print("Response:***:",data.description)
            
            switch (data.result) {
            case .failure(let error) :
                self.view.activityStopAnimating()
                
                
                if error._code == NSURLErrorTimedOut {
//                    self.showToast(message: "Request timed out! Please try again!")
                    self.presentWindow?.makeToast(message: "Request timed out! Please try again!", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                }
                else if error._code == 4 {
//                    self.showToast(message: "Internal server error! Please try again!")
                    self.presentWindow?.makeToast(message: "Internal server error! Please try again!", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                }
                else if error._code == -1003 {
//                    self.showToast(message: "Server error! Please contact support!")
                    self.presentWindow?.makeToast(message: "Server error! Please contact support!", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                }
            case .success :
                do {
                    let response = JSON(data.data!)
                    self.loginResponseModel = LoginResponseModel(response)
                    let statusCode = Int((self.loginResponseModel?.httpcode)!)
                    if statusCode == 200{
                        
//                        self.showToast(message: (self.loginResponseModel?.message)!)
                        self.presentWindow?.makeToast(message: (self.loginResponseModel?.message)!, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                           
//                            let next = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//                            self.navigationController?.pushViewController(next, animated: false)
                            
                            self.loginData = self.loginResponseModel?.loginData
                            self.sharedData.setAccessToken(token: (self.loginData?.access_token)!)
                            self.sharedData.setCountyName(token: (self.loginData?.users_details?.country)!)
                            self.sharedData.setEmail(token: (self.loginData?.users_details?.email)!)
                            self.sharedData.setfname(token: (self.loginData?.users_details?.fname)!)
                            self.sharedData.setisd_code(token: String((self.loginData?.users_details?.isd_code)!))
                            self.sharedData.setlname(token: (self.loginData?.users_details?.lname)!)
                            self.sharedData.setlocation(token: (self.loginData?.users_details?.location)!)
                            self.sharedData.setnotify(token: String((self.loginData?.users_details?.notify)!))
                            self.sharedData.setphone(token: String((self.loginData?.users_details?.phone)!))
                            self.sharedData.setpush_notify(token: String((self.loginData?.users_details?.push_notify)!))
                            self.sharedData.setstate(token: (self.loginData?.users_details?.state)!)
                            self.sharedData.setuser_id(token: String((self.loginData?.users_details?.user_id)!))

                            
                            
                            
                            
                            let next = self.storyboard?.instantiateViewController(withIdentifier: "PaymentFirstViewController") as! PaymentFirstViewController
                            next.sSelectedDate = self.sSelectedDate
                            next.sBookingID = self.sBookingID
                            next.sPitchId = self.sPitchId
                            next.iBookType = self.iBookType
                            next.iNo_of_Weeks = self.iNo_of_Weeks
                            next.sDuration = self.sDuration
                            next.sDurationId = self.sDurationId
                            next.sStartTime = self.sStartTime
                            next.sEndTime = self.sEndTime
                            next.iTotalAmount = self.iTotalAmount
                            next.sPitchName = self.sPitchName
                            next.sPitchAddress = self.sPitchAddress
                            self.navigationController?.pushViewController(next, animated: false)
                            
                        }
                    }
                    if statusCode == 400{
//                        self.showToast(message: (self.loginResponseModel?.message)!)
                        self.presentWindow?.makeToast(message: (self.loginResponseModel?.message)!, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                    }
                    self.view.activityStopAnimating()
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
    func LoginSocial_Account_Service(social_Media:String,loginId:String,email:String,fname:String,lname:String){
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        

        
        postDict = [
            "social_media":social_Media,
            "login_id":loginId,
            "email":email,
            "fname":fname,
            "lname":lname,
            "os":"ios",
            "device_token":loginId

        ]
        
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.SocialMediaURL
        print("loginURL",loginURL)
        
        AF.request(loginURL, method: .post, parameters: postDict, encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
            print("Response:***:",data.description)
            
            switch (data.result) {
            case .failure(let error) :
                self.view.activityStopAnimating()
                
                
                if error._code == NSURLErrorTimedOut {
//                    self.showToast(message: "Request timed out! Please try again!")
                    self.presentWindow?.makeToast(message: "Request timed out! Please try again!", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                }
                else if error._code == 4 {
//                    self.showToast(message: "Internal server error! Please try again!")
                    self.presentWindow?.makeToast(message: "Internal server error! Please try again!", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                }
                else if error._code == -1003 {
//                    self.showToast(message: "Server error! Please contact support!")
                    self.presentWindow?.makeToast(message: "Server error! Please contact support!", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                }
            case .success :
                do {
                    let response = JSON(data.data!)
                    self.loginResponseModel = LoginResponseModel(response)
                    let statusCode = Int((self.loginResponseModel?.httpcode)!)
                    if statusCode == 200{
                        
//                        self.showToast(message: (self.loginResponseModel?.message)!)
                        
                        self.presentWindow?.makeToast(message: (self.loginResponseModel?.message)!, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                           
//                            let next = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//                            self.navigationController?.pushViewController(next, animated: false)
                            
                            self.loginData = self.loginResponseModel?.loginData
                            self.sharedData.setAccessToken(token: (self.loginData?.access_token)!)
                            self.sharedData.setCountyName(token: (self.loginData?.users_details?.country)!)
                            self.sharedData.setEmail(token: (self.loginData?.users_details?.email)!)
                            self.sharedData.setfname(token: (self.loginData?.users_details?.fname)!)
                            self.sharedData.setisd_code(token: String((self.loginData?.users_details?.isd_code)!))
                            self.sharedData.setlname(token: (self.loginData?.users_details?.lname)!)
                            self.sharedData.setlocation(token: (self.loginData?.users_details?.location)!)
                            self.sharedData.setnotify(token: String((self.loginData?.users_details?.notify)!))
                            self.sharedData.setphone(token: String((self.loginData?.users_details?.phone)!))
                            self.sharedData.setpush_notify(token: String((self.loginData?.users_details?.push_notify)!))
                            self.sharedData.setstate(token: (self.loginData?.users_details?.state)!)
                            self.sharedData.setuser_id(token: String((self.loginData?.users_details?.user_id)!))

                            
                            let next = self.storyboard?.instantiateViewController(withIdentifier: "PaymentFirstViewController") as! PaymentFirstViewController
                            next.sSelectedDate = self.sSelectedDate
                            next.sBookingID = self.sBookingID
                            next.sPitchId = self.sPitchId
                            next.iBookType = self.iBookType
                            next.iNo_of_Weeks = self.iNo_of_Weeks
                            next.sDuration = self.sDuration
                            next.sDurationId = self.sDurationId
                            next.sStartTime = self.sStartTime
                            next.sEndTime = self.sEndTime
                            next.iTotalAmount = self.iTotalAmount
                            next.sPitchName = self.sPitchName
                            next.sPitchAddress = self.sPitchAddress
                            self.navigationController?.pushViewController(next, animated: false)
                            
                        }
                    }
                    if statusCode == 400{
//                        self.showToast(message: (self.loginResponseModel?.message)!)
                        self.presentWindow?.makeToast(message: (self.loginResponseModel?.message)!, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.


                    }
                    self.view.activityStopAnimating()
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
            if textField == txtPassword {
                print("You edit myTextField")
                self.viewPassword.layer.borderColor = UIColor.white.cgColor
                self.viewPassword.layer.borderWidth = 1.5
                self.imgValidationPassword.isHidden = true
            }
        else if textField == txtGameDayName {
            print("You edit myTextField")
            self.viewGameDayName.layer.borderColor = UIColor.white.cgColor
            self.viewGameDayName.layer.borderWidth = 1.5
            self.imgValidationName.isHidden = true
        }
        }
    
}
    
extension String {

    func splitString(regex pattern: String) -> [String] {

        guard let re = try? NSRegularExpression(pattern: pattern, options: [])
            else { return [] }

        let nsString = self as NSString // needed for range compatibility
        let stop = "<SomeStringThatYouDoNotExpectToOccurInSelf>"
        let modifiedString = re.stringByReplacingMatches(
            in: self,
            options: [],
            range: NSRange(location: 0, length: nsString.length),
            withTemplate: stop)
        return modifiedString.components(separatedBy: stop)
    }
}
