//
//  PitchDetailsViewController.swift
//  GameDay
//
//  Created by MAC on 30/12/20.
//

import UIKit
import FittedSheets
import Alamofire
import SwiftyJSON
import SDWebImage
import ImageSlideshow

class PitchDetailsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UIGestureRecognizerDelegate ,UICollectionViewDelegateFlowLayout{

    var presentWindow : UIWindow?

    @IBOutlet var collectionAmenityHeight: NSLayoutConstraint!
    @IBOutlet weak var termsLabel: UILabel!
    @IBOutlet weak var viewDiscount: UIView!
    @IBOutlet weak var btnAgreeTermsCondn: UIButton!
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnIAgree: UIButton!
    @IBOutlet weak var btnWeeklyBookingCheckBox: UIButton!
    @IBOutlet weak var btnDiscount: UIButton!
    @IBOutlet weak var btnTime: UIButton!
    @IBOutlet weak var btnDuration: UIButton!
    @IBOutlet weak var btnBooking: UIButton!
    @IBOutlet weak var pitchdetailsCollectionView: UICollectionView!
    @IBOutlet weak var lblBookingDate: UILabel!
    @IBOutlet weak var lblPitchAddress2: UILabel!
    @IBOutlet weak var lblPitchAddres: UILabel!
    @IBOutlet weak var lblOutDoorPitch: UILabel!
    @IBOutlet weak var lblPitchName: UILabel!
    @IBOutlet weak var imgPitch: UIImageView!
    @IBOutlet weak var lblOffValue: UILabel!
    @IBOutlet weak var lblOff: UILabel!
    @IBOutlet weak var btnProceedToPay: UIButton!
    var bChecking:Bool = false
    var bChecking1:Bool = false
    let sharedData = SharedDefault()
    var iCheckingAgree:Int = 0

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
    
    var pitchDetailsResponseModel : PitchDetailsResponseModel?
    var sdImageSource = [SDWebImageSource]()

    var pitch_detail: Pitch_detail?
    var pitch_detail_datas: Pitch_detail_data?
    var available_durations = [Available_durations]()
    var available_timeslots = [Available_timeslots]()
    var extra_features = [Extra_features]()
    var image_list = [Image_list]()



    var iSelectedBookingId = Int()
    var sArrayTimeSlot = [String]()
    var sArrayImageGetted = [String]()
    
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
        
        if (self.iNo_of_Weeks == 0 ||  self.iNo_of_Weeks == nil ) && self.iBookType == 0
        {
            self.btnBooking.setTitle("Single Booking", for: .normal)
        }
        else if (self.iNo_of_Weeks == 0 ||  self.iNo_of_Weeks == nil ) && self.iBookType == 1
        {
            self.btnBooking.setTitle("Weekly Booking", for: .normal)

        }
        else
        {
            self.btnBooking.setTitle(String(iNo_of_Weeks!) + " weeks", for: .normal)

        }
        
        
        
        if self.sBookingID?.count == 0
        {
            let sStartTimeGetted = self.timeConversion12(time24: (self.sStartTime)!)
             let sEndTimeGetted = self.timeConversion12AMPM(time24: (self.sEndTime)!)
            self.btnTime.setTitle(sStartTimeGetted + " - " + sEndTimeGetted, for:.normal)

        }
        else
        {
            let sStartTimeGetted = self.timeConversion12FromBookingDetails(time24: (self.sStartTime)!)
             let sEndTimeGetted = self.timeConversion12AMPMFromBookingDetails(time24: (self.sEndTime)!)
            self.btnTime.setTitle(sStartTimeGetted + " - " + sEndTimeGetted, for:.normal)
        }
        self.btnDuration.setTitle(self.sDuration! + " Min", for: .normal)
        
//        if self.sharedData.getAccessToken().count > 0
//        {
            self.GetPitchListDetails()

//        }
        
        viewDiscount.layer.borderWidth = 1
        viewDiscount.layer.borderColor = UIColor.lightGray.cgColor
        btnBooking.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
        btnDuration.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
        btnTime.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
        btnProceedToPay.backgroundColor = hexStringToUIColor(hex: "#6FC13A")

        termsLabel.underline()
        // Do any additional setup after loading the view.
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
    
    @IBAction func ActionCheckBox1(_ sender: Any)
    {
        if !bChecking
        {
            btnWeeklyBookingCheckBox.setImage(UIImage(named: "CheckMark"), for: .normal)
            bChecking = true
        }
        else
        {
            btnWeeklyBookingCheckBox.setImage(UIImage(named: "UnCheckBox"), for: .normal)
            bChecking = false
        }
        
    }
    @IBAction func ActionCheckBox2(_ sender: Any) {
        
        if !bChecking1
        {
            btnIAgree.setImage(UIImage(named: "CheckMark"), for: .normal)
            bChecking1 = true
            iCheckingAgree = 1
        }
        else
        {
            btnIAgree.setImage(UIImage(named: "UnCheckBox"), for: .normal)
            bChecking1 = false
            iCheckingAgree = 2
        }
    }
    
    @IBAction func ActionTermsAndCondn(_ sender: Any) {
    }
    
    @IBAction func ActioProceedToPay(_ sender: Any)
    {
//        let storyboard = UIStoryboard(name:"Main", bundle: nil)
//        let optionVC = storyboard.instantiateViewController(withIdentifier: "LoginRegisterPopUpViewController")
//        let options = SheetOptions(shrinkPresentingViewController: false)
//        let sheetController = SheetViewController(controller: optionVC, sizes: [.fixed(250)], options: options)
//        sheetController.allowPullingPastMaxHeight = false
//        sheetController.cornerRadius = 20
//        sheetController.didDismiss = { _ in
//            print("Sheet dismissed")
//        }
//        self.present(sheetController, animated: true, completion: nil)

        
        if iCheckingAgree > 0
        {
           
            self.presentWindow?.makeToast(message: "Your booking details added successfully", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0)
            {
        if self.sharedData.getAccessToken().count == 0
        {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "LoginOrRegisterViewController") as! LoginOrRegisterViewController
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
        else
        {
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
        }
        else
        {
//            self.showToast(message: "Please accept terms and conditions")
            presentWindow?.makeToast(message: "Please accept the terms and conditions", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

        }
        
//        let next = self.storyboard?.instantiateViewController(withIdentifier: "LoginRegisterPopUpViewController") as! LoginRegisterPopUpViewController
//        let options1 = SheetOptions(shrinkPresentingViewController: false)
//        let sheetController1 = SheetViewController(controller: next, sizes: [.fixed(250)], options: options1)
//        sheetController1.allowPullingPastMaxHeight = false
//        sheetController1.cornerRadius = 20
//        sheetController1.didDismiss = { _ in
//            print("Sheet dismissed")
//        }
//        self.navigationController?.pushViewController(next, animated: false)
//
        
    }
   

     @IBAction func ActionBAck(_ sender: Any)
     {
        self.navigationController?.popViewController(animated: false)

     }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var countVar:Int = 0
        if collectionView == pitchdetailsCollectionView
        {
            countVar = self.extra_features.count
        }
        
        return countVar
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if collectionView == pitchdetailsCollectionView
        {
            let homeTypeCollectionViewCell = pitchdetailsCollectionView.dequeueReusableCell(withReuseIdentifier: "PitchDetailsCollectionViewCell", for: indexPath as IndexPath) as! PitchDetailsCollectionViewCell

            homeTypeCollectionViewCell.imgDetails.sd_setImage(with: URL(string: self.extra_features[indexPath.row].icon!), placeholderImage: UIImage(named: ""))
            homeTypeCollectionViewCell.lblDetails.text = self.extra_features[indexPath.row].name

            cell = homeTypeCollectionViewCell
      
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
    
    func GetPitchListDetails()
    {
     
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = ["access_token":self.sharedData.getAccessToken(),
                    "pitch_id":String(self.sPitchId!),
                    "duration":String(sDuration!),
                    "start_time":"05:00",
                    "end_time":"23:59",
                    "date":self.sSelectedDate!
                    
        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.pitchDetailsURL
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
                    self.pitchDetailsResponseModel = PitchDetailsResponseModel(response)
//
                    self.pitch_detail = self.pitchDetailsResponseModel?.pitch_detail
                    
                  
                    let statusCode = Int((self.pitchDetailsResponseModel?.httpcode)!)
                    if statusCode == 200{
                        self.pitch_detail_datas = self.pitch_detail?.pitch_detail_datas

                        self.image_list = (self.pitch_detail_datas?.image_list)!
                        self.available_durations = (self.pitch_detail_datas?.available_durations)!
                        self.available_timeslots = (self.pitch_detail_datas?.available_timeslots)!
                        self.extra_features = (self.pitch_detail_datas?.extra_features)!
                        var height:Int?
                        var nHieght:Int?
                      
                        if self.extra_features.count > 0
                        {
                            let q = self.extra_features.count.quotientAndRemainder(dividingBy: 3)

                            print(q ?? 0)
                            
                            let iSize  = Double(self.extra_features.count ?? 0) / 3.0
                            
                            if iSize.rounded(.up) == iSize.rounded(.down)
                            {
                                height = Int(q.quotient ?? 0) * 50
                            }
                            else
                            {
                                nHieght = Int(q.quotient ?? 0) + 1
                                height = Int(nHieght ?? 0) * 50
                            }
                        }
                            self.collectionAmenityHeight.constant = CGFloat(height ?? 50)

                        self.sArrayImageGetted.removeAll()
                        for item in self.image_list
                        {
                            self.sArrayImageGetted.append(item.link!)
                            
                        }
                       
                        self.sdImageSource.removeAll()
                        
                        for img in self.sArrayImageGetted{
                            self.sdImageSource.append(SDWebImageSource(urlString: img)!)
                        }

                        self.imgPitch.sd_setImage(with: URL(string: self.sArrayImageGetted[0]), placeholderImage: UIImage(named: ""))
                        
                        self.lblPitchName.text = self.pitch_detail_datas?.pitch_name
                        self.lblOffValue.text = String((self.pitch_detail_datas?.discount!)!) + "" + (self.pitch_detail_datas?.discount_type)!
                        self.lblOutDoorPitch.text = self.pitch_detail_datas?.pitch_type
                        self.lblPrice.text = String((self.pitch_detail_datas?.rate)!)
                        self.lblCurrency.text = (self.pitch_detail_datas?.currency)! + " / " + (self.pitch_detail_datas?.rate_unit)!
                        self.lblPitchAddres.text = self.pitch_detail_datas?.pitch_size
                        self.lblPitchAddress2.text = self.pitch_detail_datas?.pitch_turf
                        self.lblBookingDate.text = self.sSelectedDate

                       
                        self.pitchdetailsCollectionView.reloadData()
                        self.view.activityStopAnimating()

                    }
                    if statusCode == 400{

//                        self.showToast(message:(self.pitchDetailsResponseModel?.message)!)
                        self.presentWindow?.makeToast(message: (self.pitchDetailsResponseModel?.message)!, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                    }
                    
                    
                    self.view.activityStopAnimating()
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    func timeConversion12FromBookingDetails(time24: String) -> String {
        var dateAsString = time24
        var df = DateFormatter()
        df.dateFormat = "HH:mm:ss"

        var date = df.date(from: dateAsString)
        df.dateFormat = "hh"
        if date == nil
        {
             dateAsString = time24
             df = DateFormatter()
            df.dateFormat = "HH:mm"

             date = df.date(from: dateAsString)
            df.dateFormat = "hh"

        }
        let time12 = df.string(from: date!)
        print(time12)
        return time12
    }
    func timeConversion12AMPMFromBookingDetails(time24: String) -> String {
        var dateAsString = time24
        var df = DateFormatter()
        df.dateFormat = "HH:mm:ss"

        var date = df.date(from: dateAsString)
        df.dateFormat = "HH:mm"
        
        if date == nil
        {
             dateAsString = time24
             df = DateFormatter()
            df.dateFormat = "HH:mm"

             date = df.date(from: dateAsString)
            df.dateFormat = "hh:mm a"

        }

        let time12 = df.string(from: date!)
        print(time12)
        return time12
    }

    
    func timeConversion12(time24: String) -> String {
        let dateAsString = time24
        let df = DateFormatter()
        df.dateFormat = "HH:mm"

        let date = df.date(from: dateAsString)
        df.dateFormat = "hh"

        let time12 = df.string(from: date!)
        print(time12)
        return time12
    }
    func timeConversion12AMPM(time24: String) -> String {
        let dateAsString = time24
        let df = DateFormatter()
        df.dateFormat = "HH:mm"

        let date = df.date(from: dateAsString)
        df.dateFormat = "hh:mm a"

        let time12 = df.string(from: date!)
        print(time12)
        return time12
    }

}
extension UILabel {
    func underline() {
        if let textString = self.text {
          let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSRange(location: 0, length: attributedString.length))
          attributedText = attributedString
        }
    }
}
