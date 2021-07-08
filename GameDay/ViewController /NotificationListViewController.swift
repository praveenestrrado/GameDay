//
//  NotificationListViewController.swift
//  GameDay
//
//  Created by MAC on 06/01/21.
//

import UIKit
import SwiftyJSON
import Alamofire

class NotificationListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet weak var ViewBase: UIView!
    @IBOutlet weak var tbleNotificationList: UITableView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblProfileName: UILabel!
    @IBOutlet weak var lblWelcomeBack: UILabel!
    var bEdit:Bool = false
    var presentWindow : UIWindow?

    var user_details_Data_Main: User_details_Data_Main?
    var userProfileResponseModel:UserProfileResponseModel?

    var user_details_data:User_details_Data?
    let sharedData = SharedDefault()
    
    
    @IBOutlet weak var btnEdit: UIButton!
    
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
        self.tbleNotificationList.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipeNextEntry)))
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipeNextEntry)))

        self.btnEdit.layer.borderWidth = 1.0
        self.btnEdit.layer.borderColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0).cgColor
        tbleNotificationList.reloadData()
        ViewBase.clipsToBounds = true
        ViewBase.layer.cornerRadius = 35
        ViewBase.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if sharedData.getAccessToken().count > 0
        {
            self.FetchGettingProfileDetails()
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
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return 125

        }
        else
        {
            return 100
        }
        }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if !bEdit
        {
       
        if indexPath.row == 0
     {
         let cell:NotificationHeadingTableViewCell = tbleNotificationList.dequeueReusableCell(withIdentifier: "NotificationHeadingTableViewCell", for: indexPath) as! NotificationHeadingTableViewCell
      
       
             return cell
         }
  
     else {
         let cell:NotificationListTableViewCell = tbleNotificationList.dequeueReusableCell(withIdentifier: "NotificationListTableViewCell", for: indexPath) as! NotificationListTableViewCell
        cell.lblHeadingLeadingConstraints.constant = 0
        cell.lblHeading2LeadingConstraints.constant = 0
        cell.imgDeleteIcon.isHidden = true
        
             return cell
         }
            
        }
        else
        {
            let cell:NotificationListTableViewCell = tbleNotificationList.dequeueReusableCell(withIdentifier: "NotificationListTableViewCell", for: indexPath) as! NotificationListTableViewCell
           
            
            if indexPath.row == 1
            {
                cell.lblHeadingLeadingConstraints.constant = 45
                cell.lblHeading2LeadingConstraints.constant = 45
                cell.imgDeleteIcon.isHidden = false
            }
            
//           if bEdit
//           {
//               cell.lblHeadingLeadingConstraints.constant = 45
//               cell.lblHeading2LeadingConstraints.constant = 45
//               cell.imgDeleteIcon.isHidden = false
//           }
           else
           {
               cell.lblHeadingLeadingConstraints.constant = 0
               cell.lblHeading2LeadingConstraints.constant = 0
               cell.imgDeleteIcon.isHidden = true

           }
            return cell

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
    @IBAction func ActionEdit(_ sender: Any)
    {
        if !bEdit
        {
            bEdit = true
            self.btnEdit.layer.borderWidth = 1.0
            self.btnEdit.layer.borderColor = UIColor(red: 55.0/255.0, green: 151.0/255.0, blue: 12.0/255.0, alpha: 1.0).cgColor
            self.btnEdit.setTitleColor(UIColor(red: 55.0/255.0, green: 151.0/255.0, blue: 12.0/255.0, alpha: 1.0), for: .normal)
            self.btnEdit.setTitle("Clear", for: .normal)
            self.btnEdit.clipsToBounds = true
        }
       else
        {
            bEdit = false
            self.btnEdit.layer.borderWidth = 1.0
            self.btnEdit.layer.borderColor = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0).cgColor
            self.btnEdit.setTitleColor(UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1.0), for: .normal)
            self.btnEdit.setTitle("Edit", for: .normal)
            self.btnEdit.clipsToBounds = true

        }
        tbleNotificationList.reloadData()
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
    @IBAction func ActionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
}
