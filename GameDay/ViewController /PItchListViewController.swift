//
//  PItchListViewController.swift
//  GameDay
//
//  Created by MAC on 22/12/20.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class PItchListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var tblPitchList: UITableView!
    
    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var btnfilter: UIButton!
    @IBOutlet weak var btnOutDoorPitch: UIButton!
    var presentWindow : UIWindow?

    let sharedData = SharedDefault()
    
    var filterResponseModel : FilterResponseModel?
    var filterData : FilterData?
    var pitch_list = [Pitch_list]()

    var filter_datas: filter_data?
    var filter_masters: filter_master?
    var durations: [Durations]?
    var pitch_sizes: [Pitch_sizes]?
    var pitch_turfs: [Pitch_turfs]?
    var pitch_types: [Pitch_typess]?
    var user_details: User_details?

    
    var Iimage_list: [image_list]?

    
    var sSelectedDate:String?
    var bFromFilter:Int?
    var sSelectedDateFromFilter:String?
    var book_type : Int?
    var weeks : Int?
    var slocationFromFilter : String?
    var sLatitude : String?
    var sLongitude : String?
    var sDateFromFilter : String?
    var sDurationFromFilter : String?
    var sPitch_typeFromFilter : String?
    var sPitch_typeNameFromFilter : String?

    var sPitch_sizeFromFilter : String?
    var sPitch_turfFromFilter : String?
    var sStart_priceFromFilter : String?
    var sEnd_priceFromFilter : String?
    var sStart_timeFromFilter : String?
    var send_timeFromFilter : String?
    var forgotPasswordResponseModel : ForgotPasswordResponseModel?
    override func viewWillAppear(_ animated: Bool) {
        
        
        presentWindow = UIApplication.shared.keyWindow
        UIView.hr_setToastThemeColor(color: UIColor.white)
        UIView.hr_setToastFontColor(color: self.hexStringToUIColor(hex: "#6fc13a"))
        UIView.hr_setToastFontName(fontName: "TTOctosquares-Medium")
        
        
        
//        if self.sharedData.getAccessToken().count > 0
//        {
            if self.bFromFilter == 1
            {
                self.FilterPitchList()
                self.btnOutDoorPitch.setTitle(self.sPitch_typeNameFromFilter, for: .normal)

            }
            else
            {
                self.GetPitchList()
                
                self.btnOutDoorPitch.setTitle(self.sPitch_typeNameFromFilter, for: .normal)
            }
//        }
//        else
//        {
//            self.showToast(message: "Access token is missing")
//        }
        
       
    }
//    override func viewDidAppear(_ animated: Bool) {
//        if self.bFromFilter == 1
//        {
//            self.FilterPitchList()
//        }
//        else
//        {
//            self.GetPitchList()
//        }
//    }
//    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
//        if navigationController?.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) ?? false {
//            navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//        }
        
        
       
        
        
        // Disable swipe-to-pop gesture
                navigationController?.interactivePopGestureRecognizer?.delegate = self
                navigationController?.interactivePopGestureRecognizer?.isEnabled = false

                // Detect swipe gesture to load next entry
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipeNextEntry)))

        // Do any additional setup after loading the view.
//        self.addBackButton(title: "pich")
      

        self.btnOutDoorPitch.layer.borderWidth = 0.5
        self.btnOutDoorPitch.layer.borderColor = UIColor.lightGray.cgColor
        self.btnOutDoorPitch.layer.cornerRadius = 17.5
        self.viewFilter.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
        
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
    @IBAction func ActionHome(_ sender: Any)
    {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(next, animated: false)
    }
    @IBAction func ActionFavourites(_ sender: Any)
    {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "FavouritesViewController") as! FavouritesViewController
        self.navigationController?.pushViewController(next, animated: false)
    }
    @IBAction func ACtionAddFavoritePitch(_ sender: UIButton)
    {
        
        print("gfgfgfgfgfgfgfgfgfgfgfg")
        
//
//        var index = IndexPath(row: sender.tag, section: 0)
//        let cell: PitchListTableViewCell = self.tblPitchList.cellForRow(at: index) as! PitchListTableViewCell
//
//
        
        
        if self.sharedData.getAccessToken().count == 0
        {
//            self.showToast(message: "You need to sign in first")
            presentWindow?.makeToast(message: "Please sign in to add favorites", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

        }
        else
        {
            if self.pitch_list[sender.tag].favorite_status == "1"
            {
                self.DeleteSelectedFavoriteListData(iPitchId: self.pitch_list[sender.tag].pitch_id!)

            }
             else
            {
                self.AddFavoritePitchDetails(iPItchId: self.pitch_list[sender.tag].pitch_id!)

            }

        }
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
    
    @IBAction func ActionFilter(_ sender: Any)
    {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "FilterScreenViewController") as! FilterScreenViewController
        
        if self.sSelectedDate == nil
        {
            next.sSelectedDate = Date.getCurrentDate()

        }
        else
        {
        next.sSelectedDate = self.sSelectedDate!
        }
        next.sLatitude = self.sLatitude
        next.sPitch_typeNameFromFilter = sPitch_typeNameFromFilter
        next.sLongitude = self.sLongitude
        next.book_type = self.book_type
        self.navigationController?.pushViewController(next, animated: false)
    }
    

    @IBAction func ActionBookNow(_ sender: UIButton)
    {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "BookYourPitchViewController") as! BookYourPitchViewController
        next.sSelectedDate = self.sSelectedDate
        next.sBookingID = ""
//        self.pitch_list[sender.tag].pitch_name
        
//        self.pitch_list[sender.tag].location
        
        next.sPitchName = self.pitch_list[sender.tag].pitch_name!
        next.sPitchAddress =  self.pitch_list[sender.tag].location!
        
        next.sPitchId = String(self.pitch_list[sender.tag].pitch_id!)
       
        
//        next.iBookType = self.pitch_list[sender.tag].booking_type
        
        next.iBookType = self.book_type
        next.bFromFav = false

        next.iNo_of_Weeks = self.weeks
        next.sDuration = self.durations![sender.tag].id
        self.navigationController?.pushViewController(next, animated: false)
    }
    
    @IBAction func ActionSearch(_ sender: Any)
    {
        
 
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
            var height:CGFloat = CGFloat()

        height = 355
            return height
        }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if tableView == tblPitchList {
            let settingsTCell = tblPitchList.dequeueReusableCell(withIdentifier: "PitchListTableViewCell", for: indexPath) as! PitchListTableViewCell

            settingsTCell.selectionStyle = .none
            
            self.Iimage_list = self.pitch_list[indexPath.row].Iimage_list
//            @IBOutlet weak var lblPitchName: UILabel!
//            @IBOutlet weak var lblPitchDetails: UILabel!
//            @IBOutlet weak var lblPitchAddress: UILabel!
//            @IBOutlet weak var lblPrice: UILabel!
//            @IBOutlet weak var btnBookNow: UIButton!
//            @IBOutlet weak var lblCurrency: UILabel!
            let imgUrl  = self.Iimage_list![0].link
//            settingsTCell.btnBookNow.tag = indexPath.row
            settingsTCell.imgPitch.sd_setImage(with: URL(string: imgUrl!), placeholderImage: UIImage(named: ""))
            settingsTCell.lblPitchName.text = self.pitch_list[indexPath.row].pitch_name
            settingsTCell.lblPitchDetails.text = self.pitch_list[indexPath.row].pitch_type
            settingsTCell.lblPitchAddress.text = self.pitch_list[indexPath.row].pitch_size
            settingsTCell.lblPrice.text = self.pitch_list[indexPath.row].rate
            if self.pitch_list[indexPath.row].rate_unit! == "Hour"
            {
                settingsTCell.lblCurrency.text = self.pitch_list[indexPath.row].currency! + "/HR"

            }
            else
            {
                settingsTCell.lblCurrency.text = self.pitch_list[indexPath.row].currency! + "/" +  self.pitch_list[indexPath.row].rate_unit!

            }
            if self.pitch_list[indexPath.row].discount!.count > 0
            {
                settingsTCell.imgOffIcon.isHidden = false
                settingsTCell.lblOff.isHidden = false
                settingsTCell.lblOffValue.isHidden = false
                
                settingsTCell.lblOffValue.text = self.pitch_list[indexPath.row].discount! + " " + self.pitch_list[indexPath.row].discount_type!
            }
            else
            {
                settingsTCell.imgOffIcon.isHidden = true
                settingsTCell.lblOff.isHidden = true
                settingsTCell.lblOffValue.isHidden = true
            }
            settingsTCell.btnFavoritesPitchList.tag = indexPath.row
            if self.pitch_list[indexPath.row].favorite_status == "1"
            {
                settingsTCell.btnFavoritesPitchList.setImage(UIImage(named:"PathM"), for: .normal)
            }
             else
            {
                settingsTCell.btnFavoritesPitchList.setImage(UIImage(named:"FavouritesIcon"), for: .normal)

            }
            cell = settingsTCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "BookYourPitchViewController") as! BookYourPitchViewController
        next.sSelectedDate = self.sSelectedDate
        next.sBookingID = ""
        next.sPitchId = String(self.pitch_list[indexPath.row].pitch_id!)
        next.iBookType = self.book_type
        next.iNo_of_Weeks = self.weeks
        next.sPitchName = self.pitch_list[indexPath.row].pitch_name!
        next.sPitchAddress =  self.pitch_list[indexPath.row].location!
        next.sDuration = 0
        next.bFromFav = false

        self.navigationController?.pushViewController(next, animated: false)
      
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.pitch_list == nil || self.pitch_list.count == 0
        {
            return 0
        }
        else
        {
            return self.pitch_list.count

        }
    }
    
    @IBAction func ActionBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: false)
    }
    
    
    func FilterPitchList()
    {
     
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = ["access_token":self.sharedData.getAccessToken(),
                    "book_type":String(self.book_type!),
                    "weeks":String(self.weeks!),
                    "location":self.slocationFromFilter!,
                    "latitude":self.sLatitude!,
                    "longitude":self.sLongitude!,
                    "date":self.sDateFromFilter!,
                    "duration":self.sDurationFromFilter!,
                    "pitch_type":self.sPitch_typeFromFilter!,
                    "pitch_size":self.sPitch_sizeFromFilter!,
                    "pitch_turf":self.sPitch_turfFromFilter!,
                    "start_time":self.sStart_timeFromFilter!,
                    "end_time":self.send_timeFromFilter!,
                    "start_price":self.sStart_priceFromFilter!,
                    "end_price":self.sEnd_priceFromFilter!,
                    "offset":"0",
                    "master":"0"


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
                    
                    self.pitch_list.removeAll()
                    
                    
                    self.pitch_list = (self.filterResponseModel?.filterData?.pitch_list)!
                    
                    
                    self.filter_datas = self.filterResponseModel?.filterData?.filter_datas
                    self.filter_masters = self.filterResponseModel?.filterData?.filter_masters
                    self.durations = self.filter_masters?.durations
                    self.pitch_sizes = self.filter_masters?.pitch_sizes
                    self.pitch_turfs = self.filter_masters?.pitch_turfs
                    self.pitch_types = self.filter_masters?.pitch_types
                    self.user_details = self.filterResponseModel?.filterData?.user_details
                    
                    
                    
                    let statusCode = Int((self.filterResponseModel?.httpcode)!)
                    if statusCode == 200{
                        print("registerResponseModel ----- ",self.filterResponseModel as Any)
                        if self.pitch_list.count > 0
                        {
                            self.tblPitchList.delegate = self
                               self.tblPitchList.dataSource = self
                            self.tblPitchList.reloadData()

                        }
                        else
                        
                        {
//                            self.showToast(message: "No data found")
                            self.presentWindow?.makeToast(message: "No data found", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                        }
                    }
                    if statusCode == 400{

                        self.presentWindow?.makeToast(message: (self.filterResponseModel?.message)!, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

//                        self.showToast(message:(self.filterResponseModel?.message)!)
                    }
                    
                    
                    self.view.activityStopAnimating()
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
    func GetPitchList()
    {
     
        self.view.activityStartAnimating()
        if self.book_type == nil
        {
            self.book_type = 0
        }
        var postDict = Dictionary<String,String>()
        postDict = ["access_token":self.sharedData.getAccessToken(),
                    "book_type":String(self.book_type!),
                    "weeks":String(self.weeks!),
                    "start_time":"05:00",
                    "end_time":"23:59",
                    "date":self.sSelectedDate!,
                    "pitch_type":self.sPitch_typeFromFilter!,
                    "offset":"0",
                    "master":"0"
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
                    self.pitch_list.removeAll()

                    self.filter_datas = self.filterResponseModel?.filterData?.filter_datas
                    self.filter_masters = self.filterResponseModel?.filterData?.filter_masters
                    self.durations = self.filter_masters?.durations
                    self.pitch_sizes = self.filter_masters?.pitch_sizes
                    self.pitch_turfs = self.filter_masters?.pitch_turfs
                    self.pitch_types = self.filter_masters?.pitch_types
                    self.user_details = self.filterResponseModel?.filterData?.user_details
                    self.pitch_list = (self.filterResponseModel?.filterData?.pitch_list)!
                    self.book_type = self.filter_datas?.book_type
                    let statusCode = Int((self.filterResponseModel?.httpcode)!)
                    if statusCode == 200{
                        print("registerResponseModel ----- ",self.filterResponseModel)
                        if self.pitch_list.count > 0
                        {
                            print("Pitch list count:--->", self.pitch_list.count)
                            print("Duration list count:--->", self.durations?.count ?? "0")
                            self.tblPitchList.delegate = self
                            self.tblPitchList.dataSource = self
                            self.tblPitchList.allowsSelection = true
                            self.tblPitchList.reloadData()
                        }
                        else
                        {
//                            self.showToast(message: "No data found")
                            self.presentWindow?.makeToast(message: "No data found", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.


                        }
                        
                      

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
    func AddFavoritePitchDetails(iPItchId:Int)
    {
     
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = ["access_token":self.sharedData.getAccessToken(),
                    "pitch_id":String(iPItchId)
        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.addFavorites
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
                    self.forgotPasswordResponseModel = ForgotPasswordResponseModel(response)
////
//                    self.booking_list_arrays = self.myBookingListResponseModel?.booking_list_arrays
//                    
//                    self.booking_listData = self.booking_list_arrays?.booking_listdata
//                 
                    let statusCode = Int((self.forgotPasswordResponseModel?.httpcode)!)
                    if statusCode == 200
                    {
//                        self.showToast(message:"Pitch added to favorite list")
                        self.presentWindow?.makeToast(message: "Pitch added to favorite list", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                        self.GetPitchList()

                    }
                    if statusCode == 400{

//                        self.showToast(message:(self.forgotPasswordResponseModel?.message)!)
                        self.presentWindow?.makeToast(message: (self.forgotPasswordResponseModel?.message)!, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                    }
                    
                    
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
                    self.forgotPasswordResponseModel = ForgotPasswordResponseModel(response)

                    let statusCode = Int((self.forgotPasswordResponseModel?.httpcode)!)
                    if statusCode == 200{
                        print("registerResponseModel ----- ",self.forgotPasswordResponseModel)
 
//                        self.showToast(message:"Pitch removed from favorite list")
                        self.presentWindow?.makeToast(message: "Pitch removed from favorite list", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                        self.GetPitchList()
                        
                    
                    }
                    if statusCode == 400{

//                        self.showToast(message:(self.forgotPasswordResponseModel?.message)!)
                        self.presentWindow?.makeToast(message: (self.forgotPasswordResponseModel?.message)!, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

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
    
    @IBAction func ActionMap(_ sender: Any)
    {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    
    
}
