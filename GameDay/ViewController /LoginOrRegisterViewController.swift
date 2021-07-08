//
//  LoginOrRegisterViewController.swift
//  GameDay
//
//  Created by MAC on 04/01/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import ImageSlideshow

class LoginOrRegisterViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UIGestureRecognizerDelegate,UICollectionViewDelegateFlowLayout {
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
    @IBOutlet var collectionAmenityHeight: NSLayoutConstraint!
    var presentWindow : UIWindow?

    let sharedData = SharedDefault()
    var sSelectedDate:String?
    var sBookingID:String?
    var sPitchId:String?
    var pitchDetailsResponseModel : PitchDetailsResponseModel?

    var pitch_detail: Pitch_detail?
    var pitch_detail_datas: Pitch_detail_data?
    var available_durations = [Available_durations]()
    var available_timeslots = [Available_timeslots]()
    var extra_features = [Extra_features]()
    var image_list = [Image_list]()
    var iBookType:Int?
    var iNo_of_Weeks:Int?
    var iTotalAmount:Int?
    var sDuration:String?
    var sDurationId:String?
    var sPitchName:String?
    var sPitchAddress:String?
    var sStartTime:String?
    var sEndTime:String?
    var saveBookingResponseModel:SaveBookingResponseModel?
    var paymentinfo: Paymentinfo?
    var paymentinfoData: PaymentinfoData?
    var saved_cards: [Saved_cards]?
    
    @IBOutlet weak var viewBaseHigh: UIView!
    
    @IBOutlet weak var lbldata: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnRegistration: UIButton!
    @IBOutlet weak var imgBackGround: UIImageView!
    @IBOutlet weak var viewBase: UIView!
    
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
        
        
        
        
        viewDiscount.layer.borderWidth = 1
        viewDiscount.layer.borderColor = UIColor.lightGray.cgColor
        
        
        btnLogin.layer.borderColor = UIColor.white.cgColor
        btnLogin.layer.borderWidth = 0.5
        // Do any additional setup after loading the view.
        viewBase.clipsToBounds = true
        viewBase.layer.cornerRadius = 20
        viewBase.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively
        // Do any additional setup after loading the view.
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        self.viewBaseHigh.addGestureRecognizer(gesture)

       
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

                      
                       
//
//                        self.lblPitchName.text = self.pitch_detail_datas?.pitch_name
//                        self.lblOffValue.text = String((self.pitch_detail_datas?.discount!)!) + "" + (self.pitch_detail_datas?.discount_type)!
//                        self.lblOutDoorPitch.text = self.pitch_detail_datas?.pitch_type
//                        self.lblPrice.text = String((self.pitch_detail_datas?.rate)!)
//                        self.lblCurrency.text = (self.pitch_detail_datas?.currency)! + " / " + (self.pitch_detail_datas?.rate_unit)!
//                        self.lblPitchAddres.text = self.pitch_detail_datas?.pitch_size
//                        self.lblPitchAddress2.text = self.pitch_detail_datas?.pitch_turf
//                        self.lblBookingDate.text = self.sSelectedDate

                       
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
    
    @objc func swipeNextEntry(_ sender: UIPanGestureRecognizer) {
          print("[DEBUG] Pan Gesture Detected")

          if (sender.state == .ended) {
              let velocity = sender.velocity(in: self.view)

              if (velocity.x > 0) { // Coming from left
                self.navigationController?.popViewController(animated: true)

              }
          }
      }
    
    
    
    @objc func checkAction(sender : UITapGestureRecognizer)
    {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "PitchDetailsViewController") as! PitchDetailsViewController
        
        next.sSelectedDate = self.lblBookingDate.text
        next.sBookingID = self.sBookingID
        next.sPitchId = self.sPitchId
        next.iBookType = self.iBookType
        next.iNo_of_Weeks = self.iNo_of_Weeks
        next.sDuration =  self.sDuration
        next.sDurationId = self.sDurationId
        next.sStartTime = self.sStartTime
        next.sEndTime = self.sEndTime
        next.iTotalAmount = iTotalAmount
        
        self.navigationController?.pushViewController(next, animated: false)
        
    }
    
    
    
    func SaveBookingDetails()
    {
     
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = ["access_token":self.sharedData.getAccessToken(),
                    "pitch_id":self.sPitchId!,
                    "date":self.sSelectedDate!,
                    "book_type":String(self.iBookType!),
                    "number_of_week":String(self.iNo_of_Weeks!),
                    "duration":self.sDurationId!,
                    "start_time":self.sStartTime!,
                    "end_time":self.sEndTime!,
                    "booking_amount":String(iTotalAmount!),
                    "total_booking_amount":String(iTotalAmount!),


        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.SaveBookingURL
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
                    self.saveBookingResponseModel = SaveBookingResponseModel(response)
                    self.paymentinfo = self.saveBookingResponseModel?.paymentinfo
                    self.paymentinfoData = self.paymentinfo?.paymentinfoData
                    self.saved_cards = self.paymentinfo?.saved_cards

 
//
                    let statusCode = self.saveBookingResponseModel?.httpcode
                    if statusCode == 200{
//                        print("registerResponseModel ----- ",self.filterResponseModel)
//                        if self.search_results!.count > 0
//                        {
//
//                        }
//                        self.showToast(message:(self.saveBookingResponseModel?.message)!)
                        self.presentWindow?.makeToast(message: (self.saveBookingResponseModel?.message)!, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
                        {
                        
                        let next = self.storyboard?.instantiateViewController(withIdentifier: "BookingConformationViewController") as! BookingConformationViewController
                        self.navigationController?.pushViewController(next, animated: false)
                        
                        }
                    }
                    if statusCode == 400{

//                        self.showToast(message:(self.saveBookingResponseModel?.message)!)
                        self.presentWindow?.makeToast(message: (self.saveBookingResponseModel?.message)!, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                    }
                    
                    
                    self.view.activityStopAnimating()
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
    func UpdateBookingDetails()
    {
     
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = ["access_token":self.sharedData.getAccessToken(),
                    "book_id":self.sBookingID!,
                    "date":self.convertDateFormater(self.sSelectedDate!),
                    "start_time":self.sStartTime!,
                    "end_time":self.sEndTime!



        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.updateBookingURL
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
                    self.saveBookingResponseModel = SaveBookingResponseModel(response)
//                    self.paymentinfo = self.saveBookingResponseModel?.paymentinfo
//                    self.paymentinfoData = self.paymentinfo?.paymentinfoData
//                    self.saved_cards = self.paymentinfo?.saved_cards

 
//
                    let statusCode = self.saveBookingResponseModel?.httpcode
                    if statusCode == 200{
                        
//                        self.showToast(message:(self.saveBookingResponseModel?.message)!)
                        self.presentWindow?.makeToast(message: (self.saveBookingResponseModel?.message)!, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.


                    }
                    if statusCode == 400{

//                        self.showToast(message:(self.saveBookingResponseModel?.message)!)
                        self.presentWindow?.makeToast(message: (self.saveBookingResponseModel?.message)!, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                    }
                    
                    
                    self.view.activityStopAnimating()
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
    func convertDateFormater(_ date: String) -> String
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            let date = dateFormatter.date(from: date)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return  dateFormatter.string(from: date!)

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
//            if indexPath.row == 0
//            {
//                homeTypeCollectionViewCell.imgDetails.image = UIImage(named: "PathIcon")
//                homeTypeCollectionViewCell.lblDetails.text = "Changing Rooms"
//
//            }
//            else if indexPath.row == 1
//            {
//                homeTypeCollectionViewCell.imgDetails.image = UIImage(named: "CarImage")
//                homeTypeCollectionViewCell.lblDetails.text = "Parking Available"
//
//            }
//            else if indexPath.row == 2
//            {
//                homeTypeCollectionViewCell.imgDetails.image = UIImage(named: "FuelIcon")
//                homeTypeCollectionViewCell.lblDetails.text = "Water Provided"
//
//            }

            homeTypeCollectionViewCell.imgDetails.sd_setImage(with: URL(string: self.extra_features[indexPath.row].icon!), placeholderImage: UIImage(named: ""))
            homeTypeCollectionViewCell.lblDetails.text = self.extra_features[indexPath.row].name

            cell = homeTypeCollectionViewCell

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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func ActionRegister(_ sender: Any)
    {
        
        
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
    @IBAction func ActionLoginAsGuest(_ sender: Any)
    {
//        let next = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//        self.navigationController?.pushViewController(next, animated: false)

        
//        self.showToast(message: "Currently not available")
        self.presentWindow?.makeToast(message: "Currently not available", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

//        if self.sBookingID!.count > 0
//        {
//            self.UpdateBookingDetails()
//        }
//        else if self.sBookingID?.count == 0
//        {
//            self.SaveBookingDetails()
//
//        }
//
//
       
        
    }

}
