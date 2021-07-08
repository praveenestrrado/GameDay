//
//  FavouritesViewController.swift
//  GameDay
//
//  Created by MAC on 21/12/20.
//

import UIKit
import ImageSlideshow
import Alamofire
import SwiftyJSON

class FavouritesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UIGestureRecognizerDelegate {
    var presentWindow : UIWindow?

    @IBOutlet var viewBaseleadingConstraints: NSLayoutConstraint!
    @IBOutlet weak var lblFav: UILabel!
    @IBOutlet weak var btnFavourites: UIButton!
    @IBOutlet weak var viewBase: UIView!
    @IBOutlet weak var tbleFavourites: UITableView!
    @IBOutlet weak var lblProfileName: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    var user_details_Data_Main: User_details_Data_Main?
    var userProfileResponseModel:UserProfileResponseModel?

    var user_details_data:User_details_Data?
    let sharedData = SharedDefault()
    var favoritesResponseModel : FavoritesResponseModel?
    var favoriteslistdata: Favoriteslist?
    var favorites_list: [Favorites]?
    var bFavoriteMethodeList:Bool = false
    var bEdit:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBase.clipsToBounds = true
        viewBase.layer.cornerRadius = 35
        viewBase.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively
        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
        presentWindow = UIApplication.shared.keyWindow
        UIView.hr_setToastThemeColor(color: UIColor.white)
        UIView.hr_setToastFontColor(color: self.hexStringToUIColor(hex: "#6fc13a"))
        UIView.hr_setToastFontName(fontName: "TTOctosquares-Medium")
                bFavoriteMethodeList = true
        bEdit = false
        
        // Disable swipe-to-pop gesture
                navigationController?.interactivePopGestureRecognizer?.delegate = self
                navigationController?.interactivePopGestureRecognizer?.isEnabled = false

                // Detect swipe gesture to load next entry
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipeNextEntry)))

        self.btnFavourites.setImage(UIImage(named: "PathM"), for: .normal)
        self.lblFav.textColor = self.hexStringToUIColor(hex: "#6fc13a")
        
        if sharedData.getAccessToken().count > 0
        {
            self.FetchGettingProfileDetails()
            self.GetFavoriteList()

        }
        else
        {
//            self.showToast(message: "You need to sign in first")
            self.presentWindow?.makeToast(message: "Please sign in to view favorites", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            var height:CGFloat = CGFloat()
//            if indexPath.row == 0 {
//                height = 80
//            }
//            else if indexPath.row == 1 {
//                height = self.view.frame.size.height - 44 - 64 // 44 is a tab bar height and 64 is navigationbar height.
//                print(height)
//            }
        height = 80
            return height
        }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if tableView == tbleFavourites {
            
            
            
            
            let settingsTCell = tbleFavourites.dequeueReusableCell(withIdentifier: "FavouritesTableViewCell", for: indexPath) as! FavouritesTableViewCell
//            settingsTCell.lblProfileItem.text = ProfilesName[indexPath.row]
//            settingsTCell.imgProfileIcons.image = ProfileIconImg[indexPath.row]
            settingsTCell.viewBase.layer.cornerRadius = 10.0
            settingsTCell.btnDelete.tag =  self.favorites_list![indexPath.row].id!
            settingsTCell.lblPitchInfo.text = self.favorites_list![indexPath.row].pitch_name! + ", "  + self.favorites_list![indexPath.row].location!
            settingsTCell.lblBookingInfo.text = "You've booked this pitch " +  String(self.favorites_list![indexPath.row].no_of_bookings!) + " times!"
            settingsTCell.selectionStyle = .none
            settingsTCell.btnDelete.isHidden = true
            settingsTCell.btnSelection.tag = indexPath.row
            settingsTCell.btnBookingNow.tag = indexPath.row

            if indexPath.row % 2 == 1
            {
                settingsTCell.viewBase.backgroundColor =  self.hexStringToUIColor(hex: "#212121")
                settingsTCell.contentView.layer.cornerRadius = 5.0
            }
            cell = settingsTCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
//        print("Selcted List Details")
//        let settingsTCell = tbleFavourites.dequeueReusableCell(withIdentifier: "FavouritesTableViewCell", for: indexPath) as! FavouritesTableViewCell
//
//        if !bEdit
//        {
//            bEdit = true
//        
//            bFavoriteMethodeList = true
//            
//            settingsTCell.btnDelete.isHidden = false
//
//        }
//       else
//        {
//            bEdit = false
//            
//            bFavoriteMethodeList = false
//            
//            settingsTCell.btnDelete.isHidden = true
//
//
//        }
//        
        
      
    }
    
    
    
    @IBAction func ActionDelete(_ sender: UIButton)
    {
        
        
        let index = IndexPath(row: sender.tag, section: 0)
            let cell: FavouritesTableViewCell = self.tbleFavourites.cellForRow(at: index) as! FavouritesTableViewCell
            
        
        
        print("Selcted List Details")

        if !bEdit
        {
            bEdit = true
        
            bFavoriteMethodeList = true
            
            cell.btnDelete.isHidden = false

        }
       else
        {
            bEdit = false
            
            bFavoriteMethodeList = false
            
            cell.btnDelete.isHidden = true


        }
        
    }
    
    
    
    @IBAction func ActionDeleteFavoriteList(_ sender: UIButton)
    {
        let alert = UIAlertController(title: Constants.appName, message:"Are you sure you want to delete the selected item", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { _ in
            //Yes Action
            self.DeleteSelectedFavoriteListData(iPitchId: sender.tag)

           
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
            print("NO")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favorites_list?.count ?? 0
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func ActionBookNow(_ sender: Any) {
        
       
    }
    
    
    @IBAction func ActionFavBookNow(_ sender: UIButton) {
        
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "BookYourPitchViewController") as! BookYourPitchViewController
        next.sSelectedDate = ""
        next.sPitchId = String(self.favorites_list![sender.tag].pitch_id!)
        next.sBookingID = ""
        next.sSelectedDate = Date.getCurrentDate()
        next.iBookType = 0
        next.iNo_of_Weeks = 0
        next.sDuration = 0
        next.sPitchName = self.favorites_list![sender.tag].pitch_name!
        next.sPitchAddress =  self.favorites_list![sender.tag].location!
      
        next.bFromFav = true
        
        
        self.navigationController?.pushViewController(next, animated: false)
    }
    
    
    func GetFavoriteList()
    {
     
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = ["access_token":self.sharedData.getAccessToken(),
                    "offset":"0"
        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.favorites_list
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
                    self.favoritesResponseModel = FavoritesResponseModel(response)
////
//                    self.filter_datas = self.filterResponseModel?.filterData?.filter_datas
//                    self.filter_masters = self.filterResponseModel?.filterData?.filter_masters
//                    self.durations = self.filter_masters?.durations
//                    self.pitch_sizes = self.filter_masters?.pitch_sizes
//                    self.pitch_turfs = self.filter_masters?.pitch_turfs
//                    self.pitch_types = self.filter_masters?.pitch_types
//                    self.user_details = self.filterResponseModel?.filterData?.user_details

                    self.favorites_list = self.favoritesResponseModel?.favoriteslistdata?.favorites_list
                    
                    
                    //
                    let statusCode = Int((self.favoritesResponseModel?.httpcode)!)
                    if statusCode == 200{
                        print("registerResponseModel ----- ",self.favoritesResponseModel)
 
//                        
//                        print("Pitch list count:--->", self.pitch_list.count)
//                        print("Duration list count:--->", self.durations?.count ?? "0")
                        
                        
                        if self.favorites_list!.count > 0
                        {
                            self.tbleFavourites.reloadData()
                        }
                        else
                        {
//                            self.showToast(message: "No records found")
                            self.presentWindow?.makeToast(message: "No Favorite pitch added", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                        }
                    
                    }
                    if statusCode == 400{

//                        self.showToast(message:(self.favoritesResponseModel?.message)!)
                        self.presentWindow?.makeToast(message: (self.favoritesResponseModel?.message)!, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                    }
//                    
                    
                    self.view.activityStopAnimating()
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
    
    
    func DeleteSelectedFavoriteListData(iPitchId:Int)
    {
     
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = ["access_token":self.sharedData.getAccessToken(),
                    "pitch_id":String(iPitchId)
        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.favorites_list_delete
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
                    self.favoritesResponseModel = FavoritesResponseModel(response)
////
//                    self.filter_datas = self.filterResponseModel?.filterData?.filter_datas
//                    self.filter_masters = self.filterResponseModel?.filterData?.filter_masters
//                    self.durations = self.filter_masters?.durations
//                    self.pitch_sizes = self.filter_masters?.pitch_sizes
//                    self.pitch_turfs = self.filter_masters?.pitch_turfs
//                    self.pitch_types = self.filter_masters?.pitch_types
//                    self.user_details = self.filterResponseModel?.filterData?.user_details

                    self.favorites_list = self.favoritesResponseModel?.favoriteslistdata?.favorites_list
                    
                    
                    //
                    let statusCode = Int((self.favoritesResponseModel?.httpcode)!)
                    if statusCode == 200{
                        print("registerResponseModel ----- ",self.favoritesResponseModel)
 
//
//                        print("Pitch list count:--->", self.pitch_list.count)
//                        print("Duration list count:--->", self.durations?.count ?? "0")
                        
                        
                        if self.favorites_list!.count > 0
                        {
                            self.tbleFavourites.reloadData()
                        }
                        
                    
                    }
                    if statusCode == 400{

//                        self.showToast(message:(self.favoritesResponseModel?.message)!)
                        self.presentWindow?.makeToast(message: (self.favoritesResponseModel?.message)!, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                    }
//
                    
                    self.view.activityStopAnimating()
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
}
