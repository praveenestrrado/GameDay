//
//  PaymentMethodeListViewController.swift
//  GameDay
//
//  Created by MAC on 05/01/21.
//

import UIKit
import Alamofire
import SwiftyJSON
class PaymentMethodeListViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet weak var viewBase: UIView!
    @IBOutlet weak var tblBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var btnAddNewPaymentMethod: UIButton!
    @IBOutlet weak var tbleViewpaymentList: UITableView!
    @IBOutlet weak var btnRecentBooking: UIButton!
    @IBOutlet weak var btnpaymentMethods: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblPayment: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblBack: UILabel!
    var bPaymentMethodeList:Bool = false
    var bEdit:Bool = false
    let sharedData = SharedDefault()
    var myBookingListResponseModel:MyBookingListResponseModel?
    var booking_list_arrays: booking_list_array?
    var user_details_Data_Main: User_details_Data_Main?
    var userProfileResponseModel:UserProfileResponseModel?

    var user_details_data:User_details_Data?
    var booking_listData:[booking_list]?
    var pitchdatadata: pitchdata?
    var image_list: [image_listModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Disable swipe-to-pop gesture
                navigationController?.interactivePopGestureRecognizer?.delegate = self
                navigationController?.interactivePopGestureRecognizer?.isEnabled = false

                // Detect swipe gesture to load next entry
        self.tbleViewpaymentList.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipeNextEntry)))
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipeNextEntry)))

        
        bPaymentMethodeList = true
        bEdit = false
        viewBase.clipsToBounds = true
        viewBase.layer.cornerRadius = 35
        viewBase.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.btnEdit.clipsToBounds = true
        self.btnpaymentMethods.clipsToBounds = true
        self.btnpaymentMethods.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner] //
        self.btnpaymentMethods.layer.borderWidth = 1.0
        self.btnpaymentMethods.layer.borderColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0).cgColor
        self.btnpaymentMethods.setTitleColor(UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0), for: .normal)
        self.btnRecentBooking.layer.borderColor = UIColor.clear.cgColor
        self.btnRecentBooking.setTitleColor(UIColor(red: 112.0/255.0, green: 112.0/255.0, blue: 112.0/255.0, alpha: 1.0), for: .normal)
        tbleViewpaymentList.reloadData()
        self.btnEdit.layer.borderWidth = 1.0
        self.btnEdit.layer.borderColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0).cgColor
        // Do any additional setup after loading the view.
        
        
        
        bPaymentMethodeList = true
        self.btnpaymentMethods.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner] //
        self.btnpaymentMethods.layer.borderWidth = 1.0
        self.btnpaymentMethods.layer.borderColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0).cgColor
        self.btnpaymentMethods.setTitleColor(UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0), for: .normal)
        self.btnRecentBooking.layer.borderColor = UIColor.clear.cgColor
        self.btnRecentBooking.setTitleColor(UIColor(red: 112.0/255.0, green: 112.0/255.0, blue: 112.0/255.0, alpha: 1.0), for: .normal)
        self.btnAddNewPaymentMethod.isHidden = false
        tblBottomConstraints.constant = 105
        self.btnpaymentMethods.clipsToBounds = true

        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if sharedData.getAccessToken().count > 0
        {
            self.FetchGettingProfileDetails()
        }
        else
        {
            self.showToast(message: "Please sign in to view the payment methodes")
            
            
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
                    self.showToast(message: "Request timed out! Please try again!")
                }
                else if error._code == 4 {
                    self.showToast(message: "Internal server error! Please try again!")
                }
                else if error._code == -1003 {
                    self.showToast(message: "Server error! Please contact support!")
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
                       
                        self.lblName.text = (self.user_details_data?.profile_fname)! + "  " + (self.user_details_data?.profile_lname)!
                            
                       
                        self.imgProfile.sd_setImage(with: URL(string: (self.user_details_data?.profile_avatar!)!), placeholderImage: UIImage(named: ""))
                        
                       
//                        self.imgProfile.sd_setImage(with: URL(string: (self.user_details_data?.profile_avatar!)!), placeholderImage: UIImage(named: ""))
                      
                    }
                    if statusCode == 400{

                        self.showToast(message:(self.userProfileResponseModel?.message)!)
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
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func ActionAddNewPayment(_ sender: Any) {
    }
    @IBAction func ActionBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func ActionEdit(_ sender: Any)
    {
        if !bEdit
        {
            bEdit = true
            self.btnEdit.layer.borderWidth = 1.0
            self.btnEdit.layer.borderColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
            self.btnEdit.setTitleColor(UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0), for: .normal)
            self.btnEdit.setTitle("Clear", for: .normal)
            self.btnEdit.clipsToBounds = true
            bPaymentMethodeList = true
        }
       else
        {
            bEdit = false
            self.btnEdit.layer.borderWidth = 1.0
            self.btnEdit.layer.borderColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0).cgColor
            self.btnEdit.setTitleColor(UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0), for: .normal)
            self.btnEdit.setTitle("Edit", for: .normal)
            self.btnEdit.clipsToBounds = true
            bPaymentMethodeList = true

        }
        tbleViewpaymentList.reloadData()

    }
    
    @IBAction func ActionPaymentMethode(_ sender: Any)
    {
        bPaymentMethodeList = true
        self.btnpaymentMethods.clipsToBounds = true
        self.btnpaymentMethods.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner] //
        self.btnpaymentMethods.layer.borderWidth = 1.0
        self.btnpaymentMethods.layer.borderColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0).cgColor
        self.btnpaymentMethods.setTitleColor(UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0), for: .normal)
        self.btnRecentBooking.layer.borderColor = UIColor.clear.cgColor
        self.btnRecentBooking.setTitleColor(UIColor(red: 112.0/255.0, green: 112.0/255.0, blue: 112.0/255.0, alpha: 1.0), for: .normal)
        self.btnAddNewPaymentMethod.isHidden = false
        tblBottomConstraints.constant = 105

        
        
        bEdit = false
        self.btnEdit.layer.borderWidth = 1.0
        self.btnEdit.layer.borderColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0).cgColor
        self.btnEdit.setTitleColor(UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0), for: .normal)
        self.btnEdit.setTitle("Edit", for: .normal)
        self.btnEdit.clipsToBounds = true
        
        tbleViewpaymentList.reloadData()


    }
    @IBAction func ActionRecentBookings(_ sender: Any)
    {
        bPaymentMethodeList = false
        self.btnRecentBooking.clipsToBounds = true
        self.btnRecentBooking.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner] //
        self.btnRecentBooking.layer.borderWidth = 1.0
        self.btnRecentBooking.layer.borderColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0).cgColor
        self.btnRecentBooking.setTitleColor(UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0), for: .normal)
        self.btnpaymentMethods.layer.borderColor = UIColor.clear.cgColor
        self.btnpaymentMethods.setTitleColor(UIColor(red: 112.0/255.0, green: 112.0/255.0, blue: 112.0/255.0, alpha: 1.0), for: .normal)
        self.btnAddNewPaymentMethod.isHidden = true
        tblBottomConstraints.constant = 25

        
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
            self.showToast(message: "Please sign in to view the recent bookings")
        }
//        tbleViewpaymentList.reloadData()

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
        
            return 100
        }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if !bPaymentMethodeList
        {
        return 5
        }
        else
        {
            return self.booking_listData?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
     if bPaymentMethodeList
     {
         let cell:PaymentMethodListTableViewCell = tbleViewpaymentList.dequeueReusableCell(withIdentifier: "PaymentMethodListTableViewCell", for: indexPath) as! PaymentMethodListTableViewCell
        cell.viewBase.backgroundColor = hexStringToUIColor(hex: "#2A2B2C")
        if indexPath.row == 0
        {
            cell.imgCard.image = UIImage(named: "Master_Card")
        }
        else
        {
            cell.imgCard.image = UIImage(named: "Visa_Card")


        }
        if bEdit == false
        {
            cell.imgDeleteIcon.isHidden = true
        }
        else
        {
            cell.imgDeleteIcon.isHidden = false

        }
            
             return cell
         }
  
     else {
         let cell:RecentBookingsTableViewCell = tbleViewpaymentList.dequeueReusableCell(withIdentifier: "RecentBookingsTableViewCell", for: indexPath) as! RecentBookingsTableViewCell
        
//        cell.lblCurrency.text = self.booking_listData![indexPath.row].c
        
//        cell.lblPrice.text = self.booking_listData![indexPath.row].
        
        
        if indexPath.row % 2 == 1
        {
            cell.contentView.backgroundColor = hexStringToUIColor(hex: "#2A2B2C")
            cell.contentView.layer.cornerRadius = 5.0
        }
             return cell
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
        
        AF.request(loginURL, method: .post, parameters: postDict, encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
            print("Response:***:",data.description)
            
            switch (data.result) {
            case .failure(let error) :
                self.view.activityStopAnimating()
               
                if error._code == NSURLErrorTimedOut {
                    self.showToast(message: "Request timed out! Please try again!")
                }
                else if error._code == 4 {
                    self.showToast(message: "Internal server error! Please try again!")
                }
                else if error._code == -1003 {
                    self.showToast(message: "Server error! Please contact support!")
                }
            case .success :
                do {
                    
                    let response = JSON(data.data!)
                    self.myBookingListResponseModel = MyBookingListResponseModel(response)
//
                    self.booking_list_arrays = self.myBookingListResponseModel?.booking_list_arrays
                    
                    self.booking_listData = self.booking_list_arrays?.booking_listdata
                 
                    let statusCode = Int((self.myBookingListResponseModel?.httpcode)!)
                    if statusCode == 200
                    {
                        if self.booking_listData!.count > 0
                        {
                            
                            self.tbleViewpaymentList.reloadData()
                        }
                    }
                    if statusCode == 400{

                        self.showToast(message:(self.myBookingListResponseModel?.message)!)
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
