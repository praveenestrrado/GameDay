//
//  UserProfileViewController.swift
//  GameDay
//
//  Created by MAC on 30/12/20.
//

import UIKit
import SDWebImage
import MobileCoreServices
import Alamofire
import SwiftyJSON
import PhotosUI
import Photos
import iOSDropDown

class UserProfileViewController: UIViewController, UIScrollViewDelegate,UITextFieldDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    @IBOutlet var scrollViw: UIScrollView!
    var presentWindow : UIWindow?

    
    @IBOutlet var lblProfileName: UILabel!
    @IBOutlet var txtPlayingPosition: DropDown!
    var firstImgData:String = String()
    var sSelectedPhoneCode:String = String()

    @IBOutlet var viewPassword: UIView!
    var sSelectedCountryID:String = String()
    var sSelectedEmiratesID:String = String()
    var sSelectePlyPostionID:String = String()
    var sSelecteGenderID:String = String()
    var sSelectedStateID:String = String()
    var favoritesResponseModel : FavoritesResponseModel?

    @IBOutlet var imgVAlidationPreviosePassword: UIImageView!
    var timage = UIImage()
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var imgValidationretypePassword: UIImageView!
    @IBOutlet var imgVAlidartionChajngePAssword: UIImageView!
    @IBOutlet var imgValidationFavPItch: UIImageView!
    @IBOutlet var imgValidationPlayingPositiuon: UIImageView!
    @IBOutlet var imgValidationNationality: UIImageView!
    @IBOutlet var imgValidationEmirates: UIImageView!
    @IBOutlet var imgValidationDOB: UIImageView!
    @IBOutlet var imgValidationGender: UIImageView!
    @IBOutlet var imgValidationEmail: UIImageView!
    @IBOutlet var imgValidationMobileNumber: UIImageView!
    @IBOutlet var imgValidationLAstName: UIImageView!
    @IBOutlet var imgVAlidationFirstName: UIImageView!
    @IBOutlet weak var txtPreviosPassword: UITextField!
    @IBOutlet weak var viewPreviosPassword: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewBase: UIView!
    @IBOutlet weak var viewUpdateProfile: UIView!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var txtRetypePassword: UITextField!
    @IBOutlet weak var viewRetypePassword: UIView!
    @IBOutlet weak var txtChangePassword: UITextField!
    @IBOutlet weak var viewChangePassword: UIView!
    @IBOutlet weak var txtFavouritePitch: UITextField!
    @IBOutlet weak var viewFavouritePitch: UIView!
    @IBOutlet weak var viewPlayingPosition: UIView!
    @IBOutlet weak var txtNationality: DropDown!
    @IBOutlet weak var viewNationality: UIView!
    @IBOutlet weak var txtEmirates: DropDown!
    @IBOutlet weak var viewEmirates: UIView!
    @IBOutlet weak var txtDateOfBirth: UITextField!
    @IBOutlet weak var viewDateOfBirth: UIView!
    @IBOutlet weak var txtGender: DropDown!
    @IBOutlet weak var viewGender: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var viewMobileNumber: UIView!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var viewLastName: UIView!
    @IBOutlet weak var viewFirstName: UIView!
    
    @IBOutlet var viewState: UIView!
    
    @IBOutlet var imgValidationState: UIImageView!
    @IBOutlet var txtState: DropDown!
    @IBOutlet weak var tctFirstName: UITextField!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnChangePAssword: UIButton!
    @IBOutlet weak var lblFavouritePitch: UILabel!
    @IBOutlet weak var lblPlayingPosition: UILabel!
    @IBOutlet weak var lblNatioanality: UILabel!
    @IBOutlet weak var lblemirate: UILabel!
    @IBOutlet weak var lblDateOfBirth: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblemail: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblfirstName: UILabel!
    let datePickerView:UIDatePicker = UIDatePicker()
    let datePickerViewForDemo:UIDatePicker = UIDatePicker()
    let sharedData = SharedDefault()
    var iChangePassword  = Int()
    var playpositionResponseModel:PlaypositionResponseModel?
    var play_positions: play_position?
    var play_positionsData: [play_positionData]?
    var user_details_Data_Main: User_details_Data_Main?
    var userProfileResponseModel:UserProfileResponseModel?

    var user_details_data:User_details_Data?
    
    var countryResponseModel:CountryResponseModel?
    var countryArrayData:CountryArrayData?
    var country_Data: [Country_Data]?
    
    var stateResponseModel:StateResponseModel?
    var stateArrayData:StateArrayData?
    var state_Data: [State_Data]?

    var sLocation = String()
    var sState = String()
    var sISD = String()

    @IBOutlet weak var viewMainBase: UIView!
    var itemsGender = ["Male","Female"]
     var itemsEmirates = ["Emirates1","Emirates2","Emirates3"]
      var itemsNationality = ["India","Soudi","Bahrain"]
    var itemsPlayingPosition = [String]()
    
    var itemPlayingPosId = [Int]()
    
    
    var sArrayCountryData = [String]()
    var iArrauCountryId = [Int]()
    var sArrayCountryphonecodeData = [String]()

    var sArrayStateData = [String]()
    var iArrauStateId = [Int]()

    
/// Label warning
    
    @IBOutlet var lblWarningPassword: UILabel!
    @IBOutlet var lblWarningFirstName: UILabel!
    
    @IBOutlet var lblWarningLastName: UILabel!
    
    @IBOutlet var lblWarningMobileNumber: UILabel!
    
    @IBOutlet var lblWarningEmail: UILabel!
    
    @IBOutlet var lblWarningDateOfBirth: UILabel!
    
    @IBOutlet var lblWarningGender: UILabel!
    
    @IBOutlet var lblWarningEmirates: UILabel!
    
    @IBOutlet var lblWarningPlayPosition: UILabel!
    
    @IBOutlet var lnlWarningState: UILabel!
    @IBOutlet var lblWarningNationality: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Disable swipe-to-pop gesture
                navigationController?.interactivePopGestureRecognizer?.delegate = self
                navigationController?.interactivePopGestureRecognizer?.isEnabled = false

                // Detect swipe gesture to load next entry
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipeNextEntry)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        presentWindow = UIApplication.shared.keyWindow
        UIView.hr_setToastThemeColor(color: UIColor.white)
        UIView.hr_setToastFontColor(color: self.hexStringToUIColor(hex: "#6fc13a"))
        UIView.hr_setToastFontName(fontName: "TTOctosquares-Medium")
                self.SetUI()
        // Do any additional setup after loading the view.
    }
    
    
    @objc func swipeNextEntry(_ sender: UIPanGestureRecognizer) {
          print("[DEBUG] Pan Gesture Detected")

          if (sender.state == .ended) {
              let velocity = sender.velocity(in: self.view)

              if (velocity.x > 0) { // Coming from left
//                self.navigationController?.popViewController(animated: true)

              }
          }
      }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func SetUI()
    {
//        scrollView.layer.cornerRadius = 35
//        scrollView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.scrollView.delegate = self
        
        if self.sharedData.getAccessToken().count > 0
        {
            self.FetchPlayPositionDetails()
            self.FetchGettingProfileDetails()
            self.FetchCountryPositionDetails()
        }
        else
        {
//            self.showToast(message: "You need to sign in first")
            self.presentWindow?.makeToast(message: "Please sign in to view the profile", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

        }
       
//        self.FetchStatePositionDetails()
        viewPassword.isHidden = true
        viewUpdateProfile.isHidden = true
        btnEdit.layer.borderWidth = 0.5
        btnEdit.layer.borderColor = UIColor.lightGray.cgColor
        btnChangePAssword.layer.borderColor = UIColor.lightGray.cgColor
        btnChangePAssword.layer.borderWidth = 0.5
//        viewBase.clipsToBounds = true
//        viewBase.layer.cornerRadius = 35
//        viewBase.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        viewMainBase.clipsToBounds = true
        viewMainBase.layer.cornerRadius = 35
        viewMainBase.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        
//
        viewFirstName.layer.borderWidth = 1
        tctFirstName.attributedPlaceholder = NSAttributedString(string: "First Name",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        viewFirstName.layer.borderColor = UIColor.lightGray.cgColor
        
        
        
        viewState.layer.borderWidth = 1
        txtState.attributedPlaceholder = NSAttributedString(string: "First State",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        viewState.layer.borderColor = UIColor.lightGray.cgColor
        
        viewLastName.layer.borderWidth = 1
        viewLastName.layer.borderColor = UIColor.lightGray.cgColor
        txtLastName.attributedPlaceholder = NSAttributedString(string: "Last Name",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        viewMobileNumber.layer.borderWidth = 1
        viewMobileNumber.layer.borderColor = UIColor.lightGray.cgColor
        txtMobileNumber.attributedPlaceholder = NSAttributedString(string: "Mobile Number",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        viewEmail.layer.borderWidth = 1
        viewEmail.layer.borderColor = UIColor.lightGray.cgColor
        txtEmail.attributedPlaceholder = NSAttributedString(string: "E-mail",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        viewGender.layer.borderWidth = 1
        viewGender.layer.borderColor = UIColor.lightGray.cgColor
        txtGender.attributedPlaceholder = NSAttributedString(string: "Gender",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        viewDateOfBirth.layer.borderWidth = 1
        viewDateOfBirth.layer.borderColor = UIColor.lightGray.cgColor
        txtDateOfBirth.attributedPlaceholder = NSAttributedString(string: "Date of Birth",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        viewEmirates.layer.borderWidth = 1
        viewEmirates.layer.borderColor = UIColor.lightGray.cgColor
        txtEmirates.attributedPlaceholder = NSAttributedString(string: "Emirate",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        viewNationality.layer.borderWidth = 1
        viewNationality.layer.borderColor = UIColor.lightGray.cgColor
        txtNationality.attributedPlaceholder = NSAttributedString(string: "Nationality",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        viewPlayingPosition.layer.borderWidth = 1
        viewPlayingPosition.layer.borderColor = UIColor.lightGray.cgColor
        txtPlayingPosition.attributedPlaceholder = NSAttributedString(string: "Playing Position",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        viewFavouritePitch.layer.borderWidth = 1
        viewFavouritePitch.layer.borderColor = UIColor.lightGray.cgColor
        txtFavouritePitch.attributedPlaceholder = NSAttributedString(string: "Favourite Pitch",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        viewChangePassword.layer.borderWidth = 1
        viewChangePassword.layer.borderColor = UIColor.lightGray.cgColor
        txtChangePassword.attributedPlaceholder = NSAttributedString(string: "New Password",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)])
        
        viewRetypePassword.layer.borderWidth = 1
        viewRetypePassword.layer.borderColor = UIColor.lightGray.cgColor
        txtRetypePassword.attributedPlaceholder = NSAttributedString(string: "Confirm Password",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)])
        
        
        viewPreviosPassword.layer.borderWidth = 1
        viewPreviosPassword.layer.borderColor = UIColor.lightGray.cgColor
        txtPreviosPassword.attributedPlaceholder = NSAttributedString(string: "Previous Password",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)])
        
        
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker))]
        numberToolbar.sizeToFit()
        self.txtGender.optionArray = itemsGender
//        self.txtEmirates.optionArray = itemsEmirates
//        self.txtNationality.optionArray = itemsNationality

        
        self.txtGender.didSelect{(selectedText , index ,id) in
            print("selectedText ----- ",selectedText)
            if self.itemsGender.count>0{
                print("id ----- ",self.itemsGender[index])
                
                self.txtGender.text = self.itemsGender[index]
            }
        }
        self.txtEmirates.didSelect{(selectedText , index ,id) in
            print("selectedText ----- ",selectedText)
            if self.itemsEmirates.count>0{
                print("Country id ----- ",self.sArrayCountryData[index])
                self.sSelectedEmiratesID = String(self.iArrauCountryId[index])
                self.sSelectedPhoneCode = self.sArrayCountryphonecodeData[index]
                self.txtEmirates.text = self.sArrayCountryData[index]
                
                
            }
        }
        self.txtNationality.didSelect{(selectedText , index ,id) in
            print("selectedText ----- ",selectedText)
            if self.itemsNationality.count>0{
                print("Country id ----- ",self.sArrayCountryData[index])
                self.sSelectedCountryID = String(self.iArrauCountryId[index])
                self.txtNationality.text = self.sArrayCountryData[index]
                self.sSelectedPhoneCode = self.sArrayCountryphonecodeData[index]

                self.FetchStatePositionDetails()
            }
        }
        
        self.txtState.didSelect{(selectedText , index ,id) in
            print("selectedText ----- ",selectedText)
            if self.sArrayStateData.count>0{
                print("State id ----- ",self.sArrayStateData[index])
                self.sSelectedStateID = String(self.iArrauStateId[index])
                self.txtState.text = self.sArrayStateData[index]
            }
        }
        
        self.txtPlayingPosition.didSelect{(selectedText , index ,id) in
            print("selectedText ----- ",selectedText)
            if self.itemsPlayingPosition.count>0{
                print("id ----- ",self.itemPlayingPosId[index])
                self.sSelectePlyPostionID = String(self.itemPlayingPosId[index])
                self.txtPlayingPosition.text = self.itemsPlayingPosition[index]
            }
        }
        
        
        txtDateOfBirth.inputAccessoryView = numberToolbar
        datePickerViewForDemo.datePickerMode = UIDatePicker.Mode.date
        txtDateOfBirth.inputView = datePickerViewForDemo
        if #available(iOS 13.4, *) {
            datePickerViewForDemo.preferredDatePickerStyle = .wheels
        }
        self.datePickerViewForDemo.setDate(Date(), animated: true)

        datePickerViewForDemo.addTarget(self, action: #selector(self.datePickerDemoFromValueChanged), for: UIControl.Event.valueChanged)
    
        txtDateOfBirth.attributedPlaceholder = NSAttributedString(string: " Date of Birth",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        self.view.addGestureRecognizer(tap)
        
        if lblProfileName.text?.count == 0
        {
            self.lblProfileName.text = self.sharedData.getfname() + " " + self.sharedData.getlname()
        }
        
        if lblfirstName.text?.count == 0
        {
            self.lblfirstName.text = self.sharedData.getfname()
        }
        if lblLastName.text?.count == 0
        {
            self.lblLastName.text = self.sharedData.getlname()
        }
        if lblMobileNumber.text?.count == 0
        {
//            self.lblMobileNumber.text = self.sharedData.getisd_code() + " |" + self.sharedData.getphone()
            
            self.lblMobileNumber.text = self.sharedData.getphone()

        }
        if lblemail.text?.count == 0
        {
            self.lblemail.text = self.sharedData.getEmail()
        }
        if lblNatioanality.text?.count == 0
        {
            self.lblNatioanality.text = self.sharedData.getCountyName()
            self.lblemirate.text = self.sharedData.getCountyName()
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: keyboard notification
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }
    @objc func cancelPicker() {
        
        view.endEditing(true)
        
        
    }
    @objc func donePicker()
    {
        view.endEditing(true)
        if txtDateOfBirth.text?.count == 0
        {
            txtDateOfBirth.text = Date.getCurrentDate()
        }
    }
    @objc func datePickerDemoFromValueChanged(sender:UIDatePicker)
    {
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd" //"dd-MM-yyyy""HH:mm:ss"
        
        dateFormatter.dateFormat = "yyyy-MM-dd" //"dd-MM-yyyy""HH:mm:ss"
        
//        self.sSelectedDate = dateFormatter.string(from: sender.date)

        
        dateFormatter.dateFormat = "yyyy-MM-dd" //"dd-MM-yyyy""HH:mm:ss"

        
        //specialDateTextField.text = dateFormatter.string(from: sender.date)
        print("Selected date ::: ",dateFormatter.string(from: sender.date))
        txtDateOfBirth.text = dateFormatter.string(from: sender.date)
        
    }
    
    
    @IBAction func ActionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: false
        )
    }
    
    @IBOutlet weak var ActionBack: UIImageView!
    
    @IBAction func ActionEdit(_ sender: Any)
    {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)

        self.iChangePassword = 2
        viewPassword.isHidden = true
        self.viewUpdateProfile.isHidden = false
        self.tctFirstName.isEnabled = true
        self.txtLastName.isEnabled = true
        self.txtMobileNumber.isEnabled = true
        self.txtEmail.isEnabled = true
        self.txtGender.isEnabled = true
        self.txtDateOfBirth.isEnabled = true
        self.txtEmirates.isEnabled = true
        self.txtNationality.isEnabled = true
        self.txtPlayingPosition.isEnabled = true
        self.txtFavouritePitch.isEnabled = true
        self.txtRetypePassword.isEnabled = false
        self.txtPreviosPassword.isEnabled = false
        self.txtChangePassword.isEnabled = false
        self.btnEdit.isHidden = true
        
    }
    
    
    @IBAction func ActionChangePassword(_ sender: Any)
    {
        self.iChangePassword = 1
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)

        viewPassword.isHidden = false
        self.viewUpdateProfile.isHidden = false
        self.tctFirstName.isEnabled = false
        self.txtLastName.isEnabled = false
        self.txtMobileNumber.isEnabled = false
        self.txtEmail.isEnabled = false
        self.txtGender.isEnabled = false
        self.txtDateOfBirth.isEnabled = false
        self.txtEmirates.isEnabled = false
        self.txtNationality.isEnabled = false
        self.txtPlayingPosition.isEnabled = false
        self.txtFavouritePitch.isEnabled = false
        self.txtRetypePassword.isEnabled = true
        self.txtChangePassword.isEnabled = true
        self.btnEdit.isHidden = true
        
        
    }
    
    @IBAction func ActionUpdatePAssword(_ sender: Any)
    {
        if Reachability.isConnectedToNetwork()
        {
                   
            if self.iChangePassword == 1
            {
              
                if self.txtPreviosPassword.text?.count == 0
                {
                    self.viewPreviosPassword.layer.borderColor = UIColor.red.cgColor
                    self.viewPreviosPassword.layer.borderWidth  = 1
                    self.imgVAlidationPreviosePassword.isHidden = false
//                    self.showToast(message: "Previouse password is missing")
                    
                    self.lblWarningPassword.text = "Previous password is missing"
                }
               else  if self.txtRetypePassword.text?.count == 0
                {
                self.viewRetypePassword.layer.borderColor = UIColor.red.cgColor
                self.viewRetypePassword.layer.borderWidth  = 1
                    self.imgValidationretypePassword.isHidden = false
                
                self.lblWarningPassword.text = "Confirmation password data is missing"


                }
               else  if self.txtChangePassword.text?.count == 0
                {
                self.viewChangePassword.layer.borderColor = UIColor.red.cgColor
                self.viewChangePassword.layer.borderWidth  = 1
                    self.imgVAlidartionChajngePAssword.isHidden = false
                self.lblWarningPassword.text = "New password  data is missing"

                }
               else  if self.txtChangePassword.text != self.txtRetypePassword.text
                {
                
                self.viewRetypePassword.layer.borderColor = UIColor.red.cgColor
                self.viewRetypePassword.layer.borderWidth  = 1
                    self.imgValidationretypePassword.isHidden = false
                

                self.viewChangePassword.layer.borderColor = UIColor.red.cgColor
                self.viewChangePassword.layer.borderWidth  = 1
                    self.imgVAlidartionChajngePAssword.isHidden = false
                
//                self.showToast(message: "Password data  mismatching")
                self.lblWarningPassword.text = "Password data  mismatching"

                }
                else
               {
                self.updatePasswordProfile()
               }
            }
        }
    }
    @IBAction func ACtionUpdate(_ sender: Any)
    {
        
        
        
        self.scrollView.scrollRectToVisible(self.scrollView.frame, animated: false)


        self.txtRetypePassword.isEnabled = false
        self.txtChangePassword.isEnabled = false
        

        
        if Reachability.isConnectedToNetwork()
        {
                   
            if self.iChangePassword == 2
            {
                
         
                    if  self.tctFirstName.text?.count == 0
                    {
                        self.viewFirstName.layer.borderColor = UIColor.red.cgColor
                        self.viewFirstName.layer.borderWidth  = 1
                        self.imgVAlidationFirstName.isHidden = false
//                        self.showToast(message: "Please enter first name")
                        self.lblWarningFirstName.isHidden = false
                        self.lblWarningFirstName.text = "Please enter first name"
                        
                    }
//                    else if self.txtLastName.text?.count == 0
//                    {
//                        self.viewLastName.layer.borderColor = UIColor.red.cgColor
//                        self.viewLastName.layer.borderWidth  = 1
//                        self.imgValidationLAstName.isHidden = false
////                        self.showToast(message: "Please enter last name")
//                        self.lblWarningLastName.isHidden = false
//                        self.lblWarningLastName.text = "Please enter last name"
//
//                    }
//
                    else if self.txtMobileNumber.text?.count == 0
                    {
                        self.viewMobileNumber.layer.borderColor = UIColor.red.cgColor
                        self.viewMobileNumber.layer.borderWidth  = 1
                        self.imgValidationMobileNumber.isHidden = false
//                        self.showToast(message: "Please enter  mobile number")
                        
                        self.lblWarningMobileNumber.isHidden = false
                        self.lblWarningMobileNumber.text = "Please enter  mobile number"

                    }
                    else if self.txtEmail.text?.count == 0
                    {
                        self.viewEmail.layer.borderColor = UIColor.red.cgColor
                        self.viewEmail.layer.borderWidth  = 1
                        self.imgValidationEmail.isHidden = false
//                        self.showToast(message: "Please enter email")
                        
                        self.lblWarningEmail.isHidden = false
                        self.lblWarningEmail.text = "Please enter email"
                    }
                    else if self.txtGender.text?.count == 0
                    {
                        self.viewGender.layer.borderColor = UIColor.red.cgColor
                        self.viewGender.layer.borderWidth  = 1
                        self.imgValidationGender.isHidden = false
//                        self.showToast(message: "Please enter gender")
                        
                        self.lblWarningGender.isHidden = false
                        self.lblWarningGender.text = "Please enter email"
                    }
                    else if self.txtDateOfBirth.text?.count == 0
                    {
                        self.viewDateOfBirth.layer.borderColor = UIColor.red.cgColor
                        self.viewDateOfBirth.layer.borderWidth  = 1
                        self.imgValidationDOB.isHidden = false
//                        self.showToast(message: "Please enter DOB")
                        
                        self.lblWarningDateOfBirth.isHidden = false
                        self.lblWarningDateOfBirth.text = "Please enter DOB"
                    }
                    else if self.txtEmirates.text?.count == 0
                    {
                        self.viewEmirates.layer.borderColor = UIColor.red.cgColor
                        self.viewEmirates.layer.borderWidth  = 1
                        self.imgValidationEmirates.isHidden = false
//                        self.showToast(message: "Please enter Emirates")
                        
                        self.lblWarningEmirates.isHidden = false
                        self.lblWarningEmirates.text = "Please enter Emirates"
                    }
                    else if self.txtNationality.text?.count == 0
                    {
                        self.viewNationality.layer.borderColor = UIColor.red.cgColor
                        self.viewNationality.layer.borderWidth  = 1
                        self.imgValidationNationality.isHidden = false
//                        self.showToast(message: "Please enter Nationality")
                        
                        self.lblWarningNationality.isHidden = false
                        self.lblWarningNationality.text = "Please enter Nationality"
                        
                    }
                    else if self.txtState.text?.count == 0
                    {
                        self.viewState.layer.borderColor = UIColor.red.cgColor
                        self.viewState.layer.borderWidth  = 1
                        self.imgValidationState.isHidden = false
//                        self.showToast(message: "Please enter state")
                        
                        self.lnlWarningState.isHidden = false
                        self.lnlWarningState.text = "Please enter state"
                        
                        
                    }
                    else if self.txtPlayingPosition.text?.count == 0
                    {
                        self.viewPlayingPosition.layer.borderColor = UIColor.red.cgColor
                        self.viewPlayingPosition.layer.borderWidth  = 1
                        self.imgValidationPlayingPositiuon.isHidden = false
//                        self.showToast(message: "Please enter playing position")
                        
                        self.lblWarningPlayPosition.isHidden = false
                        self.lblWarningPlayPosition.text = "Please enter playing position"
                        
                    }
                   else if !(txtEmail.text!.isValidEmail())
                   {
                       self.viewEmail.layer.borderColor = UIColor.red.cgColor
                       self.viewEmail.layer.borderWidth  = 1
                       self.imgValidationEmail.isHidden = false
//                        self.showToast(message: "Please enter email")
                       
                       self.lblWarningEmail.isHidden = false
                       self.lblWarningEmail.text = Constants.invalidEmailMSG
                   }
                   else if txtMobileNumber.text!.count < 7

            
                   {
                       self.viewMobileNumber.layer.borderColor = UIColor.red.cgColor
                       self.viewMobileNumber.layer.borderWidth  = 1
                       self.imgValidationMobileNumber.isHidden = false
//                        self.showToast(message: "Please enter  mobile number")
                       
                       self.lblWarningMobileNumber.isHidden = false
                       self.lblWarningMobileNumber.text = Constants.phoneLengthMsg

                   }
            
            
                   else if txtMobileNumber.text!.count > 15

                   {
                       self.viewMobileNumber.layer.borderColor = UIColor.red.cgColor
                       self.viewMobileNumber.layer.borderWidth  = 1
                       self.imgValidationMobileNumber.isHidden = false
                       self.lblWarningMobileNumber.isHidden = false
                       self.lblWarningMobileNumber.text = Constants.phoneLengthMsg2

                   }
                   
                    else
                    {
                        if self.sharedData.getAccessToken().count > 0
                        {
                            self.updateProfile()

                        }
                        
                    }
                    }
            else
            {
                
            }
                }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
   
    
    
    
    func FetchGettingProfileDetails()
    {
     
        self.view.activityStartAnimating()
        
       
        var postDict = Dictionary<String,String>()
        postDict = ["access_token":self.sharedData.getAccessToken()
        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.ProfileURL
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
                    self.userProfileResponseModel = UserProfileResponseModel(response)
                    self.user_details_Data_Main = self.userProfileResponseModel?.user_details_Data_Main
                    self.user_details_data = self.user_details_Data_Main?.user_details_data
                    let statusCode = Int((self.userProfileResponseModel?.httpcode)!)
                    if statusCode == 200
                    {
                        self.txtEmirates.text = self.user_details_data?.profile_country
                        
                        
                        
                       

                        
                        self.sSelectePlyPostionID = String((self.user_details_data?.positionId)!)
                        
                        self.sSelectedCountryID =  String((self.user_details_data?.countryId)!)
                        
                        self.sSelectedStateID =  String((self.user_details_data?.stateId)!)

                        
                        
                        self.lblfirstName.text = self.user_details_data?.profile_fname
                        self.lblLastName.text = self.user_details_data?.profile_lname
                        self.lblProfileName.text = (self.user_details_data?.profile_fname)! + "  " + (self.user_details_data?.profile_lname)!
                            
                        self.sISD =  String((self.user_details_data?.profile_Isd_code)!)
//                        self.lblMobileNumber.text = String((self.user_details_data?.profile_Isd_code)!) + " | " + String((self.user_details_data?.profile_phone)!)
                       
                        self.lblMobileNumber.text =  String((self.user_details_data?.profile_phone)!)
                        self.lblemirate.text = self.user_details_data?.profile_country
                        self.lblemail.text = self.user_details_data?.profile_email
                        self.lblGender.text = self.user_details_data?.profile_gender
                        self.lblDateOfBirth.text = self.user_details_data?.profile_dob
                        self.lblNatioanality.text = self.user_details_data?.profile_country
                        self.lblPlayingPosition.text = self.user_details_data?.profile_play_position
                        self.lblFavouritePitch.text = self.user_details_data?.profile_favorite_pitch
                        self.imgProfile.sd_setImage(with: URL(string: (self.user_details_data?.profile_avatar!)!), placeholderImage: UIImage(named: ""))
                        
                        self.tctFirstName.text = self.user_details_data?.profile_fname
                        self.txtLastName.text = self.user_details_data?.profile_lname
//                        self.txtMobileNumber.text = String((self.user_details_data?.profile_Isd_code)!) + " | " + String((self.user_details_data?.profile_phone)!)
                        
                        self.txtMobileNumber.text =  String((self.user_details_data?.profile_phone)!)

                        
                        
                        self.txtEmail.text = self.user_details_data?.profile_email
                        self.txtGender.text = self.user_details_data?.profile_gender
                        self.txtDateOfBirth.text = self.user_details_data?.profile_dob
                        self.txtNationality.text = self.user_details_data?.profile_country
                        self.txtPlayingPosition.text = self.user_details_data?.profile_play_position
                        self.txtFavouritePitch.text = self.user_details_data?.profile_favorite_pitch
                        self.imgProfile.sd_setImage(with: URL(string: (self.user_details_data?.profile_avatar!)!), placeholderImage: UIImage(named: ""))
                        self.sLocation = (self.user_details_data?.profile_location)!
                        self.sState = (self.user_details_data?.profile_profile_state)!
                        self.sSelectedStateID = "1"
                        self.txtState.text = self.user_details_data?.profile_profile_state
                    }
                    if statusCode == 400{

//                        self.showToast(message:(self.userProfileResponseModel?.message)!)
                        self.presentWindow?.makeToast(message: (self.userProfileResponseModel?.message)!, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                    }
                    
                    
                    self.view.activityStopAnimating()
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
    
    func FetchPlayPositionDetails()
    {
     
        self.view.activityStartAnimating()
        
        
        let loginURL = Constants.baseURL+Constants.playPositionURL
        print("loginURL",loginURL)
        
        AF.request(loginURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { [self] (data) in
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
                    self.playpositionResponseModel = PlaypositionResponseModel(response)
//
                    self.play_positions = self.playpositionResponseModel?.play_positions
                 
                    self.play_positionsData = self.play_positions?.play_positionsData
                    
                    let statusCode = Int((self.playpositionResponseModel?.httpcode)!)
                    if statusCode == 200
                    {
                       
                        if self.play_positionsData!.count > 0
                        {
                            for item in self.play_positionsData! {
                                
                                self.itemsPlayingPosition.append(item.position!)
                                self.itemPlayingPosId.append(item.id!)
                            }
                        }
                        self.txtPlayingPosition.optionArray = self.itemsPlayingPosition
                        self.txtPlayingPosition.optionIds = self.itemPlayingPosId

                    }
                    if statusCode == 400{

//                        self.showToast(message:(self.userProfileResponseModel?.message)!)
                        self.presentWindow?.makeToast(message: (self.userProfileResponseModel?.message)!, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                    }
                    
                    
                    self.view.activityStopAnimating()
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func ActonProfilePic(_ sender: Any) {
        
        self.showAlert()
    }
    
    func showAlert() {
        
      
                
                let alert = UIAlertController(title: "Image Selection", message: "From where you want to pick this image?", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
                    self.getImage(fromSourceType: .camera)
                }))
                alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
                    self.getImage(fromSourceType: .photoLibrary)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                
                
            }
    
    
    
    //get image from source type
       func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            imagePickerController.modalPresentationStyle = .fullScreen
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Info ------->",info as Any)
        if let imageURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
            let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
            let asset = result.firstObject
            print(asset?.value(forKey: "filename") as Any)
        }
        let pImage = info[UIImagePickerController.InfoKey.originalImage]
        timage = (pImage as? UIImage)!
        firstImgData = convertImageToBase_64(image: timage.jpeg(UIImage.JPEGQuality(rawValue: 0.0)!)!)
        
        self.imgProfile.image = timage


        // btnProfilePic.setImage(pImage as? UIImage, for: .normal)
        //updateDetails["avatar"] = convertImageToBase64(image: ((pImage as? UIImage)!))
        dismiss(animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.view.activityStartAnimating()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.view.activityStopAnimating()
        }
    }
    
    
    func saveImage(imageName: String, image: UIImage) {
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }

        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }

        }

        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }

    }
    
    func deleteDirectory(sFileNme:String)
    {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        let fileName = sFileNme
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }

        }
    }
    func updatePasswordProfile(){
        self.view.activityStartAnimating()
        var postDict = Dictionary<String,String>()
        
        
        var  sPhone = String()
        
        sPhone = txtMobileNumber.text!
        if self.sISD.count == 0
        {
            self.sISD = self.sSelectedPhoneCode
        }
        if self.sLocation.count == 0
        {
            self.sLocation = "Bahrain"
        }
        let last4 = String(sPhone.suffix(10))
        print(last4)
        //mobilevalue.dropFirst(1)
        postDict = [
            "access_token":sharedData.getAccessToken(),
            "fname":tctFirstName.text!,
            "lname":txtLastName.text!,
            "email":txtEmail.text!,
            "isd_code":self.sISD,
            "phone":last4,
            "gender":txtGender.text!,
            "dob":txtDateOfBirth.text!,
            "location":txtState.text!,
            "state":self.sSelectedStateID ,
            "country":self.sSelectedCountryID,
            "play_position":sSelectePlyPostionID,
            "avatar":firstImgData,
            "password" : self.txtRetypePassword.text!

        ]
        
        let loginURL = Constants.baseURL+Constants.UpdateProfileURL
        print("loginURL",loginURL)
        print("postDict",postDict)
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
                    self.userProfileResponseModel = UserProfileResponseModel(response)
                    
                    
//                    let response = JSON(data.data!)
//                    self.pUpdateModel = ProfileUpRespModel(response)
                    let statusCode = Int((self.userProfileResponseModel?.httpcode)!)
                    if statusCode == 200{
                        self.showToast(message: (self.userProfileResponseModel?.message)!)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                             
                            self.view.activityStopAnimating()
//                            self.saveImage(imageName: "ProfileImage_\(self.txtName.text!)", image: self.timage)
//
//                            self.navigationController?.popViewController(animated: true)
                            
//                            self.navigationController?.popViewController(animated: true)
//                            self.bSelectedDate = false
//                            self.btnSave.setTitle("EDIT", for: .normal)
//
                            //        self.scrollView.reloadInputViews()
                                    self.viewUpdateProfile.isHidden = true
                                    self.btnEdit.isHidden = false
                                    self.viewPassword.isHidden = true

                            self.FetchGettingProfileDetails()
                                    
                        }
                    }
                    if statusCode == 400
                    {
                        self.view.activityStopAnimating()
//                        self.showToast(message: (self.userProfileResponseModel?.message)!)
                        self.presentWindow?.makeToast(message: (self.userProfileResponseModel?.message)!, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                        self.deleteDirectory(sFileNme: "ProfileImage")
//
                    }
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                    
                    self.view.activityStopAnimating()

                }
            }
        }
    }
    
    func updateProfile(){
        self.view.activityStartAnimating()
        var postDict = Dictionary<String,String>()
        
        
        var  sPhone = String()
        
        sPhone = txtMobileNumber.text!
        if self.sISD.count == 0
        {
            self.sISD = self.sSelectedPhoneCode
        }
        if self.sLocation.count == 0
        {
            self.sLocation = "Bahrain"
        }
        let last4 = String(sPhone.suffix(10))
        print(last4)
        //mobilevalue.dropFirst(1)
        postDict = [
            "access_token":sharedData.getAccessToken(),
            "fname":tctFirstName.text!,
            "lname":txtLastName.text!,
            "email":txtEmail.text!,
            "isd_code":self.sISD,
            "phone":last4,
            "gender":txtGender.text!,
            "dob":txtDateOfBirth.text!,
            "location":txtState.text!,
            "state":self.sSelectedStateID ,
            "country":self.sSelectedCountryID,
            "play_position":sSelectePlyPostionID,
            "avatar":firstImgData,
            "favorite_pitch" : self.txtFavouritePitch.text!

        ]
        
        let loginURL = Constants.baseURL+Constants.UpdateProfileURL
        print("loginURL",loginURL)
        print("postDict",postDict)
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
                    self.userProfileResponseModel = UserProfileResponseModel(response)
                    
                    
//                    let response = JSON(data.data!)
//                    self.pUpdateModel = ProfileUpRespModel(response)
                    let statusCode = Int((self.userProfileResponseModel?.httpcode)!)
                    if statusCode == 200{
//                        self.showToast(message: (self.userProfileResponseModel?.message)!)
                        self.presentWindow?.makeToast(message: (self.userProfileResponseModel?.message)!, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                             
                            self.view.activityStopAnimating()
//                            self.saveImage(imageName: "ProfileImage_\(self.txtName.text!)", image: self.timage)
//
//                            self.navigationController?.popViewController(animated: true)
                            
//                            self.navigationController?.popViewController(animated: true)
//                            self.bSelectedDate = false
//                            self.btnSave.setTitle("EDIT", for: .normal)
//
                            //        self.scrollView.reloadInputViews()
                                    self.viewUpdateProfile.isHidden = true
                                    self.btnEdit.isHidden = false
                            
                            self.FetchGettingProfileDetails()
                                    
                        }
                    }
                    if statusCode == 400
                    {
                        self.view.activityStopAnimating()
                        self.presentWindow?.makeToast(message: (self.userProfileResponseModel?.message)!, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

//                        self.showToast(message: (self.userProfileResponseModel?.message)!)
                        self.deleteDirectory(sFileNme: "ProfileImage")
//
                    }
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                    
                    self.view.activityStopAnimating()

                }
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
            if textField == tctFirstName
            {
                print("You edit myTextField")
                self.viewFirstName.layer.borderColor = UIColor.white.cgColor
                self.viewFirstName.layer.borderWidth  = 1
                self.imgVAlidationFirstName.isHidden = true
                self.lblWarningFirstName.isHidden = true
            }
        else if textField == txtLastName {
            print("You edit myTextField")
            self.viewLastName.layer.borderColor = UIColor.white.cgColor
            self.viewLastName.layer.borderWidth  = 1
            self.imgValidationLAstName.isHidden = true
            self.lblWarningLastName.isHidden = true

        }
        else if textField == txtMobileNumber {
            print("You edit myTextField")
            self.viewMobileNumber.layer.borderColor = UIColor.white.cgColor
            self.viewMobileNumber.layer.borderWidth  = 1
            self.imgValidationMobileNumber.isHidden = true
            self.lblWarningMobileNumber.isHidden = true

        }
        else if textField == txtEmail {
            print("You edit myTextField")
            self.viewEmail.layer.borderColor = UIColor.white.cgColor
            self.viewEmail.layer.borderWidth  = 1
            self.imgValidationEmail.isHidden = true
            self.lblWarningEmail.isHidden = true

        } else if textField == txtGender {
            print("You edit myTextField")
            self.viewGender.layer.borderColor = UIColor.white.cgColor
            self.viewGender.layer.borderWidth  = 1
            self.imgValidationGender.isHidden = true
            self.lblWarningGender.isHidden = true

            textField .resignFirstResponder()

        } else if textField == txtDateOfBirth {
            print("You edit myTextField")
            self.datePickerViewForDemo.setDate(Date(), animated: true)

            
            self.viewDateOfBirth.layer.borderColor = UIColor.white.cgColor
            self.viewDateOfBirth.layer.borderWidth  = 1
            self.imgValidationDOB.isHidden = true
            self.lblWarningDateOfBirth.isHidden = true

//            textField .resignFirstResponder()

        }
        else if textField == txtEmirates {
            print("You edit myTextField")
            self.viewEmirates.layer.borderColor = UIColor.white.cgColor
            self.viewEmirates.layer.borderWidth  = 1
            self.imgValidationEmirates.isHidden = true
            self.lblWarningEmirates.isHidden = true

            textField .resignFirstResponder()

        } else if textField == txtNationality {
            print("You edit myTextField")
            self.viewNationality.layer.borderColor = UIColor.white.cgColor
            self.viewNationality.layer.borderWidth  = 1
            self.imgValidationNationality.isHidden = true
            self.lblWarningNationality.isHidden = true

            textField .resignFirstResponder()

        }
        else if textField == txtState {
            print("You edit myTextField")
            self.viewState.layer.borderColor = UIColor.white.cgColor
            self.viewState.layer.borderWidth  = 1
            self.imgValidationState.isHidden = true
            self.lnlWarningState.isHidden = true

            textField .resignFirstResponder()

        }
        else if textField == txtPlayingPosition {
            print("You edit myTextField")
            self.viewPlayingPosition.layer.borderColor = UIColor.white.cgColor
            self.viewPlayingPosition.layer.borderWidth  = 1
            self.imgValidationPlayingPositiuon.isHidden = true
            self.lblWarningPlayPosition
                .isHidden = true

            textField .resignFirstResponder()

            
        }
        else if textField == txtFavouritePitch {
            print("You edit myTextField")
            self.viewFavouritePitch.layer.borderColor = UIColor.white.cgColor
            self.viewFavouritePitch.layer.borderWidth  = 1
            self.imgValidationFavPItch.isHidden = true
        }
        
        else if textField == txtChangePassword {
            print("You edit myTextField")
            self.viewChangePassword.layer.borderColor = UIColor.white.cgColor
            self.viewChangePassword.layer.borderWidth  = 1
            self.imgVAlidartionChajngePAssword.isHidden = true
        }
        else if textField == txtPreviosPassword {
            print("You edit myTextField")
            self.viewPreviosPassword.layer.borderColor = UIColor.white.cgColor
            self.viewPreviosPassword.layer.borderWidth  = 1
            self.imgVAlidationPreviosePassword.isHidden = true
        }
        else if textField == txtRetypePassword {
            print("You edit myTextField")
            self.viewRetypePassword.layer.borderColor = UIColor.white.cgColor
            self.viewRetypePassword.layer.borderWidth  = 1
            self.imgValidationretypePassword.isHidden = true
        }
        }
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//     
//        
//         if textField == txtGender {
//            textField .resignFirstResponder()
//            return true;
//       } else if textField == txtDateOfBirth {
//        textField .resignFirstResponder()
//        return true;
//       }
//       else if textField == txtEmirates {
//        textField .resignFirstResponder()
//        return true;
//       } else if textField == txtNationality {
//        textField .resignFirstResponder()
//        return true;
//       }
//       else if textField == txtState {
//        textField .resignFirstResponder()
//        return true;
//       }
//       else if textField == txtPlayingPosition {
//        textField .resignFirstResponder()
//        return true;
//           
//       }
//      
//     }
//    
//    
    
    func FetchCountryPositionDetails()
    {
     
        self.view.activityStartAnimating()
        
        
        let loginURL = Constants.baseURL+Constants.countryURL
        print("loginURL",loginURL)
        
        AF.request(loginURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { [self] (data) in
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
                    self.countryResponseModel = CountryResponseModel(response)
                    self.countryArrayData = self.countryResponseModel?.countryData
                    self.country_Data = self.countryArrayData?.country_Data
                    let statusCode = Int((self.countryResponseModel?.httpcode)!)
                    
                    if statusCode == 200
                    {
                       
                        if self.country_Data!.count > 0
                        {
                            for item in self.country_Data! {
                                
                                self.sArrayCountryData.append(item.name!)
                                self.iArrauCountryId.append(item.id!)
                                self.sArrayCountryphonecodeData.append(String(item.phonecode!))
                            }
                        }
                        self.txtNationality.optionArray = self.sArrayCountryData
                        self.txtNationality.optionIds = self.iArrauCountryId
                        self.txtEmirates.optionArray = self.sArrayCountryData
                        self.txtEmirates.optionIds = self.iArrauCountryId
                    }
                    if statusCode == 400{

//                        self.showToast(message:(self.countryResponseModel?.message)!)
                        self.presentWindow?.makeToast(message: (self.countryResponseModel?.message)!, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                    }
                    
                    
                    self.view.activityStopAnimating()
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
    
    func FetchStatePositionDetails()
    {
     
        self.view.activityStartAnimating()
        var postDict = Dictionary<String,String>()
        
        
       
        
      
        //mobilevalue.dropFirst(1)
        postDict = [
            "country_id":self.sSelectedCountryID
           
        ]
        
        let loginURL = Constants.baseURL+Constants.stateURL
        print("loginURL",loginURL)
        
        AF.request(loginURL, method: .post, parameters: postDict, encoding: URLEncoding.default, headers: nil).responseJSON { [self] (data) in
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
                    self.stateResponseModel = StateResponseModel(response)
//
                    self.stateArrayData = self.stateResponseModel?.stateData
                 
                    self.state_Data = self.stateArrayData?.state_Data
                    
                    let statusCode = Int((self.stateResponseModel?.httpcode)!)
                    if statusCode == 200
                    {
                       
                        if self.state_Data!.count > 0
                        {
                            for item in self.state_Data! {
                                
                                self.sArrayStateData.append(item.name!)
                                self.iArrauStateId.append(item.id!)
                            }
                        }
                        self.txtState.optionArray = self.sArrayStateData
                        self.txtState.optionIds = self.iArrauStateId

                    }
                    if statusCode == 400{

//                        self.showToast(message:(self.stateResponseModel?.message)!)
                        self.presentWindow?.makeToast(message: (self.stateResponseModel?.message)!, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                    }
                    
                    
                    self.view.activityStopAnimating()
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
}
