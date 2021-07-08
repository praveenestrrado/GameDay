//
//  RegitrationViewController.swift
//  GameDay
//
//  Created by MAC on 09/03/21.
//

import UIKit
import iOSDropDown
import SwiftyJSON
import Alamofire
import CoreLocation

class RegitrationViewController: UIViewController,UITextFieldDelegate, CLLocationManagerDelegate {
    
    var registerResponseModel: RegistrationResponseModel?
    var presentWindow : UIWindow?

    @IBOutlet var btnCPword: UIButton!
    @IBOutlet var btnPWord: UIButton!
    @IBOutlet var lblConformPasswordErrorMessages: UILabel!
    @IBOutlet var lblPasswordErrorMessages: UILabel!
    @IBOutlet var lblEmailErrorMessages: UILabel!
    @IBOutlet var lblMobileNumberErrorMessage: UILabel!
    @IBOutlet var lblLastNameErrorMessage: UILabel!
    @IBOutlet var lblFirstNameErrorMsg: UILabel!
    @IBOutlet var imgValidationConfirmPassword: UIImageView!
    @IBOutlet var imgValidationMobileNumber: UIImageView!
    @IBOutlet var imgValidationFirstNamee: UIImageView!
    @IBOutlet var imgValidationLastName: UIImageView!
    @IBOutlet var imgValidationemail: UIImageView!
    @IBOutlet var imgValidationPassword: UIImageView!
    @IBOutlet weak var txtcode: DropDown!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var viewFirstName: UIView!
    @IBOutlet weak var viewLastName: UIView!
    @IBOutlet weak var viewEmail: UIView!
    var itemsNames = ["+971","+973","+966"]
    var itemsCode = ["+971","+973","+966"]
    var sCountryCode:String!
    var locManager = CLLocationManager()
    let locationManager = CLLocationManager()
    var iconClick = true
    var iconClick1 = true

    var currentLocation: CLLocation!
    @IBOutlet weak var txtConformPassword: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var viewConformPassword: UIView!
    @IBOutlet weak var viewMobileNumber: UIView!
    
    var sCurrentLattitude = Double()
    var sCurrentLongitude = Double()
    
    
    
    var sSelectedDate:String?
    var sBookingID:String?
    var sPitchId:String?

    var iBookType:Int?
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

        // Do any additional setup after loading the view.
        self.locManager.requestWhenInUseAuthorization()
        if(CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        presentWindow = UIApplication.shared.keyWindow
        UIView.hr_setToastThemeColor(color: UIColor.white)
        UIView.hr_setToastFontColor(color: self.hexStringToUIColor(hex: "#6fc13a"))
        UIView.hr_setToastFontName(fontName: "TTOctosquares-Medium")
        
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
                    CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
                    guard let currentLocation = locManager.location else {
                        return
                    }
                    print(currentLocation.coordinate.latitude)
            self.sCurrentLattitude = currentLocation.coordinate.latitude
            self.sCurrentLongitude = currentLocation.coordinate.longitude
                    print(currentLocation.coordinate.longitude)
                }
        
        txtcode.textAlignment = .center
        txtcode.placeholder = "Code"
        txtcode.checkMarkEnabled = false
        txtcode.optionArray = self.itemsNames

        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelNumberPad)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneWithNumberPad))]
        numberToolbar.sizeToFit()
        txtMobileNumber.inputAccessoryView = numberToolbar
     

        self.txtcode.didSelect{(selectedText , index ,id) in
            print("selectedText ----- ",selectedText)
            
            self.txtcode.text = selectedText
            
            self.sCountryCode = self.itemsCode[index]
            
            print("Selected Country code:",self.sCountryCode as Any)
            
        }
        
        viewFirstName.layer.borderWidth = 1
        txtFirstName.attributedPlaceholder = NSAttributedString(string: "First Name",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        viewFirstName.layer.borderColor = UIColor.lightGray.cgColor
        
   
        
        
        viewConformPassword.layer.borderWidth = 1
        txtConformPassword.attributedPlaceholder = NSAttributedString(string: "Confirm Password",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        viewConformPassword.layer.borderColor = UIColor.lightGray.cgColor
        
   
        
        
        viewLastName.layer.borderWidth = 1
        txtLastName.attributedPlaceholder = NSAttributedString(string: "Last Name",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        viewLastName.layer.borderColor = UIColor.lightGray.cgColor
        
        viewEmail.layer.borderWidth = 1
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        viewEmail.layer.borderColor = UIColor.lightGray.cgColor
        
        
        viewMobileNumber.layer.borderWidth = 1
        txtcode.attributedPlaceholder = NSAttributedString(string: "Code",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        txtMobileNumber.attributedPlaceholder = NSAttributedString(string: "Mobile Number",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        viewMobileNumber.layer.borderColor = UIColor.lightGray.cgColor
        
        
        
        
      
        
        
        viewPassword.layer.borderWidth = 1
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        viewPassword.layer.borderColor = UIColor.lightGray.cgColor
        
        
        txtFirstName.inputAccessoryView = numberToolbar
        txtLastName.inputAccessoryView = numberToolbar
        txtEmail.inputAccessoryView = numberToolbar
        txtPassword.inputAccessoryView = numberToolbar
        txtConformPassword.inputAccessoryView = numberToolbar
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc func cancelNumberPad()
    {
           //Cancel with number pad
        view.endEditing(true)
       }
       @objc func doneWithNumberPad()
       {
           //Done with number pad
        view.endEditing(true)
       }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func ActionSubmit(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork() {

        if self.txtFirstName.text?.count == 0
        {
            self.viewFirstName.layer.borderWidth = 1
            self.viewFirstName.layer.borderColor = UIColor.red.cgColor
            self.imgValidationFirstNamee.isHidden = false
//            self.showToast(message: "Please Enter First Name")
            self.lblFirstNameErrorMsg.isHidden = false
            self.lblFirstNameErrorMsg.text = "Please Enter First Name"
        }
//        else if self.txtLastName.text?.count == 0
//        {
//            self.viewLastName.layer.borderWidth = 1
//            self.viewLastName.layer.borderColor = UIColor.red.cgColor
//            self.imgValidationLastName.isHidden = false
////            self.showToast(message: "Please Enter Last Name")
//
//            self.lblLastNameErrorMessage.isHidden = false
//            self.lblLastNameErrorMessage.text = "Please Enter Last Name"
//        }
        else if self.txtcode.text?.count == 0
        {
            self.viewMobileNumber.layer.borderWidth = 1
            self.viewMobileNumber.layer.borderColor = UIColor.red.cgColor
            self.imgValidationMobileNumber.isHidden = false
//            self.showToast(message: "Please Enter Code")
            self.lblMobileNumberErrorMessage.isHidden = false
            self.lblMobileNumberErrorMessage.text = "Please Enter Country Code"

        }
        else if self.txtMobileNumber.text?.count == 0
        {
            self.viewMobileNumber.layer.borderWidth = 1
            self.viewMobileNumber.layer.borderColor = UIColor.red.cgColor
            self.imgValidationMobileNumber.isHidden = false
//            self.showToast(message: "Please Enter Mobile Number")
            self.lblMobileNumberErrorMessage.isHidden = false
            self.lblMobileNumberErrorMessage.text = "Please Enter Mobile Number"

        }
        else if self.txtEmail.text?.count == 0
        {
            self.viewEmail.layer.borderWidth = 1
            self.viewEmail.layer.borderColor = UIColor.red.cgColor
            self.imgValidationemail.isHidden = false
//            self.showToast(message: "Please Enter Email")
            self.lblEmailErrorMessages.isHidden = false
            self.lblEmailErrorMessages.text = "Please Enter Email"
        }
        else if !(txtEmail.text?.validateEmail(enteredEmail: txtEmail.text!))!
        {
            self.lblEmailErrorMessages.isHidden = false
            self.lblEmailErrorMessages.text = Constants.invalidEmailMSG
            self.viewEmail.layer.borderWidth = 1
            self.viewEmail.layer.borderColor = UIColor.red.cgColor
            self.imgValidationemail.isHidden = false
                return
        }
       
        else if self.txtPassword.text?.count == 0
        {
            self.viewPassword.layer.borderWidth = 1
            self.viewPassword.layer.borderColor = UIColor.red.cgColor
            self.imgValidationPassword.isHidden = false
//            self.showToast(message: "Please Enter Password")
            self.lblPasswordErrorMessages.isHidden = false
            self.lblPasswordErrorMessages.text = "Please Enter Password"

        }
        else if self.txtConformPassword.text?.count == 0
        {
            self.viewConformPassword.layer.borderWidth = 1
            self.viewConformPassword.layer.borderColor = UIColor.red.cgColor
            self.imgValidationConfirmPassword.isHidden = false
//            self.showToast(message: "Please confirm your Password")
            self.lblConformPasswordErrorMessages.isHidden = false
            self.lblConformPasswordErrorMessages.text = "Please confirm your Password"

        }
        else if self.txtConformPassword.text != self.txtPassword.text
        {
            self.viewPassword.layer.borderWidth = 1
            self.viewPassword.layer.borderColor = UIColor.red.cgColor
            self.imgValidationPassword.isHidden = false
            self.viewConformPassword.layer.borderWidth = 1
            self.viewConformPassword.layer.borderColor = UIColor.red.cgColor
            self.imgValidationConfirmPassword.isHidden = false
//            self.showToast(message: "Password is mismatch")
            self.lblConformPasswordErrorMessages.isHidden = false
            self.lblConformPasswordErrorMessages.text = "Password is mismatch"
        }
        else if txtMobileNumber.text!.count < 7
        {
            self.viewMobileNumber.layer.borderWidth = 1
            self.viewMobileNumber.layer.borderColor = UIColor.red.cgColor
            self.imgValidationMobileNumber.isHidden = false
//            self.showToast(message:Constants.phoneLengthMsg)
            self.lblMobileNumberErrorMessage.isHidden = false
            self.lblMobileNumberErrorMessage.text = Constants.phoneLengthMsg
        }
        else if txtMobileNumber.text!.count > 15
        {
            self.viewMobileNumber.layer.borderWidth = 1
            self.viewMobileNumber.layer.borderColor = UIColor.red.cgColor
            self.imgValidationMobileNumber.isHidden = false
//            self.showToast(message:Constants.phoneLengthMsg2)
            
            self.lblMobileNumberErrorMessage.isHidden = false
            self.lblMobileNumberErrorMessage.text = Constants.phoneLengthMsg2
        }
        
//        else if !(txtEmail.text!.isValidEmail()) {
//
////                self.showToast(message:Constants.invalidEmailMSG)
//
//            }
//            if txtCPwd.text! != txtPassword.text! {
//                self.showToast(message:Constants.confirmPwdMSG)
//                return
//            }
            else {
                self.RegisterService()
                //let next = self.storyboard?.instantiateViewController(withIdentifier: "VerifyOTPVC") as! VerifyOTPVC
                //self.navigationController?.pushViewController(next, animated: true)
            }
        }
        else {
//            self.showToast(message:Constants.connectivityErrorMsg)
            presentWindow?.makeToast(message: Constants.connectivityErrorMsg, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

        }
        
    }
    
    
    
    @IBAction func iconAction(sender: AnyObject) {
            if(iconClick == true) {
                txtPassword.isSecureTextEntry = false
                btnPWord.setImage(UIImage(named: "download-2"), for: .normal)

            } else {
                txtPassword.isSecureTextEntry = true
                btnPWord.setImage(UIImage(named: "download-1"), for: .normal)
            }

            iconClick = !iconClick
        }
    
    @IBAction func iconAction2(sender: AnyObject) {
            if(iconClick1 == true) {
                txtConformPassword.isSecureTextEntry = false
                btnCPword.setImage(UIImage(named: "download-2"), for: .normal)

            } else {
                txtConformPassword.isSecureTextEntry = true
                btnCPword.setImage(UIImage(named: "download-1"), for: .normal)

            }

        iconClick1 = !iconClick1
        }
    
    func RegisterService()
    {
     
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
     postDict = ["fname":txtFirstName.text!,
                 "lname":txtLastName.text!,
                 "email":txtEmail.text!,
                 "isd_code":self.sCountryCode! as String,
                 "phone":txtMobileNumber.text!,
                 "password":txtPassword.text!,
                 "confirm_password":txtConformPassword.text!,
                 "latitude":String(self.sCurrentLattitude),
                 "longitude":String(self.sCurrentLongitude)

        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.registerURL
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
                    self.registerResponseModel = RegistrationResponseModel(response)
                    
                    let statusCode = Int((self.registerResponseModel?.httpcode)!)
                    if statusCode == 200{
                        print("registerResponseModel ----- ",self.registerResponseModel)
//                        self.showToast(message: (self.registerResponseModel?.registrationData?.message)!)
                        
                        self.presentWindow?.makeToast(message: (self.registerResponseModel?.registrationData?.message)!, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                     DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                         
                        let next = self.storyboard?.instantiateViewController(withIdentifier: "RegisteredUserViewController") as! RegisteredUserViewController
                        
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
                     
                    }
                    if statusCode == 400{
                        
                        self.presentWindow?.makeToast(message: (self.registerResponseModel?.message)!, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

//                     self.showToast(message: (self.registerResponseModel?.message)!)
                    }
                    
                    
                    self.view.activityStopAnimating()
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func ACtionBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func ActionFavourites(_ sender: Any)
    {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "FavouritesViewController") as! FavouritesViewController
        self.navigationController?.pushViewController(next, animated: false)
    }
    @IBAction func ActionHome(_ sender: Any)
    {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(next, animated: false)
    }
    @IBAction func Actionprofile(_ sender: Any)
    {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.navigationController?.pushViewController(next, animated: false)
    }
    @IBAction func ActionContacts(_ sender: Any)
    {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "ContactViewController") as! ContactViewController
        self.navigationController?.pushViewController(next, animated: false)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
            if textField == txtFirstName {
                
                self.viewFirstName.layer.borderWidth = 1
                self.viewFirstName.layer.borderColor = UIColor.lightGray.cgColor
                self.imgValidationFirstNamee.isHidden = true
                self.lblFirstNameErrorMsg.isHidden = true
                print("You edit myTextField")
            }
        else if textField == txtLastName
        {
            self.viewLastName.layer.borderWidth = 1
            self.viewLastName.layer.borderColor = UIColor.lightGray.cgColor
            self.imgValidationLastName.isHidden = true
            self.lblLastNameErrorMessage.isHidden = true

        }
        else if textField == txtMobileNumber
        {
            self.viewMobileNumber.layer.borderWidth = 1
            self.viewMobileNumber.layer.borderColor = UIColor.lightGray.cgColor
            self.imgValidationMobileNumber.isHidden = true
            self.lblMobileNumberErrorMessage.isHidden = true

        }
        else if textField == txtEmail
        {
            self.viewEmail.layer.borderWidth = 1
            self.viewEmail.layer.borderColor = UIColor.lightGray.cgColor
            self.imgValidationemail.isHidden = true
            self.lblEmailErrorMessages.isHidden = true

        }
        else if textField == txtPassword
        {
            self.viewPassword.layer.borderWidth = 1
            self.viewPassword.layer.borderColor = UIColor.lightGray.cgColor
            self.imgValidationPassword.isHidden = true
            self.lblPasswordErrorMessages.isHidden = true

        }
        else if textField == txtConformPassword
        {
            self.viewConformPassword.layer.borderWidth = 1
            self.viewConformPassword.layer.borderColor = UIColor.lightGray.cgColor
            self.imgValidationConfirmPassword.isHidden = true
            self.lblConformPasswordErrorMessages.isHidden = true

        }
        }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtFirstName || textField == txtLastName {
                    let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz   "
                    let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
                    let allowedCharacter1 = CharacterSet.whitespaces

                    let typedCharacterSet = CharacterSet(charactersIn: string)
//                    let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            return allowedCharacterSet.isSuperset(of: typedCharacterSet) || allowedCharacterSet.isSuperset(of: allowedCharacter1)


          }
        if textField == txtFirstName
        {
            guard range.location == 0 else {
                    return true
                }

                let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
                return newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location != 0
        }
       
        if textField == txtMobileNumber {
                       let allowedCharacters = "1234567890"
                       let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
                       let typedCharacterSet = CharacterSet(charactersIn: string)
                       let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
                       return alphabet


             }
        if textField == txtFirstName {
            
            self.viewFirstName.layer.borderWidth = 1
            self.viewFirstName.layer.borderColor = UIColor.lightGray.cgColor
            self.imgValidationFirstNamee.isHidden = true
            self.lblFirstNameErrorMsg.isHidden = true
            print("You edit myTextField")
            return true

        }
    else if textField == txtLastName
    {
        self.viewLastName.layer.borderWidth = 1
        self.viewLastName.layer.borderColor = UIColor.lightGray.cgColor
        self.imgValidationLastName.isHidden = true
        self.lblLastNameErrorMessage.isHidden = true
        return true

    }
    else if textField == txtMobileNumber
    {
        self.viewMobileNumber.layer.borderWidth = 1
        self.viewMobileNumber.layer.borderColor = UIColor.lightGray.cgColor
        self.imgValidationMobileNumber.isHidden = true
        self.lblMobileNumberErrorMessage.isHidden = true
        return true

    }
    else if textField == txtEmail
    {
        self.viewEmail.layer.borderWidth = 1
        self.viewEmail.layer.borderColor = UIColor.lightGray.cgColor
        self.imgValidationemail.isHidden = true
        self.lblEmailErrorMessages.isHidden = true
        return true

    }
    else if textField == txtPassword
    {
        self.viewPassword.layer.borderWidth = 1
        self.viewPassword.layer.borderColor = UIColor.lightGray.cgColor
        self.imgValidationPassword.isHidden = true
        self.lblPasswordErrorMessages.isHidden = true
        return true

    }
    else if textField == txtConformPassword
    {
        self.viewConformPassword.layer.borderWidth = 1
        self.viewConformPassword.layer.borderColor = UIColor.lightGray.cgColor
        self.imgValidationConfirmPassword.isHidden = true
        self.lblConformPasswordErrorMessages.isHidden = true
        return true

    }
        else
        {
            return true
        }
       
      }
}
