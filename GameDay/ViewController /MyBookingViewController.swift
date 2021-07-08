//
//  MyBookingViewController.swift
//  GameDay
//
//  Created by MAC on 05/01/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyBookingViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet weak var ViewBase: UIView!
    @IBOutlet weak var btnPreviouseBooking: UIButton!
    @IBOutlet weak var btnUpcomingBookings: UIButton!
    @IBOutlet weak var tblBookingList: UITableView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblMyBookings: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblProfileName: UILabel!
    @IBOutlet weak var lblWelcome: UILabel!
    var bUpcomingBookingList:Bool = false
    var bEdit:Bool = false
    var presentWindow : UIWindow?

    var iSelectedBooking_Id:Int = 0
    var user_details_Data_Main: User_details_Data_Main?
    var userProfileResponseModel:UserProfileResponseModel?

    var user_details_data:User_details_Data?
    var myBookingListResponseModel:MyBookingListResponseModel?
    var booking_list_arrays: booking_list_array?

//    var booking_listData:[booking_list]?
    
    var booking_listData = [booking_list]()

    
    var pitchdatadata: pitchdata?
    var image_list: [image_listModel]?
    let sharedData = SharedDefault()
    var upComing_Booking_Array_By_Datets: [String]?

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

        bUpcomingBookingList = true
        bEdit = false
        ViewBase.clipsToBounds = true
        ViewBase.layer.cornerRadius = 35
        ViewBase.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.btnEdit.clipsToBounds = true
        self.btnUpcomingBookings.clipsToBounds = true
        self.btnUpcomingBookings.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner] //
        self.btnUpcomingBookings.layer.borderWidth = 1.0
        self.btnUpcomingBookings.layer.borderColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0).cgColor
        self.btnUpcomingBookings.setTitleColor(UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0), for: .normal)
        self.btnPreviouseBooking.setTitleColor(UIColor(red: 112.0/255.0, green: 112.0/255.0, blue: 112.0/255.0, alpha: 1.0), for: .normal)
        tblBookingList.reloadData()
        self.btnEdit.layer.borderWidth = 1.0
        self.btnEdit.layer.borderColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0).cgColor
        // Do any additional setup after loading the view.
        self.btnEdit.isHidden = true
//        if sharedData.getAccessToken().count > 0
//        {
//        self.FetchUpcomingBookingDetails()
//        }
//        else
//        {
//            self.showToast(message: "You need to sign in first")
//        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if sharedData.getAccessToken().count > 0
        {
            self.FetchGettingProfileDetails()
            self.FetchUpcomingBookingDetails()

        }
        else
        {
            
            presentWindow?.makeToast(message: "Please sign in to view the upcoming bookings", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

//            self.showToast(message: "You need to sign in first")
        }
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
                       
                        self.lblProfileName.text = (self.user_details_data?.profile_fname)! + "  " + (self.user_details_data?.profile_lname)!
                            
                       
                        self.imgProfile.sd_setImage(with: URL(string: (self.user_details_data?.profile_avatar!)!), placeholderImage: UIImage(named: ""))
                        
                       
//                        self.imgProfile.sd_setImage(with: URL(string: (self.user_details_data?.profile_avatar!)!), placeholderImage: UIImage(named: ""))
                      
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
    @objc func swipeNextEntry(_ sender: UIPanGestureRecognizer) {
          print("[DEBUG] Pan Gesture Detected")

          if (sender.state == .ended) {
              let velocity = sender.velocity(in: self.view)

              if (velocity.x > 0) { // Coming from left
                self.navigationController?.popViewController(animated: true)

              }
          }
      }
    
    @IBAction func ActionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func ActionPreviouseBooking(_ sender: Any) {
        
        bUpcomingBookingList = false
        self.btnPreviouseBooking.clipsToBounds = true
        self.btnPreviouseBooking.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner] //
        self.btnPreviouseBooking.layer.borderWidth = 1.0
        self.btnPreviouseBooking.layer.borderColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0).cgColor
        self.btnPreviouseBooking.setTitleColor(UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0), for: .normal)
        self.btnUpcomingBookings.layer.borderColor = UIColor.clear.cgColor
        self.btnUpcomingBookings.setTitleColor(UIColor(red: 112.0/255.0, green: 112.0/255.0, blue: 112.0/255.0, alpha: 1.0), for: .normal)

        self.btnEdit.isHidden = false

        bEdit = false
        self.btnEdit.layer.borderWidth = 1.0
        self.btnEdit.layer.borderColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0).cgColor
        self.btnEdit.setTitleColor(UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0), for: .normal)
        self.btnEdit.setTitle("Edit", for: .normal)
        self.btnEdit.clipsToBounds = true
        if sharedData.getAccessToken().count > 0
        {
            self.FetchPreviouseBookingDetails()
        }
        else
        {
//            self.showToast(message: "You need to sign in first")
            self.presentWindow?.makeToast(message: "Please sign in to view the previouse bookings", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if bUpcomingBookingList
        {
            return 100
        }
        else
        {
            return 75
        }
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.booking_listData.count == 0 ||  self.booking_listData.count == nil
        {
            return 0
        }
        else
        {
            return self.booking_listData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
       
     if bUpcomingBookingList
     {
         let cell:UpcomingBookingTableViewCell = tblBookingList.dequeueReusableCell(withIdentifier: "UpcomingBookingTableViewCell", for: indexPath) as! UpcomingBookingTableViewCell
        
        cell.btnModify.tag = indexPath.row
        cell.btnInvite.tag = indexPath.row
        cell.lblHeading.text = (self.booking_listData[indexPath.row].pitchdatadata?.pitch_name)! + " , " + (self.booking_listData[indexPath.row].pitchdatadata?.location)!
        
        cell.lblHeading2.text = (self.booking_listData[indexPath.row].date)! + " | " +   self.timeConversion12FromBookingDetails(time24: (self.booking_listData[indexPath.row].start_time)!) + " - " +  self.timeConversion12AMPMFromBookingDetails(time24: (self.booking_listData[indexPath.row].end_time)!)
        
        cell.btnInvite.layer.borderWidth = 1.0
        cell.btnInvite.layer.borderColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0).cgColor
        cell.btnModify.layer.borderWidth = 1.0
        cell.btnModify.layer.borderColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0).cgColor
        
        if (indexPath.row % 2 == 0)
            {
            cell.contentView.backgroundColor = UIColor.clear
            cell.contentView.layer.cornerRadius = 5.0
            }
            else
            {
                cell.contentView.backgroundColor = hexStringToUIColor(hex: "#212121")
                cell.contentView.layer.cornerRadius = 5.0
                
                
            }
        
        
            
             return cell
         }
  
     else {
         let cell:PreviousBookingTableViewCell = tblBookingList.dequeueReusableCell(withIdentifier: "PreviousBookingTableViewCell", for: indexPath) as! PreviousBookingTableViewCell
        
        cell.btnCellSelection.tag = indexPath.row

        cell.lblHeading.text = (self.booking_listData[indexPath.row].pitchdatadata?.pitch_name)! + " , " + (self.booking_listData[indexPath.row].pitchdatadata?.location)!
        
        cell.lblHeading2.text = (self.booking_listData[indexPath.row].date)! + " | " +  self.timeConversion12FromBookingDetails(time24: (self.booking_listData[indexPath.row].start_time)!) + " - " +  self.timeConversion12AMPMFromBookingDetails(time24: (self.booking_listData[indexPath.row].end_time)!)
        
        
        
        if (indexPath.row % 2 == 0)
            {
            cell.contentView.backgroundColor = UIColor.clear
            cell.contentView.layer.cornerRadius = 5.0
            }
            else
            {
                cell.contentView.backgroundColor = hexStringToUIColor(hex: "#212121")
                cell.contentView.layer.cornerRadius = 5.0
                
                
            }
        
        
        
        if bEdit
        {
            cell.lblHeadingLeadingConstraints.constant = 45
            cell.lblHeading2LeadingConstraints.constant = 45
            cell.imgDeleteIcon.isHidden = false
        }
        else
        {
            cell.lblHeadingLeadingConstraints.constant = 20
            cell.lblHeading2LeadingConstraints.constant = 20
            cell.imgDeleteIcon.isHidden = true

        }
        
             return cell
         }
    }
    func timeConversion12FromBookingDetails(time24: String) -> String {
        let dateAsString = time24
        let df = DateFormatter()
        df.dateFormat = "HH:mm"

        let date = df.date(from: dateAsString)
        df.dateFormat = "hh:mm"

        let time12 = df.string(from: date!)
        print(time12)
        return time12
    }
    func timeConversion12AMPMFromBookingDetails(time24: String) -> String {
        let dateAsString = time24
        let df = DateFormatter()
        df.dateFormat = "HH:mm"

        let date = df.date(from: dateAsString)
        df.dateFormat = "hh:mm a"

        let time12 = df.string(from: date!)
        print(time12)
        return time12
    }
    @IBAction func ActionEdit(_ sender: Any) {
        
        if !bEdit
        {
            bEdit = true
            self.btnEdit.layer.borderWidth = 1.0
            self.btnEdit.layer.borderColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0).cgColor
            self.btnEdit.setTitleColor(UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0), for: .normal)
            self.btnEdit.setTitle("Clear All", for: .normal)
            self.btnEdit.clipsToBounds = true
            bUpcomingBookingList = false
        }
       else
        {
            bEdit = false
            self.btnEdit.layer.borderWidth = 1.0
            self.btnEdit.layer.borderColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0).cgColor
            self.btnEdit.setTitleColor(UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0), for: .normal)
            self.btnEdit.setTitle("Edit", for: .normal)
            self.btnEdit.clipsToBounds = true
            bUpcomingBookingList = true

        }
        tblBookingList.reloadData()
    }
    @IBAction func ActionUpcomingBooking(_ sender: Any)
    {
        bUpcomingBookingList = true
        self.btnUpcomingBookings.clipsToBounds = true
        self.btnUpcomingBookings.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner] //
        self.btnUpcomingBookings.layer.borderWidth = 1.0
        self.btnUpcomingBookings.layer.borderColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0).cgColor
        self.btnUpcomingBookings.setTitleColor(UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0), for: .normal)
        self.btnPreviouseBooking.layer.borderColor = UIColor.clear.cgColor
        self.btnPreviouseBooking.setTitleColor(UIColor(red: 112.0/255.0, green: 112.0/255.0, blue: 112.0/255.0, alpha: 1.0), for: .normal)

        
        self.btnEdit.isHidden = true

        bEdit = false
        self.btnEdit.layer.borderWidth = 1.0
        self.btnEdit.layer.borderColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0).cgColor
        self.btnEdit.setTitleColor(UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0), for: .normal)
        self.btnEdit.setTitle("Edit", for: .normal)
        self.btnEdit.clipsToBounds = true
        
        self.FetchUpcomingBookingDetails()
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

   
       
    @IBAction func ActionInviteBookingDetails(_ sender: UIButton) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "InviteViewController") as! InviteViewController
        next.iSelectedBookingId = (self.booking_listData[sender.tag].book_id)!
        self.navigationController?.pushViewController(next, animated: false)
    }
    
    @IBAction func ACtionModifyBookingDetails(_ sender: UIButton)
    {
        self.iSelectedBooking_Id = (self.booking_listData[sender.tag].book_id)!
        let next = self.storyboard?.instantiateViewController(withIdentifier: "BookYourPitchViewController") as! BookYourPitchViewController
        next.sSelectedDate = (self.booking_listData[sender.tag].date)!
        next.bfromUpcomingBookingList = true
        next.sBookingID = String((self.booking_listData[sender.tag].book_id)!)
        next.sStart_Time = (self.booking_listData[sender.tag].start_time!)
        next.sEndTime = (self.booking_listData[sender.tag].end_time!)
        next.sPitchId = String(self.booking_listData[sender.tag].pitch_id!)
        next.bFromFav = false

        self.navigationController?.pushViewController(next, animated: false)
    
    }
    
    func FetchPreviouseBookingDetails()
    {
     
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = ["access_token":self.sharedData.getAccessToken(),
                    "offset":"0"
        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.previousBookingList
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
                    self.myBookingListResponseModel = MyBookingListResponseModel(response)
//
                    self.booking_list_arrays = self.myBookingListResponseModel?.booking_list_arrays
                    
                    self.booking_listData = (self.booking_list_arrays?.booking_listdata)!
                 
                    let statusCode = Int((self.myBookingListResponseModel?.httpcode)!)
                    if statusCode == 200
                    {
                        if self.booking_listData.count > 0
                        {
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "dd MM yyyy"// yyyy-MM-dd"

                            self.booking_listData = self.booking_listData.sorted(by: { dateFormatter.date(from:$0.date!)!.compare(dateFormatter.date(from:$1.date!)!) == .orderedDescending })

                            

                            self.tblBookingList.reloadData()
                        }
                    }
                    if statusCode == 400{

//                        self.showToast(message:(self.myBookingListResponseModel?.message)!)
                        self.presentWindow?.makeToast(message: (self.myBookingListResponseModel?.message)!, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                    }
                    
                    
                    self.view.activityStopAnimating()
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
    func FetchUpcomingBookingDetails()
    {
     
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = ["access_token":self.sharedData.getAccessToken(),
                    "Offset":"0"
        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.UpcomingBookingList
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
                    self.myBookingListResponseModel = MyBookingListResponseModel(response)
//
                    self.booking_list_arrays = self.myBookingListResponseModel?.booking_list_arrays
                    
                    self.booking_listData = (self.booking_list_arrays?.booking_listdata)!
                 
                    let statusCode = Int((self.myBookingListResponseModel?.httpcode)!)
                    if statusCode == 200
                    {
                        if self.booking_listData.count > 0
                        {
                            
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "dd MM yyyy"// yyyy-MM-dd"

                            self.booking_listData = self.booking_listData.sorted(by: { dateFormatter.date(from:$0.date!)!.compare(dateFormatter.date(from:$1.date!)!) == .orderedDescending })

                            
                            
                            self.tblBookingList.reloadData()
                            
                        }
                        
                        
                     
                        
                        
                        
                        
                    }
                    if statusCode == 400{

//                        self.showToast(message:(self.myBookingListResponseModel?.message)!)
                        self.presentWindow?.makeToast(message: (self.myBookingListResponseModel?.message)!, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                    }
                    
                    
                    self.view.activityStopAnimating()
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
    
    @IBAction func ActionCellSelection(_ sender: UIButton) {
        
        
        self.iSelectedBooking_Id = (self.booking_listData[sender.tag].book_id)!
            let next = self.storyboard?.instantiateViewController(withIdentifier: "BookYourPitchViewController") as! BookYourPitchViewController
        next.sSelectedDate = (self.booking_listData[sender.tag].date)!
            next.bfromUpcomingBookingList = true
        next.sBookingID = String((self.booking_listData[sender.tag].book_id)!)
        next.bFromFav = false

        next.sStart_Time = (self.booking_listData[sender.tag].start_time!)
        next.sEndTime = (self.booking_listData[sender.tag].end_time!)
        
            self.navigationController?.pushViewController(next, animated: false)
        
    }
    
    
    @IBAction func ActionPreviuseCellSelection(_ sender: UIButton) {
        
        self.iSelectedBooking_Id = (self.booking_listData[sender.tag].book_id)!
        let next = self.storyboard?.instantiateViewController(withIdentifier: "BookYourPitchViewController") as! BookYourPitchViewController
        next.sSelectedDate = (self.booking_listData[sender.tag].date)!
        next.bFromPreviusBookingList = true
        next.sBookingID = String((self.booking_listData[sender.tag].book_id)!)
        next.bFromFav = false

        next.sStart_Time = (self.booking_listData[sender.tag].start_time!)
        next.sEndTime = (self.booking_listData[sender.tag].end_time!)

        self.navigationController?.pushViewController(next, animated: false)
    }
    
}
