//
//  InviteViewController.swift
//  GameDay
//
//  Created by MAC on 06/01/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class InviteViewController: UIViewController, UIGestureRecognizerDelegate {
    var presentWindow : UIWindow?

    @IBOutlet weak var btnLetsDoIt: UIButton!
    @IBOutlet weak var lblPichName: UILabel!
    @IBOutlet weak var btnShareLocation: UIButton!
    @IBOutlet weak var lblPichBookingDate: UILabel!
    @IBOutlet weak var lblHeading1: UILabel!
    var iSelectedBookingId = Int()
    let sharedData = SharedDefault()
    var sPitchName:String?
    var sPitchAddress:String?
    var sStartTime:String?
    var sEndTime:String?
    var sBookingDate:String?
    @IBOutlet weak var lblHeadinggggg: UILabel!
    let mainString = "No fun to play alone so invite your crew to join your game!"
    let stringToColor = "invite"
    
    var bookingDetailsResponseModel:BookingDetailsResponseModel?
    var booking_list_data: booking_list_Data?
    var bookingDetails_lists:bookingDetails_list?
    var bookingpitchdata: Bookingpitchdata?
    var bookingimage_list: [Bookingimage_list]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presentWindow = UIApplication.shared.keyWindow
        UIView.hr_setToastThemeColor(color: UIColor.white)
        UIView.hr_setToastFontColor(color: self.hexStringToUIColor(hex: "#6fc13a"))
        UIView.hr_setToastFontName(fontName: "TTOctosquares-Medium")
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.btnLetsDoIt.layer.borderColor = UIColor.white.cgColor
        self.btnLetsDoIt.layer.borderWidth = 1
        // Do any additional setup after loading the view.
        // Disable swipe-to-pop gesture
                navigationController?.interactivePopGestureRecognizer?.delegate = self
                navigationController?.interactivePopGestureRecognizer?.isEnabled = false

                // Detect swipe gesture to load next entry
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipeNextEntry)))
        
        var range = (mainString as NSString).range(of: stringToColor)

        let attributedString = NSMutableAttributedString(string:mainString)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white , range: range)

         self.lblHeadinggggg.attributedText = attributedString
        
        self.FetchBookingDetails()
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
    
    @IBAction func BookAnotheGame(_ sender: Any) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(next, animated: false)
    }
    
    @IBAction func ACtionDoIt(_ sender: Any)
    {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "ContentShareViewController") as! ContentShareViewController
        next.iSelectedBookingId = self.iSelectedBookingId
        
        next.sPitchAddress = self.sPitchAddress
        next.sStartTime = self.sStartTime
        next.sEndTime = self.sEndTime
        next.sBookingDate = self.sBookingDate
        next.sPitchName = self.sPitchName
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

    
    @IBAction func ActionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    func FetchBookingDetails()
    {
     
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = ["access_token":self.sharedData.getAccessToken(),
                    "book_id":String(self.iSelectedBookingId)
        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.bookingDetailURL
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
                    self.bookingDetailsResponseModel = BookingDetailsResponseModel(response)
//
                    self.booking_list_data = self.bookingDetailsResponseModel?.booking_list_arrays
                    self.bookingDetails_lists = self.booking_list_data?.booking_listdata
                 
                    let statusCode = Int((self.bookingDetailsResponseModel?.httpcode)!)
                    if statusCode == 200
                    {
                        self.bookingpitchdata = self.bookingDetails_lists?.pitchdatadata
                        
                        self.bookingimage_list = self.bookingpitchdata?.image_list
                        
                       
                       
                        self.lblPichBookingDate.text = (self.bookingDetails_lists?.date)! + "." +  self.timeConversion12AMPMFromBookingDetails(time24: (self.bookingDetails_lists?.start_time)!)
                        self.lblPichName.text = (self.bookingpitchdata?.pitch_name)! + "," + (self.bookingpitchdata?.location)!
                      
                        
                        self.sStartTime = (self.bookingDetails_lists?.start_time)!
                        self.sPitchAddress = (self.bookingpitchdata?.location)!
                        self.sPitchName = (self.bookingpitchdata?.pitch_name)!
                        self.sBookingDate = (self.bookingDetails_lists?.date)!
                        self.view.activityStopAnimating()

                    }
                    if statusCode == 400{

//                        self.showToast(message:(self.bookingDetailsResponseModel?.message)!)
                        self.presentWindow?.makeToast(message: (self.bookingDetailsResponseModel?.message)!, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

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
        df.dateFormat = "HH:mm a"
        
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
