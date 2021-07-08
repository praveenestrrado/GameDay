//
//  ListMyPitchDertailsViewController.swift
//  GameDay
//
//  Created by MAC on 08/01/21.
//

import UIKit
import PhotosUI
import Photos
import MobileCoreServices
import ImageSlideshow
import Alamofire
import SwiftyJSON
import CoreLocation

class ListMyPitchDertailsViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate, UIGestureRecognizerDelegate,CLLocationManagerDelegate {
    var presentWindow : UIWindow?

    @IBOutlet var pitchTufCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet var pitchSizeCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet var image3: UIImageView!
    @IBOutlet var image2: UIImageView!
    @IBOutlet var image1: UIImageView!
    @IBOutlet var txtPitchprice: UITextField!
    @IBOutlet weak var txtOrganizationName: UITextField!
    @IBOutlet weak var viewOrganizationName: UIView!
    @IBOutlet weak var btnIagree: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewMobileNumber: UIView!
    @IBOutlet weak var viewLastName: UIView!
    @IBOutlet weak var viewFirstName: UIView!
    @IBOutlet weak var viewSub: UIView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var viewPrice: UIView!
    @IBOutlet weak var lblImageName3: UILabel!
    @IBOutlet weak var lblImageName2: UILabel!
    @IBOutlet weak var lblImageName1: UILabel!
    @IBOutlet weak var lblUploadImages: UILabel!
    @IBOutlet weak var viewUploadImages: UIView!
    @IBOutlet weak var pitchTurfCollectionView: UICollectionView!
    @IBOutlet weak var pitchsizeCollectionView: UICollectionView!
    @IBOutlet weak var btnOutDoor: UIButton!
    @IBOutlet weak var btnIndoor: UIButton!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var lblListMyPitch: UILabel!
    @IBOutlet weak var lblPitchDetails: UILabel!
    @IBOutlet weak var imgSlideShow: ImageSlideshow!
    var timage = UIImage()

    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var viewBase1: UIView!
    var weeks : Int?
    var sLatitude : String?
    var sLongitude : String?
    var iDurationId : Int?
    var iPitchSize_id : Int?
    var iPitchTurf_Id : Int?
    var iPitchType_Id : Int?
    var iImageSelection : Int?

    var forgotPasswordResponseModel : ForgotPasswordResponseModel?

    let sharedData = SharedDefault()
    var filter_datas: filter_data?
    var filter_masters: filter_master?
    var durations: [Durations]?
    var pitch_sizes: [Pitch_sizes]?
    var pitch_turfs: [Pitch_turfs]?
    var pitch_types: [Pitch_typess]?
    var pitch_list = [Pitch_list]()
    var filterResponseModel : FilterResponseModel?
    var filterData : FilterData?
    var bAgree = Bool()
    var user_details: User_details?
    var Iimage_list: [image_list]?
    var arraySize = ["Any","5 A Side","6 A Side", "7 A side","8 A Side", "9 A side","10 A Side", "11 A side"]
    var arrayTurf = ["Field Turf", "Astro Turf","Sprint Turf"]
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    let locationManager = CLLocationManager()

    var sCurrentLattitude = Double()
    var sCurrentLongitude = Double()
    var firstImgData:String = String()
    var secondImgData:String = String()
    var thirdImgData:String = String()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locManager.requestWhenInUseAuthorization()

        self.iPitchType_Id = 0
        self.iImageSelection  = 0
        if(CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        presentWindow = UIApplication.shared.keyWindow
        UIView.hr_setToastThemeColor(color: UIColor.white)
        UIView.hr_setToastFontColor(color: self.hexStringToUIColor(hex: "#6fc13a"))
        UIView.hr_setToastFontName(fontName: "TTOctosquares-Medium")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        
        txtPitchprice.attributedPlaceholder = NSAttributedString(string: "Price",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        
        
        
        
        
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
        
        self.sLatitude = String(self.sCurrentLattitude)
        self.sLongitude = String(self.sCurrentLongitude)
        
        self.getAddressFromLatLon(pdblLatitude: String(self.sCurrentLattitude), withLongitude: String(self.sCurrentLongitude))
        
        // Disable swipe-to-pop gesture
                navigationController?.interactivePopGestureRecognizer?.delegate = self
                navigationController?.interactivePopGestureRecognizer?.isEnabled = false

                // Detect swipe gesture to load next entry
//        self.viewBase1.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipeNextEntry)))
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipeNextEntry)))

        bAgree = false
        
        btnLocation.layer.borderWidth = 1.0
        btnLocation.layer.borderColor = UIColor.lightGray.cgColor
        viewPrice.layer.borderWidth = 1.0
        viewPrice.layer.borderColor = UIColor.lightGray.cgColor
        
        viewUploadImages.layer.borderWidth = 1.0
        viewUploadImages.layer.borderColor = UIColor.lightGray.cgColor
        
        viewFirstName.layer.borderWidth = 1.0
        viewFirstName.layer.borderColor = UIColor.lightGray.cgColor
        
        viewOrganizationName.layer.borderWidth = 1.0
        viewOrganizationName.layer.borderColor = UIColor.lightGray.cgColor
        
        viewLastName.layer.borderWidth = 1.0
        viewLastName.layer.borderColor = UIColor.lightGray.cgColor

        viewMobileNumber.layer.borderWidth = 1.0
        viewMobileNumber.layer.borderColor = UIColor.lightGray.cgColor
        
        viewEmail.layer.borderWidth = 1.0
        viewEmail.layer.borderColor = UIColor.lightGray.cgColor

        viewSub.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively
        viewSub.layer.cornerRadius = 35
        
        viewBase1.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively
        viewBase1.layer.cornerRadius = 35
        
        scroll.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively
        scroll.layer.cornerRadius = 35
        
        self.GetFilterMasterListDetails()
        
        let pageIndicator = UIPageControl()
        pageIndicator.frame = CGRect(x: pageIndicator.frame.origin.x, y: pageIndicator.frame.origin.y, width: pageIndicator.frame.size.width, height: 0)
        pageIndicator.currentPageIndicatorTintColor = UIColor.white
        pageIndicator.pageIndicatorTintColor = UIColor.lightGray
        pageIndicator.layer.cornerRadius = 10.0
        pageIndicator.sizeToFit()
        imgSlideShow.pageIndicator = pageIndicator

        imgSlideShow.contentScaleMode = .scaleToFill
        imgSlideShow.slideshowInterval = 2.0
        imgSlideShow.setImageInputs([ImageSource(image: UIImage(named: "ground-1")!)])
        
        btnIndoor.layer.borderWidth = 1.0
        btnIndoor.layer.borderColor = UIColor.lightGray.cgColor
        btnIndoor.backgroundColor = UIColor.clear
        btnIndoor.setTitleColor(UIColor.black, for: .normal)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        self.view.addGestureRecognizer(tap)
        txtFirstName.attributedPlaceholder = NSAttributedString(string: "First Name",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        txtLastName.attributedPlaceholder = NSAttributedString(string: "Last Name",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        txtMobileNumber.attributedPlaceholder = NSAttributedString(string: "Mobile Number",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])

        txtEmail.attributedPlaceholder = NSAttributedString(string: "Email",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])

        
        txtOrganizationName.attributedPlaceholder = NSAttributedString(string: "Organization Name",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])

        btnOutDoor.layer.borderWidth = 1.0
        btnOutDoor.layer.borderColor = UIColor.lightGray.cgColor
        btnIndoor.setTitleColor(UIColor.white, for: .normal)
        
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker))]
        numberToolbar.sizeToFit()
        
        self.txtMobileNumber.inputAccessoryView = numberToolbar
        self.txtPitchprice.inputAccessoryView = numberToolbar
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func cancelPicker() {
        
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
    
    @objc func donePicker()
    {
        view.endEditing(true)
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        self.sCurrentLattitude = location.coordinate.latitude
        self.sCurrentLongitude = location.coordinate.longitude
        self.locationManager.stopUpdatingLocation()
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
    @IBAction func ActioIAgree(_ sender: UIButton)
    {
        if bAgree == false
        {
            btnIagree.setImage(UIImage(named: "CheckMark"), for: .normal)
            bAgree = true
        }
        else
        {
            btnIagree.setImage(UIImage(named: "UnCheckBox"), for: .normal)
            bAgree = false
        }
    }
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func btnUploadImages(_ sender: Any)
    {
        if self.iImageSelection! < 4
        {
            self.iImageSelection = self.iImageSelection! + 1
            
            self.showAlert()
        }
        else
        {
//            self.showToast(message: "Maximum 3 Images can upload")
            presentWindow?.makeToast(message: "Maximum 3 Images can upload", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

        }
        
    }
    @IBAction func ActionBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func ActionLocation(_ sender: Any) {
    }
    @IBAction func ActionSubmit(_ sender: Any)
    {
//        if self.iPitchType_Id == 0 || iPitchType_Id == nil
//        {
//            self.showToast(message: "Please select pitch type")
//        }
//       else  if self.iPitchSize_id == 0 || iPitchSize_id == nil
//        {
//            self.showToast(message: "Please select pitch size")
//        }
//        else if self.iPitchTurf_Id == 0 || iPitchTurf_Id == nil
//        {
//            self.showToast(message: "Please select pitch turf")
//        }
//       else
        if txtPitchprice.text?.count == 0
        {
//            self.showToast(message: "Enter pitch price")
            presentWindow?.makeToast(message: "Enter pitch price", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

        }
        
        else if txtFirstName.text?.count == 0
        {
//            self.showToast(message: "Enter first name")
            presentWindow?.makeToast(message: "Enter first name", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

        }
        else if txtLastName.text?.count == 0
        {
//            self.showToast(message: "Enter last name")
            presentWindow?.makeToast(message: "Enter last name", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.


        }
        else if txtEmail.text?.count == 0
        {
//            self.showToast(message: "Enter email")
            presentWindow?.makeToast(message: "Enter email", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.


        }
        else if txtOrganizationName.text?.count == 0
        {
//            self.showToast(message: "Please Enter Organization Name")
            presentWindow?.makeToast(message: "Please Enter Organization Name", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

        }
        else if txtMobileNumber.text?.count == 0
        {
//            self.showToast(message: "Please Enter Mobile Number")
            presentWindow?.makeToast(message: "Please Enter Mobile Number", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

        }
        else if txtMobileNumber.text!.count < 7
        {

//            self.showToast(message:Constants.phoneLengthMsg)
            presentWindow?.makeToast(message: Constants.phoneLengthMsg, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.


        }
        else if txtMobileNumber.text!.count > 15
        {

//            self.showToast(message:Constants.phoneLengthMsg2)
            presentWindow?.makeToast(message: Constants.phoneLengthMsg2, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.



        }

        else if !(txtEmail.text!.isValidEmail())
        {
//            self.showToast(message:Constants.invalidEmailMSG)
            presentWindow?.makeToast(message: Constants.invalidEmailMSG, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.


        }
        else if !bAgree
        {
//            self.showToast(message:"please agree to the terms & conditions")
            presentWindow?.makeToast(message: "Please agree to the terms & conditions", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.


        }
        else
        {
            self.AddPitchDetails()
        }
       
    }
    
    
    @IBAction func ActionIndoor(_ sender: UIButton)
    {
        btnIndoor.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
        btnIndoor.setTitleColor(UIColor.black, for: .normal)
        self.iPitchType_Id = self.btnIndoor.tag
        
        btnOutDoor.backgroundColor = UIColor.clear
        btnOutDoor.setTitleColor(UIColor.white, for: .normal)
        
    }
    @IBAction func ActionOutdoor(_ sender: UIButton)
    {
        btnOutDoor.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
        btnOutDoor.setTitleColor(UIColor.black, for: .normal)
        self.iPitchType_Id = self.btnOutDoor.tag
        btnIndoor.backgroundColor = UIColor.clear
        btnIndoor.setTitleColor(UIColor.white, for: .normal)
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
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var countVar:Int = 0
        if collectionView == pitchsizeCollectionView
        {
            countVar = self.pitch_sizes?.count ?? 0
        }
        else
        {
            countVar = self.pitch_turfs?.count ?? 0

        }
        
        return countVar
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
    
    
    
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if collectionView == pitchsizeCollectionView
        {

            let homeTypeCollectionViewCell1 = pitchsizeCollectionView.dequeueReusableCell(withReuseIdentifier: "MyListPitchSizeCollectionViewCell", for: indexPath as IndexPath) as! MyListPitchSizeCollectionViewCell

            homeTypeCollectionViewCell1.btnSize.addTarget(self, action: #selector(DurationSelection(_:)), for: .touchUpInside)

            homeTypeCollectionViewCell1.btnSize.tag = indexPath.row
            homeTypeCollectionViewCell1.btnSize.backgroundColor = UIColor.clear
            homeTypeCollectionViewCell1.btnSize.layer.borderColor = UIColor.lightGray.cgColor
            homeTypeCollectionViewCell1.btnSize.layer.borderWidth = 0.5
            homeTypeCollectionViewCell1.btnSize.setTitleColor(.white, for: .normal)

            homeTypeCollectionViewCell1.btnSize.setTitle(self.pitch_sizes![indexPath.row].size_name, for: .normal)

//            if indexPath.row == 0
//            {
//                homeTypeCollectionViewCell1.btnSize.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
//                homeTypeCollectionViewCell1.btnSize.setTitleColor(.black, for: .normal)
//                homeTypeCollectionViewCell1.btnSize.layer.borderColor = UIColor.clear.cgColor
//
//            }

            cell = homeTypeCollectionViewCell1

           
            }
else  if collectionView == pitchTurfCollectionView
{


    let homeTypeCollectionViewCell1 = pitchTurfCollectionView.dequeueReusableCell(withReuseIdentifier: "MyListPitchTurfCollectionViewCell", for: indexPath as IndexPath) as! MyListPitchTurfCollectionViewCell

    homeTypeCollectionViewCell1.btnTurf.addTarget(self, action: #selector(Typeselection(_:)), for: .touchUpInside)

    homeTypeCollectionViewCell1.btnTurf.tag = indexPath.row

    homeTypeCollectionViewCell1.btnTurf.backgroundColor = UIColor.clear
    homeTypeCollectionViewCell1.btnTurf.layer.borderColor = UIColor.lightGray.cgColor
    homeTypeCollectionViewCell1.btnTurf.layer.borderWidth = 0.5
    homeTypeCollectionViewCell1.btnTurf.setTitleColor(.white, for: .normal)
    homeTypeCollectionViewCell1.btnTurf.setTitle(self.pitch_turfs![indexPath.row].turf_name, for: .normal)
    
//    if indexPath.row == 0
//    {
//        homeTypeCollectionViewCell1.btnTurf.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
//        homeTypeCollectionViewCell1.btnTurf.setTitleColor(.black, for: .normal)
//        homeTypeCollectionViewCell1.btnTurf.layer.borderColor = UIColor.clear.cgColor
//
//    }
    cell = homeTypeCollectionViewCell1

    }

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
       
        let noOfCellsInRow = 3   //number of column you want
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        return CGSize(width: size, height: 40)
        

    }
    
    
    @objc func DurationSelection(_ sender: UIButton)
    {

      
        
        print(sender.tag)
        for indexs in 0..<self.pitch_sizes!.count
        {

         print(indexs)
            
            if indexs == sender.tag
            {
                let index = IndexPath(row: sender.tag, section: 0)
                let cell: MyListPitchSizeCollectionViewCell = self.pitchsizeCollectionView.cellForItem(at: index) as! MyListPitchSizeCollectionViewCell
                cell.btnSize.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
                cell.btnSize.setTitleColor(.black, for: .normal)
                self.iPitchSize_id = self.pitch_sizes![sender.tag].id

            }
//           else if indexs < 3 && sender.tag < 3
            
            else

            {
                let index = IndexPath(row: indexs, section: 0)
                let cell: MyListPitchSizeCollectionViewCell = self.pitchsizeCollectionView.cellForItem(at: index) as! MyListPitchSizeCollectionViewCell
                cell.btnSize.backgroundColor = UIColor.clear
                cell.btnSize.setTitleColor(.white, for: .normal)
            }

        
        }
        
        
        
    }
    @objc func Typeselection(_ sender: UIButton)
    {
       
     
        
        
        print(sender.tag)
        for indexs in 0..<self.pitch_turfs!.count
        {

         print(indexs)
            
            if indexs == sender.tag
            {
                let index = IndexPath(row: sender.tag, section: 0)
                let cell: MyListPitchTurfCollectionViewCell = self.pitchTurfCollectionView.cellForItem(at: index) as! MyListPitchTurfCollectionViewCell
                cell.btnTurf.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
                cell.btnTurf.setTitleColor(.black, for: .normal)
                self.iPitchTurf_Id = self.pitch_turfs![sender.tag].id

            }
//            else  if indexs < 3 && sender.tag <= 2
            else

            {
                let index = IndexPath(row: indexs, section: 0)
                let cell: MyListPitchTurfCollectionViewCell = self.pitchTurfCollectionView.cellForItem(at: index) as! MyListPitchTurfCollectionViewCell
                cell.btnTurf.backgroundColor = UIColor.clear
                cell.btnTurf.setTitleColor(.white, for: .normal)
            }

        
        }
        
        
        
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
    @IBAction func ActionMap(_ sender: Any)
    {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        self.navigationController?.pushViewController(next, animated: true)
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

//        let sImageName = String(self.iImageSelection!) + ". " + "PitchImage"
//        self.saveImage(imageName: sImageName, image: pImage as! UIImage)
        if self.iImageSelection == 1
        {
            self.image1.image = (pImage as! UIImage)
            self.firstImgData = convertImageToBase_64(image: timage.jpeg(UIImage.JPEGQuality(rawValue: 0.0)!)!)
        }
        if self.iImageSelection == 2
        {
            self.image2.image = (pImage as! UIImage)
            self.secondImgData = convertImageToBase_64(image: timage.jpeg(UIImage.JPEGQuality(rawValue: 0.0)!)!)
        }
        if self.iImageSelection == 3
        {
            self.image3.image = (pImage as! UIImage)
            self.thirdImgData = convertImageToBase_64(image: timage.jpeg(UIImage.JPEGQuality(rawValue: 0.0)!)!)

        }
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
    
    func GetFilterMasterListDetails()
    {
     
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = ["access_token":self.sharedData.getAccessToken(),
                    "master":"1",
                    "offset":"0"

        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.searchPitchURL
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
                    self.filterResponseModel = FilterResponseModel(response)
//
                    self.filter_datas = self.filterResponseModel?.filterData?.filter_datas
                    self.filter_masters = self.filterResponseModel?.filterData?.filter_masters
                    self.durations = self.filter_masters?.durations
                    self.pitch_sizes = self.filter_masters?.pitch_sizes
                    self.pitch_turfs = self.filter_masters?.pitch_turfs
                    self.pitch_types = self.filter_masters?.pitch_types
                    self.user_details = self.filterResponseModel?.filterData?.user_details
                    self.pitch_list = (self.filterResponseModel?.filterData?.pitch_list)!
                    var height:Int?
                    var nHieght:Int?
                    let statusCode = Int((self.filterResponseModel?.httpcode)!)
                    if statusCode == 200{
                        print("registerResponseModel ----- ",self.filterResponseModel)
                        if self.pitch_list.count > 0
                        {
//
                        }

                       
                        if self.pitch_sizes!.count > 0
                        {
                            
                            let q = self.pitch_sizes?.count.quotientAndRemainder(dividingBy: 3)

                            print(q ?? 0)
                            
                            let iSize  = Double(self.pitch_sizes?.count ?? 0) / 3.0
                            
                            if iSize.rounded(.up) == iSize.rounded(.down)
                            {
                                height = Int(q?.quotient ?? 0) * 50
                            }
                            else
                            {
                                nHieght = Int(q?.quotient ?? 0) + 1
                                height = Int(nHieght ?? 0) * 50
                            }
                            self.pitchSizeCollectionViewHeight.constant = CGFloat(height ?? 50)
                            self.pitchsizeCollectionView.reloadData()
                        }
                        if self.pitch_turfs!.count > 0
                        {
                            let q = self.pitch_turfs?.count.quotientAndRemainder(dividingBy: 3)

                            print(q ?? 0)
                            
                            let iSize  = Double(self.pitch_turfs?.count ?? 0) / 3.0
                            
                            if iSize.rounded(.up) == iSize.rounded(.down)
                            {
                                height = Int(q?.quotient ?? 0) * 50
                            }
                            else
                            {
                                nHieght = Int(q?.quotient ?? 0) + 1
                                height = Int(nHieght ?? 0) * 50
                            }
                            self.pitchTufCollectionViewHeight.constant = CGFloat(height ?? 50)
                            self.pitchTurfCollectionView.reloadData()
                        }
                       
                        if self.pitch_types!.count > 0
                        {
                            self.btnIndoor.setTitle(self.pitch_types![0].type_name, for: .normal)
                            self.btnIndoor.tag = self.pitch_types![0].id!
                            
                            self.btnOutDoor.setTitle(self.pitch_types![1].type_name, for: .normal)
                            self.btnOutDoor.tag = self.pitch_types![1].id!
                        }


                        print("Pitch list count:--->", self.pitch_list.count)
                        print("Duration list count:--->", self.durations?.count ?? "0")

                    }
                    if statusCode == 400{

//                        self.showToast(message:(self.filterResponseModel?.message)!)
                        self.presentWindow?.makeToast(message: (self.filterResponseModel?.message)!, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                    }
                    
                    
                    self.view.activityStopAnimating()
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
    
    func AddPitchDetails()
    {
     
        self.view.activityStartAnimating()
        
        var postDict1 = Dictionary<String,String>()
        
        var sAccessToken = self.btnLocation.titleLabel?.text
        if sAccessToken == nil
        {
            sAccessToken = ""
        }
        postDict1 = ["access_token":self.sharedData.getAccessToken(),
                    "location":sAccessToken!,
                    "latitude":self.sLatitude!,
                    "longitude":self.sLongitude!,
                    "pitch_type":String(self.iPitchType_Id ?? 0),
                    "pitch_size":String(iPitchSize_id ?? 0),
                    "turf":String(iPitchTurf_Id ?? 0),
                    "price":self.txtPitchprice.text!,
                    "pitch_image1":firstImgData,
                    "pitch_image2":secondImgData,
                    "pitch_image3":thirdImgData,
                   
                    "fname":self.txtFirstName.text!,
                    "lname":self.txtLastName.text!,
                    "isd_code":"971",
                    "phone":self.txtMobileNumber.text!,
                    "email":self.txtEmail.text!,
                    "pitch_name":txtOrganizationName.text!
        ]
        
        print("PostData: ",postDict1)
        let loginURL = Constants.baseURL+Constants.addPitchUrl
        print("loginURL",loginURL)
        
        AF.request(loginURL, method: .post, parameters: postDict1, encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
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

                    let statusCode = Int((self.forgotPasswordResponseModel?.httpcode)!)
                    if statusCode == 200
                    {
                        self.showToast(message:(self.forgotPasswordResponseModel?.message)!)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            
                        let next = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                        self.navigationController?.pushViewController(next, animated: false)
                            
                        }
                    }
                    if statusCode == 400{

//                        self.showToast(message:(self.forgotPasswordResponseModel?.message)!)
                        self.presentWindow?.makeToast(message: (self.forgotPasswordResponseModel?.message)!, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                    }
                    
                    
                    self.view.activityStopAnimating()
                    
                }
                catch let err
                {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let lat: Double = Double("\(pdblLatitude)")!
            //21.228124
            let lon: Double = Double("\(pdblLongitude)")!
            //72.833770
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = lat
            center.longitude = lon

            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)


            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    let pm = placemarks! as [CLPlacemark]

                    if pm.count > 0 {
                        let pm = placemarks![0]
                        print(pm.country)
                        print(pm.locality)
                        print(pm.subLocality)
                        print(pm.thoroughfare)
                        print(pm.postalCode)
                        print(pm.subThoroughfare)
                        var addressString : String = ""
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }


                        print(addressString)
                        
                        
//                        self.btnLocation.setTitle(addressString, for: .normal)
                  }
            })

        }

    
}
