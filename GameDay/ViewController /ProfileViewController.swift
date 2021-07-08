//
//  ProfileViewController.swift
//  GameDay
//
//  Created by MAC on 21/12/20.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfileViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UIGestureRecognizerDelegate {
    var presentWindow : UIWindow?

    @IBOutlet weak var lblProfile: UILabel!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var tbleProfile: UITableView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblProfileName: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
//    var ProfilesName = ["Profile","Notifications","My Bookings","Payment Method","Logout","Legal * Terms & conditions","Version:1.0"]
    
    var ProfilesName = ["Profile","Notifications","My Bookings","Payment Method","Logout"]

    var ProfileIconImg = [UIImage]()
    let sharedData = SharedDefault()

    var loginResponseModel:LoginResponseModel?
    var user_details_Data_Main: User_details_Data_Main?
    var userProfileResponseModel:UserProfileResponseModel?

    var user_details_data:User_details_Data?
    

    override func viewWillAppear(_ animated: Bool) {
        
        presentWindow = UIApplication.shared.keyWindow
        UIView.hr_setToastThemeColor(color: UIColor.white)
        UIView.hr_setToastFontColor(color: self.hexStringToUIColor(hex: "#6fc13a"))
        UIView.hr_setToastFontName(fontName: "TTOctosquares-Medium")
                if sharedData.getAccessToken().count > 0
        {
            ProfileIconImg.append(UIImage(named: "Profile")!)
            ProfileIconImg.append(UIImage(named: "Notification_Icon")!)
            ProfileIconImg.append(UIImage(named: "MyBookings")!)
            ProfileIconImg.append(UIImage(named: "Payment_Methode")!)
            ProfileIconImg.append(UIImage(named: "Logout")!)
          

            self.FetchGettingProfileDetails()
        }
        else
        {
            ProfilesName = ["Profile","Notifications","My Bookings","Payment Method"]
            ProfileIconImg.append(UIImage(named: "Profile")!)
            ProfileIconImg.append(UIImage(named: "Notification_Icon")!)
            ProfileIconImg.append(UIImage(named: "MyBookings")!)
            ProfileIconImg.append(UIImage(named: "Payment_Methode")!)
         

        }
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable swipe-to-pop gesture
                navigationController?.interactivePopGestureRecognizer?.delegate = self
                navigationController?.interactivePopGestureRecognizer?.isEnabled = false

                // Detect swipe gesture to load next entry
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipeNextEntry)))
        
        
//        ProfileIconImg.append(UIImage(named: "Profile")!)
//        ProfileIconImg.append(UIImage(named: "Notification_Icon")!)
//        ProfileIconImg.append(UIImage(named: "MyBookings")!)
//        ProfileIconImg.append(UIImage(named: "Payment_Methode")!)
//        ProfileIconImg.append(UIImage(named: "Logout")!)
//        ProfileIconImg.append(UIImage(named: "Logout")!)
//        ProfileIconImg.append(UIImage(named: "Logout")!)

        tbleProfile.clipsToBounds = true
        tbleProfile.layer.cornerRadius = 35
        tbleProfile.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively
        // Do any additional setup after loading the view.
        
        self.btnProfile.setImage(UIImage(named: "GroupGP"), for: .normal)
        self.lblProfile.textColor = self.hexStringToUIColor(hex: "#6FC13A")
        
      
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    var tableViewHeight: CGFloat {
        tbleProfile.layoutIfNeeded()
        
        return 100
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            var height:CGFloat = CGFloat()
//            if indexPath.row == 0 {
//                height = 80
//            }
//            else if indexPath.row == 1 {
//                height = self.view.frame.size.height - 44 - 64 // 44 is a tab bar height and 64 is navigationbar height.
//                print(height)
//            }
        height = 75
            return height
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if tableView == tbleProfile {
            let settingsTCell = tbleProfile.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
            settingsTCell.lblProfileItem.text = ProfilesName[indexPath.row]
            settingsTCell.imgProfileIcons.image = ProfileIconImg[indexPath.row]
            
            if self.sharedData.getAccessToken().count > 0
            {
//                if indexPath.row == 4
//                {
//                    settingsTCell.imgProfileIcons?.isHidden = true
//                    settingsTCell.lblProfileItem.font = UIFont(name: "Verdana", size: 13)
//                }
                
            }
          else
            {
//                if indexPath.row == 5
//                {
//                    settingsTCell.imgProfileIcons?.isHidden = true
//                    settingsTCell.lblProfileItem.font = UIFont(name: "Verdana", size: 13)
//                }
                
            }
            settingsTCell.selectionStyle = .none
            cell = settingsTCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == 0
        {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
            self.navigationController?.pushViewController(next, animated: false)
        }
        
        
        if indexPath.row == 1
        {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "NotificationListViewController") as! NotificationListViewController
            self.navigationController?.pushViewController(next, animated: false)
        }
        if indexPath.row == 2
        {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "MyBookingViewController") as! MyBookingViewController
            self.navigationController?.pushViewController(next, animated: false)
        }
        if indexPath.row == 3
        {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "PaymentMethodeListViewController") as! PaymentMethodeListViewController
            self.navigationController?.pushViewController(next, animated: false)
        }
        if indexPath.row == 4
        {
            if sharedData.getAccessToken().count == 0
            {
//                self.showToast(message:  "Please sign in first")
                self.presentWindow?.makeToast(message: "Please sign in to update your profile", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

            }
            else
            {
            let alert = UIAlertController(title: Constants.appName, message: Constants.logoutMSG, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { _ in
                //Yes Action
                
                self.LogoutApp()
               
            }))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
                print("NO")
            }))
            self.present(alert, animated: true, completion: nil)
            }
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
    
    
    func LogoutApp(){
        self.view.activityStartAnimating()
        var postDict = Dictionary<String,String>()
        postDict = [
            "access_token":sharedData.getAccessToken()
        ]
  
        let loginURL = Constants.baseURL+Constants.SignOutUrl
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
                    
                    self.presentWindow?.makeToast(message: "logout successfully", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.
                      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
                      {
                          self.sharedData.clearAccessToken()
                          
                          
                          
                          self.sharedData.clearOperatorName()
                          self.sharedData.clearOperatorID()
                          self.sharedData.clearFcmToken()

                          self.sharedData.setLoginStatus(loginStatus: false)
                          
                          
                          UserDefaults.standard.setValue("", forKey: "access_token")
                        let next = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                        self.navigationController?.pushViewController(next, animated: false)
                    

                          
                          self.view.activityStopAnimating()
                      }
                  }
                    if statusCode == 400
                    {
                     
                      
                      self.view.activityStopAnimating()
//                          self.showToast(message: (self.loginResponseModel?.message)!)
                        self.presentWindow?.makeToast(message: (self.loginResponseModel?.message)!, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                    }
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfilesName.count
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
}
