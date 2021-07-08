//
//  ContactViewController.swift
//  GameDay
//
//  Created by MAC on 21/12/20.
//

import UIKit
import ImageSlideshow
import iOSDropDown
import Alamofire
import SwiftyJSON
class ContactViewController: UIViewController,UITextFieldDelegate, UIGestureRecognizerDelegate,UITextViewDelegate
{
    @IBOutlet var scroll: UIScrollView!
    var presentWindow : UIWindow?

    @IBOutlet var lblPhoneNumber: UILabel!
    @IBOutlet var imgValidationTxtMobileNumber: UIImageView!
    @IBOutlet var imgVAlidationTxtFirstName: UIImageView!
    @IBOutlet var imgValidationTxtLastName: UIImageView!
    @IBOutlet var imgValidationTxtEmail: UIImageView!
    @IBOutlet var imgValidationTxtType: UIImageView!
    @IBOutlet weak var btnContact: UIButton!
    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var viewtxtWhtsUp: UIView!
    @IBOutlet weak var viewMobileNumber: UIView!
    @IBOutlet weak var viewFirstName: UIView!
    @IBOutlet weak var viewtxtLastName: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewTxtType: UIView!
    @IBOutlet weak var viewbase: UIView!
    @IBOutlet weak var btnLetsDoIt: UIButton!
    @IBOutlet weak var lblHeading2: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
    let sharedData = SharedDefault()

 
    @IBOutlet var txtType: UITextView!
    
    
    
//    @IBOutlet weak var txtType: UITextView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    
    var contactSaveResponseModel:ContactSaveResponseModel?
    var contact_SaveData_Main: Contact_SaveData_Main?


    var contactResponseModel:ContactResponseModel?
    var contact_Data_Main: Contact_Data_Main?
    var pitch_types_data: [pitch_typesData]?
    var pitch_sizes_Data: [pitch_sizesData]?
    var pitch_turfs_data: [pitch_turfsData]?
    var sArrayType = [String]()
    var sArrayTypeId = [Int]()
    var sArrayTurf = [String]()
    var sArrayTurfId = [Int]()
    var sArraySize = [String]()
    var sArraySizeId = [Int]()
    var sdImageSource = [SDWebImageSource]()
    @IBOutlet weak var imgSlideShow: ImageSlideshow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentWindow = UIApplication.shared.keyWindow
        UIView.hr_setToastThemeColor(color: UIColor.white)
        UIView.hr_setToastFontColor(color: self.hexStringToUIColor(hex: "#6fc13a"))
        UIView.hr_setToastFontName(fontName: "TTOctosquares-Medium")
                // Disable swipe-to-pop gesture
                navigationController?.interactivePopGestureRecognizer?.delegate = self
                navigationController?.interactivePopGestureRecognizer?.isEnabled = false

                // Detect swipe gesture to load next entry
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipeNextEntry)))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        self.view.addGestureRecognizer(tap)

        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        
        self.txtType.delegate = self
//        txtType.text = "Message"
//        txtType.textColor = UIColor.lightGray
//
        
        self.txtType.placeholder = "Message"
        
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelNumberPad)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneWithNumberPad))]
        numberToolbar.sizeToFit()
        txtMobileNumber.inputAccessoryView = numberToolbar
        txtType.inputAccessoryView = numberToolbar
        
        let pageIndicator = UIPageControl()
        pageIndicator.frame = CGRect(x: pageIndicator.frame.origin.x, y: pageIndicator.frame.origin.y, width: pageIndicator.frame.size.width, height: 0)
        pageIndicator.currentPageIndicatorTintColor = UIColor.white
        pageIndicator.pageIndicatorTintColor = UIColor.lightGray
        pageIndicator.layer.cornerRadius = 10.0
        pageIndicator.sizeToFit()
        imgSlideShow.pageIndicator = pageIndicator
        imgSlideShow.contentScaleMode = .scaleToFill
        imgSlideShow.slideshowInterval = 2.0
//        imgSlideShow.setImageInputs([ImageSource(image: UIImage(named: "Image1")!),
//                                     ImageSource(image: UIImage(named: "ground-1")!),
//                                     ImageSource(image: UIImage(named: "ground-2")!),
//                                     ImageSource(image: UIImage(named: "ground-4")!),ImageSource(image: UIImage(named: "ground-5")!
//                                                 )])
//
        
        imgSlideShow.setImageInputs([ImageSource(image: UIImage(named: "Image1")!)
                                                 ])
        
        
        
        // Do any additional setup after loading the view.
        btnLetsDoIt.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
        viewtxtWhtsUp.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
        btnSubmit.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
        viewbase.clipsToBounds = true
        viewbase.layer.cornerRadius = 35
        viewbase.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively
        viewFirstName.layer.borderWidth = 0.5
        //txtFirstName.layer.cornerRadius = 18
        txtFirstName.attributedPlaceholder = NSAttributedString(string: "First Name",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        viewFirstName.layer.borderColor = UIColor.lightGray.cgColor
        
        viewtxtLastName.layer.borderWidth = 0.5
       // txtLastName.layer.cornerRadius = 18
        txtLastName.attributedPlaceholder = NSAttributedString(string: "Last Name",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        viewtxtLastName.layer.borderColor = UIColor.lightGray.cgColor
        
        viewMobileNumber.layer.borderWidth = 0.5
     //   txtMobileNumber.layer.cornerRadius = 18
        txtMobileNumber.attributedPlaceholder = NSAttributedString(string: "Mobile Number" ,
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        viewMobileNumber.layer.borderColor = UIColor.lightGray.cgColor
        
        viewEmail.layer.borderWidth = 0.5
    //    txtEmail.layer.cornerRadius = 18
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Email" ,
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        viewEmail.layer.borderColor = UIColor.lightGray.cgColor
        
        viewTxtType.layer.borderWidth = 0.5
       // txtType.layer.cornerRadius = 18
        viewTxtType.layer.borderColor = UIColor.lightGray.cgColor
//        txtType.attributedPlaceholder = NSAttributedString(string: "Type" ,
//                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
//
        
//        viewTurf.layer.borderWidth = 0.5
//        viewTurf.layer.borderColor = UIColor.lightGray.cgColor
//        txtTurf.attributedPlaceholder = NSAttributedString(string: "Turf" ,
//                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
//        viewSize.layer.borderWidth = 0.5
//        viewSize.layer.borderColor = UIColor.lightGray.cgColor
//        txtSize.attributedPlaceholder = NSAttributedString(string: "Size" ,
//                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        self.btnContact.setImage(UIImage(named: "GroupM"), for: .normal)
        self.lblContact.textColor = self.hexStringToUIColor(hex: "#6FC13A")
        
        self.GetContactDetails()
        

        
//        self.txtSize.didSelect{(selectedText , index ,id) in
//            print("selectedText ----- ",selectedText)
//            if self.sArrayType.count>0{
//                print("id ----- ",self.sArraySizeId[index])
//
//                self.txtSize.text = self.sArraySize[index]
//            }
//        }
//        self.txtType.didSelect{(selectedText , index ,id) in
//            print("selectedText ----- ",selectedText)
//            if self.sArrayType.count>0{
//                print("id ----- ",self.sArrayTypeId[index])
//
//                self.txtType.text = self.sArrayType[index]
//            }
//        }
//        self.txtTurf.didSelect{(selectedText , index ,id) in
//            print("selectedText ----- ",selectedText)
//            if self.sArrayTurf.count>0{
//                print("id ----- ",self.sArrayTurfId[index])
//
//                self.txtTurf.text = self.sArrayTurf[index]
//            }
//        }
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
        
        var contentInset:UIEdgeInsets = self.scroll.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scroll.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scroll.contentInset = contentInset
    }
    
    
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        print(textView.text as Any); //the textView parameter is the textView where text was changed
       }
    func textViewDidBeginEditing(_ textView: UITextView) {

        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.white
        }
        else
        {
            print("You edit myTextField")
            self.viewTxtType.layer.borderColor = UIColor.white.cgColor
            self.viewTxtType.layer.borderWidth = 1
            self.imgValidationTxtType.isHidden = true
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {

        if textView == txtType {

            textView.text = "message"
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtFirstName || textField == txtLastName {
           
                    do {
                        if textField.tag == 0 || textField.tag == 2
                        {
                            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
                            if regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) != nil {
                                return false
                            }
                        }
                       
                    }
                    catch {
                        print("ERROR")
                    }
        }
                return true
        }
    
    @objc func cancelNumberPad() {
           //Cancel with number pad
           txtMobileNumber.resignFirstResponder()
        txtType.resignFirstResponder()
       }
       @objc func doneWithNumberPad() {
           //Done with number pad
        txtMobileNumber.resignFirstResponder()
        txtType.resignFirstResponder()

       }
    
    @IBAction func ActionLetsDoIt(_ sender: Any)
    {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "ListMyPitchDertailsViewController") as! ListMyPitchDertailsViewController
        self.navigationController?.pushViewController(next, animated: false)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func GetContactDetails(){
        self.view.activityStartAnimating()
       
        let loginURL = Constants.baseURL+Constants.ContactURL
        print("loginURL",loginURL)
        AF.request(loginURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
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
                    self.contactResponseModel = ContactResponseModel(response)
                    self.contact_Data_Main = self.contactResponseModel?.contact_Data_Main
                    
                    let statusCode = Int((self.contactResponseModel?.httpcode)!)
                    if statusCode == 200
                    {
                             
                            self.lblPhoneNumber.text = self.contact_Data_Main?.phone_number
                            self.pitch_turfs_data = self.contact_Data_Main?.pitch_turfs_data
                            self.pitch_types_data = self.contact_Data_Main?.pitch_types_data
                            self.pitch_sizes_Data = self.contact_Data_Main?.pitch_sizes_Data
                        
                        for item in self.pitch_turfs_data!
                        {
                            self.sArrayTurf.append(item.turf_name!)
                            self.sArrayTurfId.append(item.id!)
                        }
                        for item in self.pitch_types_data!
                        {
                            self.sArrayType.append(item.type_name!)
                            self.sArrayTypeId.append(item.id!)

                        }
                        for item in self.pitch_sizes_Data!
                        {
                            self.sArraySize.append(item.size_name!)
                            self.sArraySizeId.append(item.id!)

                        }
//                        self.txtSize.optionArray = self.sArraySize
//                        self.txtType.optionArray = self.sArrayType
//                        self.txtTurf.optionArray = self.sArrayTurf
//
                            self.view.activityStopAnimating()
                                    
                    }
                    if statusCode == 400
                    {
                        self.view.activityStopAnimating()
//                        self.showToast(message: (self.contactResponseModel?.message)!)
                        self.presentWindow?.makeToast(message: (self.contactResponseModel?.message)!, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                    }
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                    
                    self.view.activityStopAnimating()

                }
            }
        }
    }
    func SaveContactDetails(){
        self.view.activityStartAnimating()
        var postDict = Dictionary<String,String>()
        //mobilevalue.dropFirst(1)
        postDict = [
            "access_token":sharedData.getAccessToken(),
            "fname":txtFirstName.text!,
            "lname":txtLastName.text!,
            "isd_code":"+971",
            "phone":txtMobileNumber.text!,
            "email":txtEmail.text!,
            "Message":txtEmail.text!


        ]
        
        let loginURL = Constants.baseURL+Constants.SaveContactURL
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
                    self.contactSaveResponseModel = ContactSaveResponseModel(response)
                    self.contact_SaveData_Main = self.contactSaveResponseModel?.contact_SaveData_Main
                    
                    let statusCode = Int((self.contactSaveResponseModel?.httpcode)!)
//                    self.showToast(message: (self.contact_SaveData_Main?.message)!)
                    self.presentWindow?.makeToast(message: "Contact details submitted successfully", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.


                    if statusCode == 200
                    {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {

                        let next = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                        self.navigationController?.pushViewController(next, animated: false)
                        }
                            self.view.activityStopAnimating()
                                    
                    }
                    if statusCode == 400
                    {
                        self.view.activityStopAnimating()
//                        self.showToast(message: (self.contactResponseModel?.message)!)
                        self.presentWindow?.makeToast(message: (self.contactResponseModel?.message)!, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                    }
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                    
                    self.view.activityStopAnimating()

                }
            }
        }
    }
    
    @IBAction func ActionContactSumbit(_ sender: Any)
    {
        if Reachability.isConnectedToNetwork()
        {
            if txtFirstName.text?.count == 0
            {
                self.viewFirstName.layer.borderWidth = 1
                self.viewFirstName.layer.borderColor = UIColor.red.cgColor
                self.imgVAlidationTxtFirstName.isHidden = false
//                self.showToast(message: "Please Enter First Name")
                self.presentWindow?.makeToast(message: "Please Enter First Name", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

            }
//            else if txtLastName.text?.count == 0
//            {
//                self.viewtxtLastName.layer.borderWidth = 1
//                self.viewtxtLastName.layer.borderColor = UIColor.red.cgColor
//                self.imgValidationTxtLastName.isHidden = false
////                self.showToast(message: "Please Enter Last Name")
//                self.presentWindow?.makeToast(message: "Please Enter Last Name", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.
//
//            }
//
            else if txtMobileNumber.text?.count == 0
            {
                self.viewMobileNumber.layer.borderWidth = 1
                self.viewMobileNumber.layer.borderColor = UIColor.red.cgColor
                self.imgValidationTxtMobileNumber.isHidden = false
//                self.showToast(message: "Please Enter Mobile Number")
                self.presentWindow?.makeToast(message: "Please Enter Mobile Number", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

            }
            else if txtEmail.text?.count == 0
            {
                self.viewEmail.layer.borderWidth = 1
                self.viewEmail.layer.borderColor = UIColor.red.cgColor
                self.imgValidationTxtEmail.isHidden = false
//                self.showToast(message: "Please Enter Email")
                self.presentWindow?.makeToast(message: "Please Enter Email", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.


            }
            else
            if !(txtEmail.text!.isValidEmail())
            {
                    self.showToast(message:Constants.invalidEmailMSG)
                self.viewEmail.layer.borderWidth = 1
                self.viewEmail.layer.borderColor = UIColor.red.cgColor
                self.imgValidationTxtEmail.isHidden = false
                    return
                }
            else if txtType.text?.count == 0
            {
//                self.viewTxtType.layer.borderWidth = 1
//                self.viewTxtType.layer.borderColor = UIColor.red.cgColor
//                self.imgValidationTxtType.isHidden = false
//                self.showToast(message: "Please enter message")
                self.presentWindow?.makeToast(message: "Please enter message", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

            }
//            else if txtSize.text?.count == 0
//            {
//                self.viewSize.layer.borderWidth = 1
//                self.viewSize.layer.borderColor = UIColor.red.cgColor
//                self.imgValidationSize.isHidden = false
//                self.showToast(message: "Please Enter your message")
//            }
//            else if txtTurf.text?.count == 0
//            {
//                self.viewTurf.layer.borderWidth = 1
//                self.viewTurf.layer.borderColor = UIColor.red.cgColor
//                self.imgValidationTurf.isHidden = false
//                self.showToast(message: "Please Enter Pitch Turf")
//            }
            else
            {
                self.SaveContactDetails()
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
            if textField == txtFirstName
            {
                print("You edit myTextField")
                self.viewFirstName.layer.borderColor = UIColor.white.cgColor
                self.viewFirstName.layer.borderWidth = 1
                self.imgVAlidationTxtFirstName.isHidden = true
            }
        else if textField == txtLastName {
            print("You edit myTextField")
            self.viewtxtLastName.layer.borderColor = UIColor.white.cgColor
            self.viewtxtLastName.layer.borderWidth = 1
            self.imgValidationTxtLastName.isHidden = true
        }
        else if textField == txtMobileNumber {
            print("You edit myTextField")
            self.viewMobileNumber.layer.borderColor = UIColor.white.cgColor
            self.viewMobileNumber.layer.borderWidth = 1
            self.imgValidationTxtMobileNumber.isHidden = true
        }
        else if textField == txtEmail {
            print("You edit myTextField")
            self.viewEmail.layer.borderColor = UIColor.white.cgColor
            self.viewEmail.layer.borderWidth = 1
            self.imgValidationTxtEmail.isHidden = true
        }
//        else if textField == txtType
//        {
//            print("You edit myTextField")
//            self.viewTxtType.layer.borderColor = UIColor.white.cgColor
//            self.viewTxtType.layer.borderWidth = 1
//            self.imgValidationTxtType.isHidden = true
//        }
//        else if textField == txtTurf
//        {
//            print("You edit myTextField")
//            self.viewTurf.layer.borderColor = UIColor.white.cgColor
//            self.viewTurf.layer.borderWidth = 1
//            self.imgValidationTurf.isHidden = true
//        }
//        else if textField == txtSize {
//            print("You edit myTextField")
//            self.viewSize.layer.borderColor = UIColor.white.cgColor
//            self.viewSize.layer.borderWidth = 1
//            self.imgValidationSize.isHidden = true
//        }
        }
}
