//
//  FilterScreenViewController.swift
//  GameDay
//
//  Created by MAC on 29/12/20.
//

import UIKit
import ImageSlideshow
import FlexibleSteppedProgressBar
import Alamofire
import SwiftyJSON
import iOSDropDown

class FilterScreenViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,FlexibleSteppedProgressBarDelegate,UICollectionViewDelegateFlowLayout {
    let sharedData = SharedDefault()
    var filterResponseModel : FilterResponseModel?
    var filterData : FilterData?
    var book_type : Int?
    var sSelectedTypeName = String()
    var presentWindow : UIWindow?
    var sSelectedDuration:String?
    var sSelectedPitchType:String?
    var sSelectedPitchTurf: String?
    var sSelectedPitchSize:String?
    @IBOutlet var turfCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet var sizeCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet var typeCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet var durationCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet var pricerangeSlider: RangeSeekSlider!
    @IBOutlet var timerRangeSeeker: RangeSeekSlider!
    @IBOutlet var lblStartTimerValue: UILabel!
    @IBOutlet var lblEndTimerValue: UILabel!
    var book_type_Status : Int?
    var sPitch_typeNameFromFilter : String?

    var iLocationType : Int?

    var weeks : Int?
    var sLatitude : String?
    var sLongitude : String?
    
    var sSelectetdEndTime : String?
    var sSelectedStartTime : String?

    var sMaxPriceOfFilter:Int?
    var sMinPriceOfFilter:Int?

    
    
    var iDurationId : Int?
    var iPitchSize_id : Int?
    var iPitchTurf_Id : Int?
    var iPitchType_Id : Int?

    var user_details: User_details?
    var Iimage_list: [image_list]?
    @IBOutlet weak var txtDropSownWeekly: DropDown!
    @IBOutlet weak var btnWeeklyBooking: UIButton!
    @IBOutlet weak var btnSingleBooking: UIButton!
    var arrayDropDownWeekly = ["2 weeks","3 weeks","4 weeks","5 weeks","6 weeks","7 weeks","8 weeks","9 weeks","10 weeks","11 weeks","12 weeks",]

    @IBOutlet weak var lblStartPrize: UILabel!
    
    @IBOutlet weak var lblEndPrice: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
    
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var btnPrice4: UIButton!
    @IBOutlet weak var btnPrice3: UIButton!
    @IBOutlet weak var btnPrice2: UIButton!
    @IBOutlet weak var btnPrice1: UIButton!
    @IBOutlet weak var btntime4: UIButton!
    @IBOutlet weak var btnTime3: UIButton!
    @IBOutlet weak var btnTime2: UIButton!
    @IBOutlet weak var btnTime1: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewBase: UIView!
    @IBOutlet weak var btnLetsGo: UIButton!
    @IBOutlet weak var PriceProgress: FlexibleSteppedProgressBar!
    @IBOutlet weak var TimeProgress: FlexibleSteppedProgressBar!
    @IBOutlet weak var TurfCollection: UICollectionView!
    @IBOutlet weak var sizeCollection: UICollectionView!
    @IBOutlet weak var typeCollection: UICollectionView!
    @IBOutlet weak var durationCollection: UICollectionView!
    @IBOutlet weak var txtSelectedDate: UITextField!
    @IBOutlet weak var viewSelectedDate: UIView!
    @IBOutlet weak var btnMap: UIButton!
    @IBOutlet weak var btnNearMe: UIButton!
    @IBOutlet weak var btnAny: UIButton!
    @IBOutlet weak var imgSlideShow: ImageSlideshow!
    @IBOutlet weak var lblInImageView: UILabel!
    @IBOutlet weak var lblHeading: UIButton!
    let datePickerView:UIDatePicker = UIDatePicker()
    let datePickerViewForDemo:UIDatePicker = UIDatePicker()
    var sSelectedButton1 = String()
    var sSelectedButton2 = String()
    var sSelectedButton3 = String()
    var sSelectedButton4 = String()
    
    var filter_datas: filter_data?
    var filter_masters: filter_master?
    var durations: [Durations]?
    var durationsInfo: [Durations]?

    
    
    var durationData:Durations?
    var pitch_sizesData:Pitch_sizes?
    var pitch_turfData:Pitch_turfs?
    var pitch_typesData:Pitch_typess?
    var pitch_listData:Pitch_list?

    var pitch_sizes: [Pitch_sizes]?
    var pitch_turfs: [Pitch_turfs]?
    var pitch_types: [Pitch_typess]?
    
    var pitch_sizesInfo: [Pitch_sizes]?
    var pitch_turfsInfo: [Pitch_turfs]?
    var pitch_typesInfo: [Pitch_typess]?
    var pitch_list = [Pitch_list]()

    var sSelectedDate = String()

    var bCheckingTimeProgress1:Bool = false
    var bCheckingTimeProgress2:Bool = false
    
    var bCheckingTimeProgress3:Bool = false
    var bCheckingTimeProgress4:Bool = false
    
    var bCheckingPriceProgress1:Bool = false
    var bCheckingPriceProgress2:Bool = false
    
    var bCheckingPriceProgress3:Bool = false
    var bCheckingPriceProgress4:Bool = false
    
//    var progressColor = UIColor(red: 42.0 / 255.0, green: 43.0 / 255.0, blue: 44.0 / 255.0, alpha: 1.0)
    var maxIndex = -1
    var progressColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
    var textColorHere = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
    var backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
    
    var arrayDuration = ["Any","60 min", "90 min","120 min"]
    var arrayType = ["Any","Indoor", "Outdoor"]
    var arraySize = ["Any","5 A Side","6 A Side", "7 A side","8 A Side", "9 A side","10 A Side", "11 A side"]
    var arrayTurf = ["Any","Field Turf", "Astro Turf","Sprint Turf"]

    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.sSelectedDuration = "0"
        self.sSelectedPitchSize = "0"
        self.sSelectedPitchTurf = "0"
        self.sSelectedPitchType = "0"
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.book_type_Status = 0
        self.book_type = 0
        presentWindow = UIApplication.shared.keyWindow
        UIView.hr_setToastThemeColor(color: UIColor.white)
        UIView.hr_setToastFontColor(color: self.hexStringToUIColor(hex: "#6fc13a"))
        UIView.hr_setToastFontName(fontName: "TTOctosquares-Medium")
                self.weeks = 0
        self.GetFilterMasterListDetails()
        self.txtDropSownWeekly.optionArray = arrayDropDownWeekly
        self.txtDropSownWeekly.didSelect{(selectedText , index ,id) in
            print("selectedText ----- ",selectedText)
            
            
          

            
            self.book_type_Status = 2
            self.book_type = 1

            if selectedText == "2 weeks"
            {
                self.weeks = 2
            }
            else if selectedText == "3 weeks"
            {
                self.weeks = 3

            }
            else if selectedText == "4 weeks"
            {
                self.weeks = 4

            }
            else if selectedText == "5 weeks"
            {
                self.weeks = 5

            }
            else if selectedText == "6 weeks"
            {
                self.weeks = 6

            }
            else if selectedText == "7 weeks"
            {
                self.weeks = 7

            }
            else if selectedText == "8 weeks"
            {
                self.weeks = 8

            } else if selectedText == "9 weeks"
            {
                self.weeks = 9

            } else if selectedText == "10 weeks"
            {
                self.weeks = 10

            }
            else if selectedText == "11 weeks"
            {
                self.weeks = 11

            } else if selectedText == "12 weeks"
            {
                self.weeks = 12

            }
            
            
            
            self.btnWeeklyBooking.setTitle(self.arrayDropDownWeekly[index], for: .normal)

            self.btnWeeklyBooking.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
            self.btnWeeklyBooking.layer.borderColor = UIColor(red: 42.0/255.0, green: 43.0/255.0, blue: 44.0/255.0, alpha: 1.0).cgColor
            self.btnWeeklyBooking.layer.borderWidth = 0.5
            self.btnWeeklyBooking.setTitleColor(.black, for: .normal)

            self.txtSelectedDate.isEnabled = true
            
            self.btnSingleBooking.backgroundColor = UIColor.clear
            self.btnSingleBooking.layer.borderColor = UIColor.lightGray.cgColor
            self.btnSingleBooking.layer.borderWidth = 0.5
            self.btnSingleBooking.setTitleColor(.white, for: .normal)
            
        }
        
   
        
        self.SetUI()
    }
    @IBAction func ACtionweeklyBooking(_ sender: Any)
    {
        self.btnWeeklyBooking.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
        self.btnWeeklyBooking.layer.borderColor = UIColor(red: 42.0/255.0, green: 43.0/255.0, blue: 44.0/255.0, alpha: 1.0).cgColor
        self.btnWeeklyBooking.layer.borderWidth = 0.5
        self.btnWeeklyBooking.setTitleColor(.black, for: .normal)
        self.txtSelectedDate.isEnabled = true

        self.book_type = 1
        self.book_type_Status =  2
        self.btnSingleBooking.backgroundColor = UIColor.clear
        self.btnSingleBooking.layer.borderColor = UIColor.lightGray.cgColor
        self.btnSingleBooking.layer.borderWidth = 0.5
        self.btnSingleBooking.setTitleColor(.white, for: .normal)

        
    }
    
    
    @IBAction func ActionSingle_Weekly_Booking(_ sender: Any)
    {
        self.btnWeeklyBooking.backgroundColor = UIColor.clear
        self.btnWeeklyBooking.layer.borderColor = UIColor.lightGray.cgColor
        self.btnWeeklyBooking.layer.borderWidth = 0.5
        self.btnWeeklyBooking.setTitleColor(.white, for: .normal)

        self.btnWeeklyBooking.setTitle("Weekly Booking", for: .normal)
        self.book_type = 0
        self.book_type_Status =  1
        self.txtSelectedDate.isEnabled = true

        self.btnSingleBooking.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
        self.btnSingleBooking.layer.borderColor = UIColor(red: 42.0/255.0, green: 43.0/255.0, blue: 44.0/255.0, alpha: 1.0).cgColor
        self.btnSingleBooking.layer.borderWidth = 0.5
        self.btnSingleBooking.setTitleColor(.black, for: .normal)

    }

    
    
    
    
    
    func setupProgressBarWithoutLastState() {
//        PriceProgress = FlexibleSteppedProgressBar()

        PriceProgress.numberOfPoints = 5
        PriceProgress.lineHeight = 3
        PriceProgress.radius = 5
        PriceProgress.progressRadius = 10
        PriceProgress.progressLineHeight = 2
        PriceProgress.delegate = self
        PriceProgress.selectedBackgoundColor = progressColor
        PriceProgress.currentSelectedCenterColor = progressColor
        PriceProgress.stepTextColor = progressColor
        
        PriceProgress.currentIndex = 0
        
        TimeProgress.numberOfPoints = 5
        TimeProgress.lineHeight = 3
        TimeProgress.radius = 5
        TimeProgress.progressRadius = 10
        TimeProgress.progressLineHeight = 2
        TimeProgress.delegate = self
        TimeProgress.selectedBackgoundColor = progressColor
        TimeProgress.currentSelectedCenterColor = progressColor
        TimeProgress.stepTextColor = progressColor
        TimeProgress.centerLayerDarkBackgroundTextColor = progressColor
        TimeProgress.currentIndex = 0
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     didSelectItemAtIndex index: Int) {
        progressBar.currentIndex = index
        if index > maxIndex {
            maxIndex = index
            progressBar.completedTillIndex = maxIndex
        }
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     canSelectItemAtIndex index: Int) -> Bool {
        return true
    }
    
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     textAtIndex index: Int, position: FlexibleSteppedProgressBarTextLocation) -> String {
        if progressBar == self.TimeProgress  {
            if position == FlexibleSteppedProgressBarTextLocation.top {
                switch index {
                    
                case 0: return ""
                case 1: return ""
                case 2: return ""
                case 3: return ""
                case 4: return ""
                default: return ""
                    
                }
            } else if position == FlexibleSteppedProgressBarTextLocation.bottom {
                switch index {
                    
                case 0: return "5 pm"
                case 1: return "8 pm"
                case 2: return "10 pm"
                case 3: return "12 pm"
                case 4: return "1 am"
                default: return ""
                    
                }
                
            } else if position == FlexibleSteppedProgressBarTextLocation.center {
                switch index {
                    
                case 0: return ""
                case 1: return ""
                case 2: return ""
                case 3: return ""
                case 4: return ""
                default: return ""
                    
                }
            }
        }
        else if progressBar == self.PriceProgress  {
            if position == FlexibleSteppedProgressBarTextLocation.top {
                switch index {
                    
                case 0: return ""
                case 1: return ""
                case 2: return ""
                case 3: return ""
                case 4: return ""
                default: return ""
                    
                }
            } else if position == FlexibleSteppedProgressBarTextLocation.bottom {
                switch index {
                    
                case 0: return "200"
                case 1: return "300"
                case 2: return "400"
                case 3: return "500"
                case 4: return "600"
                default: return "700"
                    
                }
                
            } else if position == FlexibleSteppedProgressBarTextLocation.center {
                switch index {
                    
                case 0: return ""
                case 1: return ""
                case 2: return ""
                case 3: return ""
                case 4: return ""
                default: return ""
                    
                }
            }
        }
        return ""
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
    
    
    
    @IBAction func ActionBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: false)

    }
    @IBAction func ActionLetsGo(_ sender: Any)
    {
        
        
//        if iLocationType == 0
//        {
//            self.showToast(message: "Please select location type")
//
//        }
//
//       else  if self.book_type_Status ==  0 ||   self.book_type_Status == nil
//       {
//            self.showToast(message: "Please select booking type")
//
//        }
//       else  if self.book_type == 1 && self.weeks == 0
//        {
//
//                self.showToast(message: "Please select no:of weeks")
//
//
//
//        }
//
//      else  if self.iDurationId == 0 ||  self.iDurationId == nil
//        {
//            self.showToast(message: "Please select duration")
//        }
//       else if iPitchSize_id == 0 ||  self.iPitchSize_id == nil
//        {
//            self.showToast(message: "Please select pitch size")
//
//        }
//       else if iPitchTurf_Id == 0 ||  self.iPitchTurf_Id == nil
//        {
//            self.showToast(message: "Please select turf")
//
//        }
//       else  if iPitchType_Id == 0 ||  self.iPitchType_Id == nil
//        {
//            self.showToast(message: "Please select pitch type")
//
//        }
//        else
//        {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "PItchListViewController") as! PItchListViewController
        
            if iLocationType == 1
            {
                self.sharedData.setFilterLocation(token: "Any")

            }
            else if iLocationType == 2
            {
                self.sharedData.setFilterLocation(token: "NearMe")

            }
            else if iLocationType == 3
            {
                self.sharedData.setFilterLocation(token: "Map")

            }else if iLocationType == 0 ||  iLocationType == nil
            {
                self.sharedData.setFilterLocation(token: "Any")

            }
            self.sharedData.setFilterBookingType(token: String(self.book_type!))
            self.sharedData.setFilterBookingTypeWeeks(token: String(self.weeks!))
            
            if txtSelectedDate.text?.count == 0 ||  txtSelectedDate.text == nil
            {
                self.sharedData.setFilterBookingSelectedDate(token: Date.getCurrentDate())
            }
            else
            {
                self.sharedData.setFilterBookingSelectedDate(token: txtSelectedDate.text!)

            }
            
            
            
        next.sPitch_typeNameFromFilter = sSelectedTypeName
            
            if sSelectedTypeName.count == 0
            {
                next.sPitch_typeNameFromFilter = self.sPitch_typeNameFromFilter

            }
        next.book_type = self.book_type
        next.weeks = self.weeks
        next.bFromFilter = 1
        next.slocationFromFilter = "Any"
        next.sLatitude = self.sLatitude
        next.sLongitude = self.sLongitude
            
        self.sharedData.setFilterDurationId(token: String(self.iDurationId ?? 0))
        next.sDurationFromFilter = String(self.iDurationId ?? 0) // duration id
            
        self.sharedData.setFilterPitchTypeId(token: String(self.iPitchType_Id ?? 0))
        next.sPitch_typeFromFilter = String(self.iPitchType_Id ?? 0) // Selected Pitch type id
            
            
        self.sharedData.setFilterPitchSizeId(token: String(self.iPitchSize_id ?? 0))
        next.sPitch_sizeFromFilter = String(self.iPitchSize_id ?? 0) // Selected Pitch size id
            
            
        self.sharedData.setFilterPitchTurfId(token: String(self.iPitchTurf_Id ?? 0))
        next.sPitch_turfFromFilter = String(self.iPitchTurf_Id ?? 0) // Selected Pitch turf id
            
            self.sharedData.setFilterStartPrize(token: self.lblStartPrize.text ?? "")
            self.sharedData.setFilterSelectedEndPrize(token: self.lblEndPrice.text ?? "")
            
            if self.sSelectedStartTime!.count > 0
            {
                self.sharedData.setFilterStartTime(token: self.sSelectedStartTime ?? "")

            }
            if self.sSelectetdEndTime!.count > 0
            {
                self.sharedData.setFilterSelectedEndTime(token: self.sSelectetdEndTime ?? "")

            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"

            let date = dateFormatter.date(from: lblStartTimerValue.text ?? "")
            dateFormatter.dateFormat = "HH:mm"

            let Date24 = dateFormatter.string(from: date!)
            
            
            let selectedTime = Date24
            
            
            
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "hh:mm a"
            
            
            let date1 = dateFormatter1.date(from: lblEndTimerValue.text ?? "")
            dateFormatter1.dateFormat = "HH:mm"

            let Date241 = dateFormatter1.string(from: date1!)
            
            let selectedTime1 = Date241

  

        next.sStart_timeFromFilter = selectedTime
        next.send_timeFromFilter = selectedTime1
            
        next.sStart_priceFromFilter = self.lblStartPrize.text
        next.sEnd_priceFromFilter = self.lblEndPrice.text
            
            
        if self.weeks! > 0
        {
            next.sDateFromFilter = Date.getCurrentDate()

        }
        else
        {
            next.sDateFromFilter = txtSelectedDate.text

        }
            if txtSelectedDate.text?.count == 0
            {
                next.sSelectedDate = Date.getCurrentDate()

            }
            else
            {
                next.sSelectedDate = txtSelectedDate.text

            }

        self.navigationController?.pushViewController(next, animated: false)
//        self.navigationController?.popViewController(animated: false)
//        }
    }
    
    
    
    @IBAction func ActionClear(_ sender: Any)
    {
        self.sharedData.clearFilterData()
        // Filter Data
        if UserDefaults.standard.value(forKey: "FilterLocation") == nil || UserDefaults.standard.value(forKey: "FilterLocation") as! String == ""
        {
            self.sharedData.setFilterLocation(token: "")

        }
        
        if UserDefaults.standard.value(forKey: "FilterBookingType") == nil || UserDefaults.standard.value(forKey: "FilterBookingType") as! String == ""
        {
            self.sharedData.setFilterBookingType(token: "")

        }
        if UserDefaults.standard.value(forKey: "FilterBookingTypeWeeks") == nil || UserDefaults.standard.value(forKey: "FilterBookingTypeWeeks") as! String == ""
        {
            self.sharedData.setFilterBookingTypeWeeks(token: "")

        }
        if UserDefaults.standard.value(forKey: "FilterBookingSelectedDate") == nil || UserDefaults.standard.value(forKey: "FilterBookingSelectedDate") as! String == ""
        {
            self.sharedData.setFilterBookingSelectedDate(token: "")

        }
        if UserDefaults.standard.value(forKey: "FilterDurationId") == nil || UserDefaults.standard.value(forKey: "FilterDurationId") as! String == ""
        {
            self.sharedData.setFilterDurationId(token: "")

        }
        if UserDefaults.standard.value(forKey: "FilterPitchTypeId") == nil || UserDefaults.standard.value(forKey: "FilterPitchTypeId") as! String == ""
        {
            self.sharedData.setFilterPitchTypeId(token: "")

        }
        if UserDefaults.standard.value(forKey: "FilterPitchSizeId") == nil || UserDefaults.standard.value(forKey: "FilterPitchSizeId") as! String == ""
        {
            self.sharedData.setFilterPitchSizeId(token: "")

        }
        if UserDefaults.standard.value(forKey: "FilterPitchTurfId") == nil || UserDefaults.standard.value(forKey: "FilterPitchTurfId") as! String == ""
        {
            self.sharedData.setFilterPitchTurfId(token: "")

        }
        if UserDefaults.standard.value(forKey: "FilterStartTime") == nil || UserDefaults.standard.value(forKey: "FilterStartTime") as! String == ""
        {
            self.sharedData.setFilterStartTime(token: "")

        }
        if UserDefaults.standard.value(forKey: "FilterSelectedEndTime") == nil || UserDefaults.standard.value(forKey: "FilterSelectedEndTime") as! String == ""
        {
            self.sharedData.setFilterSelectedEndTime(token: "")

        }
        if UserDefaults.standard.value(forKey: "FilterStartPrize") == nil || UserDefaults.standard.value(forKey: "FilterStartPrize") as! String == ""
        {
            self.sharedData.setFilterStartPrize(token: "")

        }
        if UserDefaults.standard.value(forKey: "FilterSelectedEndPrize") == nil || UserDefaults.standard.value(forKey: "FilterSelectedEndPrize") as! String == ""
        {
            self.sharedData.setFilterSelectedEndPrize(token: "")

        }
        
        self.btnAny.backgroundColor = UIColor.clear
        self.btnAny.layer.borderColor = UIColor.lightGray.cgColor
        self.btnAny.layer.borderWidth = 0.5
        self.btnAny.setTitleColor(.white, for: .normal)

        self.btnNearMe.backgroundColor = UIColor.clear
        self.btnNearMe.layer.borderColor = UIColor.lightGray.cgColor
        self.btnNearMe.layer.borderWidth = 0.5
        self.btnNearMe.setTitleColor(.white, for: .normal)
        
        
        self.btnSingleBooking.backgroundColor = UIColor.clear
        self.btnSingleBooking.layer.borderColor = UIColor.lightGray.cgColor
        self.btnSingleBooking.layer.borderWidth = 0.5
        self.btnSingleBooking.setTitleColor(.white, for: .normal)
        self.book_type = 0
        self.book_type_Status =  1
        self.btnWeeklyBooking.backgroundColor = UIColor.clear
        self.btnWeeklyBooking.layer.borderColor = UIColor.lightGray.cgColor
        self.btnWeeklyBooking.layer.borderWidth = 0.5
        self.btnWeeklyBooking.setTitleColor(.white, for: .normal)
        self.btnWeeklyBooking.setTitle("Weekly Booking", for: .normal)

        self.txtSelectedDate.text = ""

//        self.timerRangeSeeker.selectedMaxValue = 5000.0
//        self.timerRangeSeeker.selectedMinValue = 0.0
        self.pricerangeSlider.selectedMinValue = 0.0
        self.pricerangeSlider.selectedMaxValue = 86400.0
        
        self.pricerangeSlider.reloadInputViews()

        self.lblStartTimerValue.text = self.getTodayString()
        self.lblEndTimerValue.text = "11:59 PM"
        
        self.lblStartPrize.text = String((self.filter_masters?.min_price)!)
        self.lblEndPrice.text = String((self.filter_masters?.max_price)!)
        self.timerRangeSeeker.delegate = self
        self.pricerangeSlider.delegate = self
        self.timerRangeSeeker.minValue = CGFloat(self.sMinPriceOfFilter!)
        self.timerRangeSeeker.maxValue = CGFloat(self.sMaxPriceOfFilter!)
        self.timerRangeSeeker.selectedMaxValue = CGFloat(self.sMaxPriceOfFilter!)
        self.timerRangeSeeker.selectedMinValue = 0.0
        self.timerRangeSeeker.reloadInputViews()
        
        
        
        self.durationCollection.reloadData()
        self.TurfCollection.reloadData()
        self.sizeCollection.reloadData()
        self.typeCollection.reloadData()

    }
    
    
    
    
    
    
    
    @IBAction func ActionMap(_ sender: Any) {
        
        
        self.iLocationType = 3
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        self.navigationController?.pushViewController(next, animated: true)
    }
    @IBAction func ActionNearMe(_ sender: Any)
    {

        
        self.iLocationType = 2

        
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "CurrentMapViewController") as! CurrentMapViewController
        self.navigationController?.pushViewController(next, animated: true)

        
    }
    
    @IBAction func ActionAny(_ sender: Any)
    {
        self.btnNearMe.backgroundColor = UIColor.clear
        self.btnNearMe.layer.borderColor = UIColor.lightGray.cgColor
        self.btnNearMe.layer.borderWidth = 0.5
        self.btnNearMe.setTitleColor(.white, for: .normal)

        self.iLocationType = 1

        self.btnAny.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
        self.btnAny.layer.borderColor = UIColor(red: 42.0/255.0, green: 43.0/255.0, blue: 44.0/255.0, alpha: 1.0).cgColor
        self.btnAny.layer.borderWidth = 0.5
        self.btnAny.setTitleColor(.black, for: .normal)
    }
    
    
    func SetUI()
    {
        
        self.sSelectedStartTime = ""
        self.sSelectetdEndTime = ""
       
        self.durationCollection.delegate = self
        self.typeCollection.delegate = self
        self.sizeCollection.delegate = self
        self.TurfCollection.delegate = self
//        self.setupProgressBarWithoutLastState()
        self.scrollView.isScrollEnabled = true
//        btnSingleBooking.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
        btnSingleBooking.backgroundColor = UIColor.clear
        self.btnSingleBooking.setTitleColor(.white, for: .normal)
        self.btnWeeklyBooking.setTitleColor(.white, for: .normal)

        
        pricerangeSlider.enableStep = true
        pricerangeSlider.step = 1
        
        pricerangeSlider.delegate = self
        timerRangeSeeker.delegate = self


        print(getTodayString())
        
        self.lblStartTimerValue.text = self.getTodayString()
        self.lblEndTimerValue.text = "11:59 PM"

        btnWeeklyBooking.layer.borderWidth = 1
        btnWeeklyBooking.layer.borderColor = UIColor.lightGray.cgColor
        btnSingleBooking.layer.borderWidth = 1
        btnSingleBooking.layer.borderColor = UIColor.lightGray.cgColor
        let pageIndicator = UIPageControl()
        pageIndicator.frame = CGRect(x: pageIndicator.frame.origin.x, y: pageIndicator.frame.origin.y, width: pageIndicator.frame.size.width, height: 0)
        pageIndicator.currentPageIndicatorTintColor = UIColor.white
        pageIndicator.pageIndicatorTintColor = UIColor.lightGray
        pageIndicator.layer.cornerRadius = 10.0
        pageIndicator.sizeToFit()
        imgSlideShow.pageIndicator = pageIndicator
        imgSlideShow.contentScaleMode = .scaleToFill
        imgSlideShow.slideshowInterval = 2.0
        imgSlideShow.setImageInputs([ImageSource(image: UIImage(named: "bg_filter")!)])
        btnAny.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
        btnLetsGo.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
        viewBase.clipsToBounds = true
        viewBase.layer.cornerRadius = 35
        viewBase.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively
//        btnOutDoor.layer.borderWidth = 1
        viewSelectedDate.layer.borderWidth = 1
        btnNearMe.layer.borderWidth = 1
        
        viewSelectedDate.layer.borderColor = UIColor.lightGray.cgColor
        btnNearMe.layer.borderColor = UIColor.lightGray.cgColor
        
        
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker))]
        numberToolbar.sizeToFit()
        
        txtSelectedDate.inputAccessoryView = numberToolbar
        datePickerViewForDemo.datePickerMode = UIDatePicker.Mode.date
        txtSelectedDate.inputView = datePickerViewForDemo
        datePickerViewForDemo.addTarget(self, action: #selector(self.datePickerDemoFromValueChanged), for: UIControl.Event.valueChanged)
        if #available(iOS 13.4, *) {
            datePickerViewForDemo.preferredDatePickerStyle = .wheels
        }
        datePickerViewForDemo.minimumDate = NSDate() as Date

        txtSelectedDate.attributedPlaceholder = NSAttributedString(string: " Select Date",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        
        if self.sharedData.getFilterLocation() == "Any" && self.sharedData.getFilterLocation() != nil
        {
            self.btnNearMe.backgroundColor = UIColor.clear
            self.btnNearMe.layer.borderColor = UIColor.lightGray.cgColor
            self.btnNearMe.layer.borderWidth = 0.5
            self.btnNearMe.setTitleColor(.white, for: .normal)

            
            self.btnAny.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
            self.btnAny.layer.borderColor = UIColor(red: 42.0/255.0, green: 43.0/255.0, blue: 44.0/255.0, alpha: 1.0).cgColor
            self.btnAny.layer.borderWidth = 0.5
            self.btnAny.setTitleColor(.black, for: .normal)
        }
        else if self.sharedData.getFilterLocation() == "NearMe" && self.sharedData.getFilterLocation() != nil
        {
            self.btnAny.backgroundColor = UIColor.clear
            self.btnAny.layer.borderColor = UIColor.lightGray.cgColor
            self.btnAny.layer.borderWidth = 0.5
            self.btnAny.setTitleColor(.white, for: .normal)

            
            self.btnNearMe.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
            self.btnNearMe.layer.borderColor = UIColor(red: 42.0/255.0, green: 43.0/255.0, blue: 44.0/255.0, alpha: 1.0).cgColor
            self.btnNearMe.layer.borderWidth = 0.5
            self.btnNearMe.setTitleColor(.black, for: .normal)
        }
        else
        {
            self.btnAny.backgroundColor = UIColor.clear
            self.btnAny.layer.borderColor = UIColor.lightGray.cgColor
            self.btnAny.layer.borderWidth = 0.5
            self.btnAny.setTitleColor(.white, for: .normal)
            self.sharedData.setFilterLocation(token: "Map")

            self.btnNearMe.backgroundColor = UIColor.clear
            self.btnNearMe.layer.borderColor = UIColor.lightGray.cgColor
            self.btnNearMe.layer.borderWidth = 0.5
            self.btnNearMe.setTitleColor(.white, for: .normal)


        }
        
        
        
        if self.sharedData.getFilterBookingType() == "0" && self.sharedData.getFilterBookingType() != nil
        {
            self.btnWeeklyBooking.backgroundColor = UIColor.clear
            self.btnWeeklyBooking.layer.borderColor = UIColor.lightGray.cgColor
            self.btnWeeklyBooking.layer.borderWidth = 0.5
            self.btnWeeklyBooking.setTitleColor(.white, for: .normal)

            self.btnWeeklyBooking.setTitle("Weekly Booking", for: .normal)
            self.book_type = 0
            self.book_type_Status =  1

            self.btnSingleBooking.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
            self.btnSingleBooking.layer.borderColor = UIColor(red: 42.0/255.0, green: 43.0/255.0, blue: 44.0/255.0, alpha: 1.0).cgColor
            self.btnSingleBooking.layer.borderWidth = 0.5
            self.btnSingleBooking.setTitleColor(.black, for: .normal)
        }
        else if  self.sharedData.getFilterBookingType() == "1"  && self.sharedData.getFilterBookingType() != nil
        {
            self.btnWeeklyBooking.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
            self.btnWeeklyBooking.layer.borderColor = UIColor(red: 42.0/255.0, green: 43.0/255.0, blue: 44.0/255.0, alpha: 1.0).cgColor
            self.btnWeeklyBooking.layer.borderWidth = 0.5
            self.btnWeeklyBooking.setTitleColor(.black, for: .normal)
            self.weeks = Int(self.sharedData.getFilterBookingTypeWeeks())
            self.btnWeeklyBooking.setTitle(self.sharedData.getFilterBookingTypeWeeks() + " weeks", for: .normal)

            self.book_type = 1
            self.book_type_Status =  2
            self.btnSingleBooking.backgroundColor = UIColor.clear
            self.btnSingleBooking.layer.borderColor = UIColor.lightGray.cgColor
            self.btnSingleBooking.layer.borderWidth = 0.5
            self.btnSingleBooking.setTitleColor(.white, for: .normal)
        }
        else
        {
            self.btnSingleBooking.backgroundColor = UIColor.clear
            self.btnSingleBooking.layer.borderColor = UIColor.lightGray.cgColor
            self.btnSingleBooking.layer.borderWidth = 0.5
            self.btnSingleBooking.setTitleColor(.white, for: .normal)
            self.book_type = 0
            self.book_type_Status =  1
            self.btnWeeklyBooking.backgroundColor = UIColor.clear
            self.btnWeeklyBooking.layer.borderColor = UIColor.lightGray.cgColor
            self.btnWeeklyBooking.layer.borderWidth = 0.5
            self.btnWeeklyBooking.setTitleColor(.white, for: .normal)
        }
        
        if self.sharedData.getFilterBookingSelectedDate().count == 0 || self.sharedData.getFilterBookingSelectedDate() == nil
        {
            self.txtSelectedDate.text = ""
        }
        else
        {
            self.txtSelectedDate.text = self.sharedData.getFilterBookingSelectedDate()

        }
       
        
        if self.sharedData.getFilterStartTime() == nil || self.sharedData.getFilterStartTime().count == 0
        {


//            self.pricerangeSlider.selectedMinValue = 0.0
//            self.pricerangeSlider.minValue = 60.0
//
//            self.lblStartTimerValue.text = self.getTodayString()

            
        }
        else
        {


            
            let  minutes_Min = Int(self.sharedData.getFilterStartTime())

            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            
            let sCurrentTime = self.getTodayString()
            
            var parsed = sCurrentTime.replacingOccurrences(of: " AM", with: "")
            parsed = sCurrentTime.replacingOccurrences(of: " PM", with: "")
            
            
        let dateStart = formatter.date(from:  sCurrentTime)
            let tenMinutesLater = Calendar.current.date(byAdding: .second, value: minutes_Min!, to: dateStart!)!
        print(formatter.string(from: tenMinutesLater))
        self.lblStartTimerValue.text = formatter.string(from: tenMinutesLater)
            
            
            guard let n = NumberFormatter().number(from: self.sharedData.getFilterStartTime()) else { return }

            self.pricerangeSlider.minValue = 60.0
            
            self.pricerangeSlider.selectedMinValue = CGFloat(truncating: n)
            
            
        }
        

        
        if self.sharedData.getFilterSelectedEndTime() == nil || self.sharedData.getFilterSelectedEndTime().count == 0
        {
//            self.pricerangeSlider.selectedMaxValue = 86400
//            self.pricerangeSlider.maxValue = 86400
//
//            self.lblEndTimerValue.text = "12:00 AM"
        }
        else
        {


            guard let n = NumberFormatter().number(from: self.sharedData.getFilterSelectedEndTime()) else { return }

            
            
            self.pricerangeSlider.selectedMaxValue = CGFloat(truncating: n)
            
            
            var sdatee = self.formatTimeInSec(totalSeconds: Int(self.sharedData.getFilterSelectedEndTime())!)
            
            sdatee = self.timeConversion12(time24: sdatee)
            self.lblEndTimerValue.text = sdatee

        }
        self.iDurationId = Int(self.sharedData.getFilterDurationId())
        self.iPitchSize_id = Int(self.sharedData.getFilterPitchSizeId())
        self.iPitchTurf_Id = Int(self.sharedData.getFilterPitchTurfId())
        self.iPitchType_Id = Int(self.sharedData.getFilterPitchTypeId())


    }
    
    
    
    func getTodayString() -> String{

                    let date = Date()
                    let calender = Calendar.current
                    let components = calender.dateComponents([.hour,.minute], from: date)

                    
                    let hour = components.hour
                    let minute = components.minute

        var today_string =  String(hour!)  + ":" + String(minute!)

        
        today_string = self.timeConversion12(time24: today_string)
        return today_string

                }
    
    
    
    
    func timeConversion12(time24: String) -> String {
        let dateAsString = time24
        let df = DateFormatter()
        df.dateFormat = "HH:mm"

        let date = df.date(from: dateAsString)
        df.dateFormat = "hh:mm a"
        
        if time24 == "24:00"
        {
            return "12:00 AM"

        }
         else
        {
            if date == nil
              {
                return ""

               }
            else
            
            {
                let time12 = df.string(from: date!)
                print(time12)
                return time12
        }
           
        }
        
    }
    
    func timeConversion12AMPM(time24: String) -> String {
        let dateAsString = time24
        let df = DateFormatter()
        df.dateFormat = "HH:mm"

        let date = df.date(from: dateAsString)
        df.dateFormat = "hh a"

        let time12 = df.string(from: date!)
        print(time12)
        return time12
    }
    
    
    @objc func cancelPicker() {
        
        view.endEditing(true)
        
        
    }
    @objc func donePicker()
    {
        view.endEditing(true)
        
        if txtSelectedDate.text?.count == 0
        {
            txtSelectedDate.text = Date.getCurrentDate()
        }

    }
    @objc func datePickerDemoFromValueChanged(sender:UIDatePicker)
    {
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd" //"dd-MM-yyyy""HH:mm:ss"
        
        dateFormatter.dateFormat = "yyyy-MM-dd" //"dd-MM-yyyy""HH:mm:ss"
        
//        self.sSelectedDate = dateFormatter.string(from: sender.date)

        
        dateFormatter.dateFormat = "yyyy-MM-dd" //"dd-MM-yyyy""HH:mm:ss"

        
        //specialDateTextField.text = dateFormatter.string(from: sender.date)
        print("Selected date ::: ",dateFormatter.string(from: sender.date))
        txtSelectedDate.text = dateFormatter.string(from: sender.date)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var countVar:Int = 0
        if collectionView == durationCollection
        {
            countVar = self.durations?.count ?? 0
        }
        else if collectionView == typeCollection
        {
            countVar = self.pitch_types?.count ?? 0
        }
        else if collectionView == sizeCollection
        {
            countVar = self.pitch_sizes?.count ?? 0
        }
        else if collectionView == TurfCollection
        {
            countVar = self.pitch_turfs?.count ?? 0
        }
        return countVar
    }
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if collectionView == durationCollection
        {

            let homeTypeCollectionViewCell1 = durationCollection.dequeueReusableCell(withReuseIdentifier: "FilterDurationCollectionViewCell", for: indexPath as IndexPath) as! FilterDurationCollectionViewCell

            homeTypeCollectionViewCell1.btnDuration.addTarget(self, action: #selector(DurationSelection(_:)), for: .touchUpInside)

            homeTypeCollectionViewCell1.btnDuration.tag = indexPath.row
            homeTypeCollectionViewCell1.btnDuration.backgroundColor = UIColor.clear
            homeTypeCollectionViewCell1.btnDuration.layer.borderColor = UIColor.lightGray.cgColor
            homeTypeCollectionViewCell1.btnDuration.layer.borderWidth = 0.5
            homeTypeCollectionViewCell1.btnDuration.setTitleColor(.white, for: .normal)

            homeTypeCollectionViewCell1.btnDuration.setTitle(self.durations![indexPath.row].duration! + " Min", for: .normal)

            
            if self.sharedData.getFilterDurationId() == nil ||  self.sharedData.getFilterDurationId().count == 0
            {
                
            }
            else
            {
            if self.durations![indexPath.row].id == Int(self.sharedData.getFilterDurationId())
            {
                homeTypeCollectionViewCell1.btnDuration.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
                homeTypeCollectionViewCell1.btnDuration.setTitleColor(.black, for: .normal)
                
            }
            }
            
            
//            if String(indexPath.row) == self.sSelectedDuration
//            {
//                homeTypeCollectionViewCell1.btnDuration.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
//                homeTypeCollectionViewCell1.btnDuration.setTitleColor(.black, for: .normal)
//                homeTypeCollectionViewCell1.btnDuration.layer.borderColor = UIColor.clear.cgColor
//
//            }
            
            cell = homeTypeCollectionViewCell1

           
            }
else  if collectionView == typeCollection
{


    let homeTypeCollectionViewCell1 = typeCollection.dequeueReusableCell(withReuseIdentifier: "FilterTypeCollectionViewCell", for: indexPath as IndexPath) as! FilterTypeCollectionViewCell

    homeTypeCollectionViewCell1.btnType.addTarget(self, action: #selector(Typeselection(_:)), for: .touchUpInside)

    homeTypeCollectionViewCell1.btnType.tag = indexPath.row

    homeTypeCollectionViewCell1.btnType.backgroundColor = UIColor.clear
    homeTypeCollectionViewCell1.btnType.layer.borderColor = UIColor.lightGray.cgColor
    homeTypeCollectionViewCell1.btnType.layer.borderWidth = 0.5
    homeTypeCollectionViewCell1.btnType.setTitleColor(.white, for: .normal)
    homeTypeCollectionViewCell1.btnType.setTitle(self.pitch_types![indexPath.row].type_name, for: .normal)
//    if String(indexPath.row) == self.sSelectedPitchType
//    {
//        homeTypeCollectionViewCell1.btnType.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
//        homeTypeCollectionViewCell1.btnType.setTitleColor(.black, for: .normal)
//        homeTypeCollectionViewCell1.btnType.layer.borderColor = UIColor.clear.cgColor
//
//    }
    cell = homeTypeCollectionViewCell1
    
    if self.sharedData.getFilterPitchTypeId() == nil ||  self.sharedData.getFilterPitchTypeId().count == 0
    {
        
    }
    else
    {
    if self.pitch_types![indexPath.row].id == Int(self.sharedData.getFilterPitchTypeId())
    {
        homeTypeCollectionViewCell1.btnType.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
        homeTypeCollectionViewCell1.btnType.setTitleColor(.black, for: .normal)
    }
        
       
        
    }
   
    
    

    }
else  if collectionView == sizeCollection
{
    

    
    let homeTypeCollectionViewCell2 = sizeCollection.dequeueReusableCell(withReuseIdentifier: "FilterSizeCollectionViewCell", for: indexPath as IndexPath) as! FilterSizeCollectionViewCell

    homeTypeCollectionViewCell2.btnSize.addTarget(self, action: #selector(SizeSelection(_:)), for: .touchUpInside)

    homeTypeCollectionViewCell2.btnSize.tag = indexPath.row
    homeTypeCollectionViewCell2.btnSize.backgroundColor = UIColor.clear
    homeTypeCollectionViewCell2.btnSize.layer.borderColor = UIColor.lightGray.cgColor
    homeTypeCollectionViewCell2.btnSize.layer.borderWidth = 0.5
    homeTypeCollectionViewCell2.btnSize.setTitleColor(.white, for: .normal)
    homeTypeCollectionViewCell2.btnSize.setTitle(self.pitch_sizes![indexPath.row].size_name, for: .normal)

//    if indexPath.row == 0
//    {
//        homeTypeCollectionViewCell2.btnSize.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
//        homeTypeCollectionViewCell2.btnSize.setTitleColor(.black, for: .normal)
//    }
//
    
//    if self.sSelectedButton3.count > 0
//    {
//        if indexPath.row == Int(self.sSelectedButton3)
//        {
//            homeTypeCollectionViewCell2.btnSize.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
//            homeTypeCollectionViewCell2.btnSize.setTitleColor(.black, for: .normal)
//            homeTypeCollectionViewCell2.btnSize.layer.borderColor = UIColor.clear.cgColor
//
//        }
//        else
//        {
//            homeTypeCollectionViewCell2.btnSize.backgroundColor = UIColor.clear
//            homeTypeCollectionViewCell2.btnSize.layer.borderColor = UIColor.lightGray.cgColor
//            homeTypeCollectionViewCell2.btnSize.layer.borderWidth = 0.5
//            homeTypeCollectionViewCell2.btnSize.setTitleColor(.white, for: .normal)
//        }
//    }
    
//    if String(indexPath.row) == self.sSelectedPitchSize
//    {
//        homeTypeCollectionViewCell2.btnSize.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
//        homeTypeCollectionViewCell2.btnSize.setTitleColor(.black, for: .normal)
//        homeTypeCollectionViewCell2.btnSize.layer.borderColor = UIColor.clear.cgColor
//
//    }
    if self.sharedData.getFilterPitchSizeId() == nil ||  self.sharedData.getFilterPitchSizeId().count == 0
    {
        
    }
    else
    {
    if self.pitch_sizes![indexPath.row].id == Int(self.sharedData.getFilterPitchSizeId())
    {
        homeTypeCollectionViewCell2.btnSize.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
        homeTypeCollectionViewCell2.btnSize.setTitleColor(.black, for: .normal)
    }
    }
    
   
    
    
    cell = homeTypeCollectionViewCell2

    }

else  if collectionView == TurfCollection
{
    

    
    let homeTypeCollectionViewCell2 = TurfCollection.dequeueReusableCell(withReuseIdentifier: "FilterTurfCollectionViewCell", for: indexPath as IndexPath) as! FilterTurfCollectionViewCell

    homeTypeCollectionViewCell2.btnTurf.addTarget(self, action: #selector(TurfSelection(_:)), for: .touchUpInside)

    homeTypeCollectionViewCell2.btnTurf.tag = indexPath.row
    homeTypeCollectionViewCell2.btnTurf.backgroundColor = UIColor.clear
    homeTypeCollectionViewCell2.btnTurf.layer.borderColor = UIColor.lightGray.cgColor
    homeTypeCollectionViewCell2.btnTurf.layer.borderWidth = 0.5
    homeTypeCollectionViewCell2.btnTurf.setTitleColor(.white, for: .normal)
    homeTypeCollectionViewCell2.btnTurf.setTitle(self.pitch_turfs![indexPath.row].turf_name, for: .normal)
//    if String(indexPath.row) == self.sSelectedPitchTurf
//    {
//        homeTypeCollectionViewCell2.btnTurf.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
//        homeTypeCollectionViewCell2.btnTurf.setTitleColor(.black, for: .normal)
//        homeTypeCollectionViewCell2.btnTurf.layer.borderColor = UIColor.clear.cgColor
//
//    }
    
    if self.sharedData.getFilterPitchTurfId() == nil ||  self.sharedData.getFilterPitchTurfId().count == 0
    {
        
    }
    else
    {
    if self.pitch_sizes![indexPath.row].id == Int(self.sharedData.getFilterPitchTurfId())
    {
        homeTypeCollectionViewCell2.btnTurf.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
        homeTypeCollectionViewCell2.btnTurf.setTitleColor(.black, for: .normal)
    }
    }
    
    
    
//
//    if indexPath.row == 0
//    {
//        homeTypeCollectionViewCell2.btnTurf.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
//        homeTypeCollectionViewCell2.btnTurf.setTitleColor(.black, for: .normal)
//        homeTypeCollectionViewCell2.btnTurf.layer.borderColor = UIColor.clear.cgColor
//
//    }
    
//    if self.sSelectedButton2.count > 0
//    {
//        if indexPath.row == Int(self.sSelectedButton2)
//        {
//            homeTypeCollectionViewCell2.btnTurf.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
//            homeTypeCollectionViewCell2.btnTurf.setTitleColor(.black, for: .normal)
//        }
//        else
//        {
//            homeTypeCollectionViewCell2.btnTurf.backgroundColor = UIColor.clear
//            homeTypeCollectionViewCell2.btnTurf.layer.borderColor = UIColor.lightGray.cgColor
//            homeTypeCollectionViewCell2.btnTurf.layer.borderWidth = 0.5
//            homeTypeCollectionViewCell2.btnTurf.setTitleColor(.white, for: .normal)
//        }
//    }
    cell = homeTypeCollectionViewCell2

    }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
//        if collectionView == typeCollection
//        {
//            if indexPath.row == 0
//            {
//                return CGSize(width:85 , height:40)
//
//            }
//            else
//            {
//                return CGSize(width:120 , height:40)
//
//            }
//        }
//        else if collectionView == durationCollection
//        {
//            return CGSize(width:85 , height:40)
//
//        }
//        else if collectionView == TurfCollection
//        {
//            return CGSize(width:85 , height:40)
//
//        }
//         else if collectionView == sizeCollection
//        {
//            if indexPath.row == 0
//            {
//                return CGSize(width:85 , height:40)
//
//            }
//            else
//            {
//                return CGSize(width:85 , height:40)
//
//            }
//        }
//        else
//        {
//            return CGSize(width:85 , height:40)
//
//        }
       
        
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
       
         
        if UIDevice.current.screenType.rawValue == "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8" || UIDevice.current.screenType.rawValue == "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus" || UIDevice.current.screenType.rawValue == "iPhone XS Max or iPhone Pro Max"||UIDevice.current.screenType.rawValue == "iPhone X or iPhone XS" || UIDevice.current.screenType.rawValue ==  "iPhone XR or iPhone 11"
        
            {
                print("iPhone 6, iPhone 6S, iPhone 7 or iPhone 8","iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus")
                for indexs in 0..<self.durations!.count
                {

                 print(indexs)
                    
                    if indexs == sender.tag
                    {
                        let index = IndexPath(row: sender.tag, section: 0)
                        let cell: FilterDurationCollectionViewCell = self.durationCollection.cellForItem(at: index) as! FilterDurationCollectionViewCell
                        //Time
                        let timeFormatter = DateFormatter()
                        timeFormatter.timeStyle = .medium
        //                timeFormatter.dateFormat = "HH:mm"
                        timeFormatter.dateFormat = "h a"

                        self.iDurationId = self.durations![sender.tag].id
                        self.sSelectedDuration = String(sender.tag)

                        let timeString = "Current time is: \(timeFormatter.string(from: Date() as Date))"
                        print(String(timeString))
                        if cell.btnDuration.titleLabel?.text == "60 Min"
                        {
//                            lblStartTime.text = timeFormatter.string(from: Date() as Date)
//
//                            let calendar = Calendar.current
//
//                            let date = calendar.date(byAdding: .minute, value: 60, to: Date())
//                            var selectedTime = timeFormatter.string(from: date!)
//
//
//                            lblEndTime.text = selectedTime
//
//                            var parsed = lblStartTime.text!.replacingOccurrences(of: " AM", with: "")
//                             parsed = lblStartTime.text!.replacingOccurrences(of: " PM", with: "")
//
//
//                            var parsed1 = lblEndTime.text!.replacingOccurrences(of: " AM", with: "")
//                             parsed1 = lblEndTime.text!.replacingOccurrences(of: " PM", with: "")
//
//
                           
                        
                            
                        }
                        else if cell.btnDuration.titleLabel?.text == "90 Min"
                        {
//                            lblStartTime.text = timeFormatter.string(from: Date() as Date)
//                            let calendar = Calendar.current
//
//                            let date = calendar.date(byAdding: .minute, value: 90, to: Date())
//                            var selectedTime = timeFormatter.string(from: date!)
//
//
//                            lblEndTime.text = selectedTime
//                            var parsed = lblStartTime.text!.replacingOccurrences(of: " AM", with: "")
//                             parsed = lblStartTime.text!.replacingOccurrences(of: " PM", with: "")
//
//
//                            var parsed1 = lblEndTime.text!.replacingOccurrences(of: " AM", with: "")
//                             parsed1 = lblEndTime.text!.replacingOccurrences(of: " PM", with: "")
//
//
                            
                           
                        }
                        else if cell.btnDuration.titleLabel?.text == "120 Min"
                        {
//                            lblStartTime.text = timeFormatter.string(from: Date() as Date)
//                            let calendar = Calendar.current
//
//                            let date = calendar.date(byAdding: .minute, value: 120, to: Date())
//                            var selectedTime = timeFormatter.string(from: date!)
//
//
//                            lblEndTime.text = selectedTime
//
//                            var parsed = lblStartTime.text!.replacingOccurrences(of: " AM", with: "")
//                             parsed = lblStartTime.text!.replacingOccurrences(of: " PM", with: "")
//
//
//                            var parsed1 = lblEndTime.text!.replacingOccurrences(of: " AM", with: "")
//                             parsed1 = lblEndTime.text!.replacingOccurrences(of: " PM", with: "")
                            
                            
                            
                           
                        }
                        else
                        {
                            lblStartTime.text = "9 AM"


                            
                            lblEndTime.text = "12 PM"
                        }
                        cell.btnDuration.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
                        cell.btnDuration.setTitleColor(.black, for: .normal)
                    }
                    
                    else  if indexs < 4 && sender.tag <= 3

                     {
                         let index = IndexPath(row: indexs, section: 0)
                         let cell: FilterDurationCollectionViewCell = self.durationCollection.cellForItem(at: index) as! FilterDurationCollectionViewCell
                         cell.btnDuration.backgroundColor = UIColor.clear
                         cell.btnDuration.setTitleColor(.white, for: .normal)
                     }

                 
                 }
                
            }
            else if UIDevice.current.screenType.rawValue  == "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE" {
                print("iPhone 5, iPhone 5s, iPhone 5c or iPhone SE")
                for indexs in 0..<self.durations!.count
                {

                 print(indexs)
                    
                    if indexs == sender.tag
                    {
                        let index = IndexPath(row: sender.tag, section: 0)
                        let cell: FilterDurationCollectionViewCell = self.durationCollection.cellForItem(at: index) as! FilterDurationCollectionViewCell
                        //Time
                        let timeFormatter = DateFormatter()
                        timeFormatter.timeStyle = .medium
        //                timeFormatter.dateFormat = "HH:mm"
                        timeFormatter.dateFormat = "h a"

                        self.iDurationId = self.durations![sender.tag].id
                        
                        let timeString = "Current time is: \(timeFormatter.string(from: Date() as Date))"
                        print(String(timeString))
                        if cell.btnDuration.titleLabel?.text == "60 Min"
                        {
//                            lblStartTime.text = timeFormatter.string(from: Date() as Date)
                          
                            let calendar = Calendar.current

                            let date = calendar.date(byAdding: .minute, value: 60, to: Date())
                            var selectedTime = timeFormatter.string(from: date!)

                            
//                            lblEndTime.text = selectedTime
//
//                            var parsed = lblStartTime.text!.replacingOccurrences(of: " AM", with: "")
//                             parsed = lblStartTime.text!.replacingOccurrences(of: " PM", with: "")
//
//
//                            var parsed1 = lblEndTime.text!.replacingOccurrences(of: " AM", with: "")
//                             parsed1 = lblEndTime.text!.replacingOccurrences(of: " PM", with: "")
//
//                            self.timeSlider.minimumValue = Float(parsed)!
//                            self.timeSlider.maximumValue = Float(parsed1)!
//                            self.timeSlider.value =  Float(parsed)!
                            
                          
                            
                            
                            
                            
                            
                        }
                        else if cell.btnDuration.titleLabel?.text == "90 Min"
                        {
//                            lblStartTime.text = timeFormatter.string(from: Date() as Date)
                            let calendar = Calendar.current

                            let date = calendar.date(byAdding: .minute, value: 90, to: Date())
                            var selectedTime = timeFormatter.string(from: date!)

                            
//                            lblEndTime.text = selectedTime
//                            var parsed = lblStartTime.text!.replacingOccurrences(of: " AM", with: "")
//                             parsed = lblStartTime.text!.replacingOccurrences(of: " PM", with: "")
//
//
//                            var parsed1 = lblEndTime.text!.replacingOccurrences(of: " AM", with: "")
//                             parsed1 = lblEndTime.text!.replacingOccurrences(of: " PM", with: "")
//
//                            self.timeSlider.minimumValue = Float(parsed)!
//                            self.timeSlider.maximumValue = Float(parsed1)!
//                            self.timeSlider.value =  Float(parsed)!
                            
                            
                            
                           
                        
                            
                        }
                        else if cell.btnDuration.titleLabel?.text == "120 Min"
                        {
//                            lblStartTime.text = timeFormatter.string(from: Date() as Date)
                            let calendar = Calendar.current

                            let date = calendar.date(byAdding: .minute, value: 120, to: Date())
                            var selectedTime = timeFormatter.string(from: date!)

                            
//                            lblEndTime.text = selectedTime
                            
//                            var parsed = lblStartTime.text!.replacingOccurrences(of: " AM", with: "")
//                             parsed = lblStartTime.text!.replacingOccurrences(of: " PM", with: "")
//
//
//                            var parsed1 = lblEndTime.text!.replacingOccurrences(of: " AM", with: "")
//                             parsed1 = lblEndTime.text!.replacingOccurrences(of: " PM", with: "")
//
//                            self.timeSlider.minimumValue = Float(parsed)!
//                            self.timeSlider.maximumValue = Float(parsed1)!
//                            self.timeSlider.value =  Float(parsed)!
                            
                            
                        
                            
                            
                        }
                        else
                        {
//                            lblStartTime.text = "9 AM"
//
//
//
//                            lblEndTime.text = "12 PM"
                        }
                        cell.btnDuration.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
                        cell.btnDuration.setTitleColor(.black, for: .normal)
                    }
                    
                    else  if indexs < 3 && sender.tag <= 2

                     {
                         let index = IndexPath(row: indexs, section: 0)
                         let cell: FilterDurationCollectionViewCell = self.durationCollection.cellForItem(at: index) as! FilterDurationCollectionViewCell
                         cell.btnDuration.backgroundColor = UIColor.clear
                         cell.btnDuration.setTitleColor(.white, for: .normal)
                     }

                 
                 }
                
            }
            else {
                for indexs in 0..<self.durations!.count
                {

                 print(indexs)
                    
                    if indexs == sender.tag
                    {
                        let index = IndexPath(row: sender.tag, section: 0)
                        let cell: FilterDurationCollectionViewCell = self.durationCollection.cellForItem(at: index) as! FilterDurationCollectionViewCell
                        //Time
                        let timeFormatter = DateFormatter()
                        timeFormatter.timeStyle = .medium
        //                timeFormatter.dateFormat = "HH:mm"
                        timeFormatter.dateFormat = "h a"

                        self.iDurationId = self.durations![sender.tag].id
                        
                        let timeString = "Current time is: \(timeFormatter.string(from: Date() as Date))"
                        print(String(timeString))
                        if cell.btnDuration.titleLabel?.text == "60 Min"
                        {
//                            lblStartTime.text = timeFormatter.string(from: Date() as Date)
//
//                            let calendar = Calendar.current
//
//                            let date = calendar.date(byAdding: .minute, value: 60, to: Date())
//                            var selectedTime = timeFormatter.string(from: date!)
//
//
//                            lblEndTime.text = selectedTime
//
//                            var parsed = lblStartTime.text!.replacingOccurrences(of: " AM", with: "")
//                             parsed = lblStartTime.text!.replacingOccurrences(of: " PM", with: "")
//
//
//                            var parsed1 = lblEndTime.text!.replacingOccurrences(of: " AM", with: "")
//                             parsed1 = lblEndTime.text!.replacingOccurrences(of: " PM", with: "")
//
                         
                        
                            
                        }
                        else if cell.btnDuration.titleLabel?.text == "90 Min"
                        {
//                            lblStartTime.text = timeFormatter.string(from: Date() as Date)
//                            let calendar = Calendar.current
//
//                            let date = calendar.date(byAdding: .minute, value: 90, to: Date())
//                            var selectedTime = timeFormatter.string(from: date!)
//
//
//                            lblEndTime.text = selectedTime
//                            var parsed = lblStartTime.text!.replacingOccurrences(of: " AM", with: "")
//                             parsed = lblStartTime.text!.replacingOccurrences(of: " PM", with: "")
//
//
//                            var parsed1 = lblEndTime.text!.replacingOccurrences(of: " AM", with: "")
//                             parsed1 = lblEndTime.text!.replacingOccurrences(of: " PM", with: "")
                            
                           
                        }
                        else if cell.btnDuration.titleLabel?.text == "120 Min"
                        {
//                            lblStartTime.text = timeFormatter.string(from: Date() as Date)
//                            let calendar = Calendar.current
//
//                            let date = calendar.date(byAdding: .minute, value: 120, to: Date())
//                            var selectedTime = timeFormatter.string(from: date!)
//
//
//                            lblEndTime.text = selectedTime
//
//                            var parsed = lblStartTime.text!.replacingOccurrences(of: " AM", with: "")
//                             parsed = lblStartTime.text!.replacingOccurrences(of: " PM", with: "")
//
//
//                            var parsed1 = lblEndTime.text!.replacingOccurrences(of: " AM", with: "")
//                             parsed1 = lblEndTime.text!.replacingOccurrences(of: " PM", with: "")
                            
                            
                        }
                        else
                        {
                            lblStartTime.text = "9 AM"


                            
                            lblEndTime.text = "12 PM"
                        }
                        cell.btnDuration.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
                        cell.btnDuration.setTitleColor(.black, for: .normal)
                    }
                    
                    else  if indexs < 4 && sender.tag <= 3

                     {
                         let index = IndexPath(row: indexs, section: 0)
                         let cell: FilterDurationCollectionViewCell = self.durationCollection.cellForItem(at: index) as! FilterDurationCollectionViewCell
                         cell.btnDuration.backgroundColor = UIColor.clear
                         cell.btnDuration.setTitleColor(.white, for: .normal)
                     }

                 
                 }
                
            }
           
            
            
           
        
        
    }
    @objc func Typeselection(_ sender: UIButton)
    {
       

        
        if UIDevice.current.screenType.rawValue == "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8" || UIDevice.current.screenType.rawValue == "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus" || UIDevice.current.screenType.rawValue == "iPhone XS Max or iPhone Pro Max"||UIDevice.current.screenType.rawValue == "iPhone X or iPhone XS" || UIDevice.current.screenType.rawValue ==  "iPhone XR or iPhone 11"
        {
            print("iPhone 6, iPhone 6S, iPhone 7 or iPhone 8","iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus")
        print(sender.tag)
        for indexs in 0..<self.pitch_types!.count
        {

         print(indexs)
            
            if indexs == sender.tag
            {
                let index = IndexPath(row: sender.tag, section: 0)
                let cell: FilterTypeCollectionViewCell = self.typeCollection.cellForItem(at: index) as! FilterTypeCollectionViewCell
                self.sSelectedTypeName = (cell.btnType.titleLabel?.text)!
                self.sSelectedPitchType = String(sender.tag)
                cell.btnType.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
                cell.btnType.setTitleColor(.black, for: .normal)
                self.iPitchType_Id = self.pitch_types![sender.tag].id

            }
            else  if indexs < 4 && sender.tag <= 3
             
            {
                let index = IndexPath(row: indexs, section: 0)
                let cell: FilterTypeCollectionViewCell = self.typeCollection.cellForItem(at: index) as! FilterTypeCollectionViewCell
                cell.btnType.backgroundColor = UIColor.clear
                cell.btnType.setTitleColor(.white, for: .normal)
            }

        
        }
        
        }
        else if UIDevice.current.screenType.rawValue == "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE" {
           print("iPhone 5, iPhone 5s, iPhone 5c or iPhone SE" )
            print(sender.tag)
            for indexs in 0..<self.pitch_types!.count
            {

             print(indexs)
                
                if indexs == sender.tag
                {
                    let index = IndexPath(row: sender.tag, section: 0)
                    let cell: FilterTypeCollectionViewCell = self.typeCollection.cellForItem(at: index) as! FilterTypeCollectionViewCell
                    cell.btnType.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
                    cell.btnType.setTitleColor(.black, for: .normal)
                    self.sSelectedTypeName = (cell.btnType.titleLabel?.text)!
                    self.sSelectedPitchType = String(sender.tag)

                    self.iPitchType_Id = self.pitch_types![sender.tag].id

                }
                else  if indexs < 3 && sender.tag <= 2
                 
                {
                    let index = IndexPath(row: indexs, section: 0)
                    let cell: FilterTypeCollectionViewCell = self.typeCollection.cellForItem(at: index) as! FilterTypeCollectionViewCell
                    cell.btnType.backgroundColor = UIColor.clear
                    cell.btnType.setTitleColor(.white, for: .normal)
                }

            
            }
            
        }
        
        
        else
        {
            print("iPhone 6, iPhone 6S, iPhone 7 or iPhone 8","iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus")
        print(sender.tag)
        for indexs in 0..<self.pitch_types!.count
        {

         print(indexs)
            
            if indexs == sender.tag
            {
                let index = IndexPath(row: sender.tag, section: 0)
                let cell: FilterTypeCollectionViewCell = self.typeCollection.cellForItem(at: index) as! FilterTypeCollectionViewCell
                self.sSelectedTypeName = (cell.btnType.titleLabel?.text)!
                self.sSelectedPitchType = String(sender.tag)

                cell.btnType.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
                cell.btnType.setTitleColor(.black, for: .normal)
                self.iPitchType_Id = self.pitch_types![sender.tag].id

            }
            else  if indexs < 4 && sender.tag <= 3
             
            {
                let index = IndexPath(row: indexs, section: 0)
                let cell: FilterTypeCollectionViewCell = self.typeCollection.cellForItem(at: index) as! FilterTypeCollectionViewCell
                cell.btnType.backgroundColor = UIColor.clear
                cell.btnType.setTitleColor(.white, for: .normal)
            }

        
        }
        
        }

    }
    
    
    
    
    
    
    @objc func TurfSelection(_ sender: UIButton)
    {
        
        if UIDevice.current.screenType.rawValue == "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8" || UIDevice.current.screenType.rawValue == "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus" || UIDevice.current.screenType.rawValue == "iPhone XS Max or iPhone Pro Max"||UIDevice.current.screenType.rawValue == "iPhone X or iPhone XS" || UIDevice.current.screenType.rawValue ==  "iPhone XR or iPhone 11"
        {
       
         print(sender.tag)
        for indexs in 0..<self.pitch_turfs!.count
         {

          print(indexs)
             
             if indexs == sender.tag
             {
                 let index = IndexPath(row: sender.tag, section: 0)
                 let cell: FilterTurfCollectionViewCell = self.TurfCollection.cellForItem(at: index) as! FilterTurfCollectionViewCell
                 cell.btnTurf.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
                 cell.btnTurf.setTitleColor(.black, for: .normal)
                self.sSelectedPitchTurf = String(sender.tag)

                self.iPitchTurf_Id = self.pitch_turfs![sender.tag].id
                


             }
//             else  if indexs < 4 && sender.tag <= 3
            
             else

             {
                 let index = IndexPath(row: indexs, section: 0)
                 let cell: FilterTurfCollectionViewCell = self.TurfCollection.cellForItem(at: index) as! FilterTurfCollectionViewCell
                 cell.btnTurf.backgroundColor = UIColor.clear
                 cell.btnTurf.setTitleColor(.white, for: .normal)
             }

         
         }
        }
        else if UIDevice.current.screenType.rawValue == "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE" {
           print("iPhone 5, iPhone 5s, iPhone 5c or iPhone SE" )
            
           
          
            print(sender.tag)
           for indexs in 0..<self.pitch_turfs!.count
            {

             print(indexs)
                
                if indexs == sender.tag
                {
                    let index = IndexPath(row: sender.tag, section: 0)
                    let cell: FilterTurfCollectionViewCell = self.TurfCollection.cellForItem(at: index) as! FilterTurfCollectionViewCell
                    cell.btnTurf.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
                    cell.btnTurf.setTitleColor(.black, for: .normal)
                   self.iPitchTurf_Id = self.pitch_turfs![sender.tag].id
                   
                    self.sSelectedPitchTurf = String(sender.tag)


                }
//                else  if indexs < 3 && sender.tag <= 2
            else

                {
                    let index = IndexPath(row: indexs, section: 0)
                    let cell: FilterTurfCollectionViewCell = self.TurfCollection.cellForItem(at: index) as! FilterTurfCollectionViewCell
                    cell.btnTurf.backgroundColor = UIColor.clear
                    cell.btnTurf.setTitleColor(.white, for: .normal)
                }

            
            }
           }
        else
        {
       
         print(sender.tag)
        for indexs in 0..<self.pitch_turfs!.count
         {

          print(indexs)
             
             if indexs == sender.tag
             {
                 let index = IndexPath(row: sender.tag, section: 0)
                 let cell: FilterTurfCollectionViewCell = self.TurfCollection.cellForItem(at: index) as! FilterTurfCollectionViewCell
                 cell.btnTurf.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
                 cell.btnTurf.setTitleColor(.black, for: .normal)
                self.iPitchTurf_Id = self.pitch_turfs![sender.tag].id
                
                self.sSelectedPitchTurf = String(sender.tag)


             }
             else  if indexs < 4 && sender.tag <= 3
             {
                 let index = IndexPath(row: indexs, section: 0)
                 let cell: FilterTurfCollectionViewCell = self.TurfCollection.cellForItem(at: index) as! FilterTurfCollectionViewCell
                 cell.btnTurf.backgroundColor = UIColor.clear
                 cell.btnTurf.setTitleColor(.white, for: .normal)
             }

         
         }
        }
            
        
        
    }
    
    @objc func SizeSelection(_ sender: UIButton)
    {
       
        if UIDevice.current.screenType.rawValue == "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8" || UIDevice.current.screenType.rawValue == "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus" || UIDevice.current.screenType.rawValue == "iPhone XS Max or iPhone Pro Max"||UIDevice.current.screenType.rawValue == "iPhone X or iPhone XS" || UIDevice.current.screenType.rawValue ==  "iPhone XR or iPhone 11"
        {
       
        print(sender.tag)
        for indexs in 0..<self.pitch_sizes!.count
        {

         print(indexs)
            
            if indexs == sender.tag
            {
                let index = IndexPath(row: sender.tag, section: 0)
                let cell: FilterSizeCollectionViewCell = self.sizeCollection.cellForItem(at: index) as! FilterSizeCollectionViewCell
                cell.btnSize.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
                cell.btnSize.setTitleColor(.black, for: .normal)
                self.iPitchSize_id = self.pitch_sizes![sender.tag].id
                
                self.sSelectedPitchSize = String(sender.tag)
//                self.sharedData.setFilterPitchSizeId(token: String(self.iPitchSize_id!))

            }
//            else  if indexs < 4 && sender.tag <= 3
            else

            {
                let index = IndexPath(row: indexs, section: 0)
                let cell: FilterSizeCollectionViewCell = self.sizeCollection.cellForItem(at: index) as! FilterSizeCollectionViewCell
                cell.btnSize.backgroundColor = UIColor.clear
                cell.btnSize.setTitleColor(.white, for: .normal)
            }

        
        }
        }
        else if UIDevice.current.screenType.rawValue == "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE" {
           print("iPhone 5, iPhone 5s, iPhone 5c or iPhone SE" )
            
       
        print(sender.tag)
        for indexs in 0..<self.pitch_sizes!.count
        {

         print(indexs)
            
            if indexs == sender.tag
            {
                let index = IndexPath(row: sender.tag, section: 0)
                let cell: FilterSizeCollectionViewCell = self.sizeCollection.cellForItem(at: index) as! FilterSizeCollectionViewCell
                cell.btnSize.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
                cell.btnSize.setTitleColor(.black, for: .normal)
                self.iPitchSize_id = self.pitch_sizes![sender.tag].id
                self.sSelectedPitchSize = String(sender.tag)

//                self.sharedData.setFilterPitchSizeId(token: String(self.iPitchSize_id!))

            }
            else  if indexs < 3 && sender.tag <= 2
            {
                let index = IndexPath(row: indexs, section: 0)
                let cell: FilterSizeCollectionViewCell = self.sizeCollection.cellForItem(at: index) as! FilterSizeCollectionViewCell
                cell.btnSize.backgroundColor = UIColor.clear
                cell.btnSize.setTitleColor(.white, for: .normal)
            }

        
        }
        }
        else
        {
       
        print(sender.tag)
        for indexs in 0..<self.pitch_sizes!.count
        {

         print(indexs)
            
            if indexs == sender.tag
            {
                let index = IndexPath(row: sender.tag, section: 0)
                let cell: FilterSizeCollectionViewCell = self.sizeCollection.cellForItem(at: index) as! FilterSizeCollectionViewCell
                cell.btnSize.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
                cell.btnSize.setTitleColor(.black, for: .normal)
                self.iPitchSize_id = self.pitch_sizes![sender.tag].id
//                self.sharedData.setFilterPitchSizeId(token: String(self.iPitchSize_id!))
                self.sSelectedPitchSize = String(sender.tag)

            }
//            else  if indexs < 4 && sender.tag <= 3
            else

            {
                let index = IndexPath(row: indexs, section: 0)
                let cell: FilterSizeCollectionViewCell = self.sizeCollection.cellForItem(at: index) as! FilterSizeCollectionViewCell
                cell.btnSize.backgroundColor = UIColor.clear
                cell.btnSize.setTitleColor(.white, for: .normal)
            }

        
        }
        }
    }
    
    @IBAction func ActionTimePogress(_ sender: UIButton)
    {
        if sender.tag == 0
        {
            if !bCheckingTimeProgress1
            {
                btnTime1.setImage(UIImage(named: "radio_On_Green"), for: .normal)
                bCheckingTimeProgress1 = true
            }
            else
            {
                btnTime1.setImage(UIImage(named: "radio_Off_green"), for: .normal)
                bCheckingTimeProgress1 = false
            }
        }
//        else if sender.tag == 1
//        {
//            if !bCheckingTimeProgress2
//            {
//                btnTime1.setImage(UIImage(named: "radio_On_Green"), for: .normal)
//                btnTime2.setImage(UIImage(named: "radio_On_Green"), for: .normal)
//                bCheckingTimeProgress2 = true
//                bCheckingTimeProgress1 = true
//
//            }
//            else
//            {
//                btnTime2.setImage(UIImage(named: "radio_Off_green"), for: .normal)
//                bCheckingTimeProgress2 = false
//            }
//        }
//        else if sender.tag == 2
//        {
//            if !bCheckingTimeProgress3
//            {
//                btnTime1.setImage(UIImage(named: "radio_On_Green"), for: .normal)
//                btnTime2.setImage(UIImage(named: "radio_On_Green"), for: .normal)
//                btnTime3.setImage(UIImage(named: "radio_On_Green"), for: .normal)
//                bCheckingTimeProgress3 = true
//                bCheckingTimeProgress2 = true
//                bCheckingTimeProgress1 = true
//
//            }
//            else
//            {
//                btnTime3.setImage(UIImage(named: "radio_Off_green"), for: .normal)
//                bCheckingTimeProgress3 = false
//            }
//        }
        else if sender.tag == 3
        {
            if !bCheckingTimeProgress4
            {
                btnTime1.setImage(UIImage(named: "radio_On_Green"), for: .normal)
                btntime4.setImage(UIImage(named: "radio_On_Green"), for: .normal)
                bCheckingTimeProgress4 = true
                bCheckingTimeProgress1 = true
            }
            else
            {
                btntime4.setImage(UIImage(named: "radio_Off_green"), for: .normal)
                bCheckingTimeProgress4 = false
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
                    
//                    self.durations = [Durations]()
//                    self.pitch_turfs = [Pitch_turfs]
//
//
//
//
////                    self.durationData?.id = 0
////                    self.durationData?.duration = "Any"
////                    self.durations?.append(self.durationData!)
//
//                    self.pitch_sizesData?.id = 0
//                    self.pitch_sizesData?.size_name = "Any"
//                    self.pitch_sizes?.append(self.pitch_sizesData!)
//
//                    self.pitch_turfData?.id = 0
//                    self.pitch_turfData?.turf_name = "Any"
//                    self.pitch_turfs?.append(self.pitch_turfData!)
//
//                    self.pitch_typesData?.id = 0
//                    self.pitch_typesData?.type_name = "Any"
//                    self.pitch_types?.append(self.pitch_typesData!)

                    self.durations = self.filter_masters?.durations
                    self.pitch_sizes = self.filter_masters?.pitch_sizes
                    self.pitch_turfs = self.filter_masters?.pitch_turfs
                    self.pitch_types = self.filter_masters?.pitch_types
                    
                    
                    
                    self.user_details = self.filterResponseModel?.filterData?.user_details
                    self.pitch_list = (self.filterResponseModel?.filterData?.pitch_list)!

                    let statusCode = Int((self.filterResponseModel?.httpcode)!)
                    if statusCode == 200{
                        print("registerResponseModel ----- ",self.filterResponseModel)
                        if self.pitch_list.count > 0
                        {
//
                        }
//                        for item in self.durationsInfo!
//                        {
//                            self.durations?.append(item)
//                        }
//                        for item in self.pitch_typesInfo!
//                        {
//                            self.pitch_types?.append(item)
//                        }
//                        for item in self.pitch_turfsInfo!
//                        {
//                            self.pitch_turfs?.append(item)
//                        }
//                        for item in self.pitch_sizesInfo!
//                        {
//                            self.pitch_sizes?.append(item)
//                        }
                        self.sMaxPriceOfFilter = self.filter_masters?.max_price
                        self.sMinPriceOfFilter = self.filter_masters?.min_price
                        
//                        self.durationCollectionViewHeight.constant = 100
//                        self.typeCollectionViewHeight.constant = 100
//                        self.turfCollectionViewHeight.constant = 100
//                        self.sizeCollectionViewHeight.constant = 100
                        var height:Int?
                        var nHieght:Int?

                        if self.durations!.count > 0
                        {
                            
                            
                            
                            let q = self.durations?.count.quotientAndRemainder(dividingBy: 3)

                            print(q ?? 0)
                            
                            let iSize  = Double(self.durations?.count ?? 0) / 3.0
                            
                            if iSize.rounded(.up) == iSize.rounded(.down)
                            {
                                height = Int(q?.quotient ?? 0) * 50
                            }
                            else
                            {
                                nHieght = Int(q?.quotient ?? 0) + 1
                                height = Int(nHieght ?? 0) * 50
                            }
                            self.durationCollectionViewHeight.constant = CGFloat(height ?? 50)
                            self.durationCollection.reloadData()
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
                            self.sizeCollectionViewHeight.constant = CGFloat(height ?? 50)

                            self.sizeCollection.reloadData()
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
                            
                            self.turfCollectionViewHeight.constant =  CGFloat(height ?? 50)

                            self.TurfCollection.reloadData()
                        }
                        if self.pitch_types!.count > 0
                        {
                            let q = self.pitch_types?.count.quotientAndRemainder(dividingBy: 3)

                            print(q ?? 0)
                            
                            let iSize  = Double(self.pitch_types?.count ?? 0) / 3.0
                            
                            if iSize.rounded(.up) == iSize.rounded(.down)
                            {
                                height = Int(q?.quotient ?? 0) * 50
                            }
                            else
                            {
                                nHieght = Int(q?.quotient ?? 0) + 1
                                height = Int(nHieght ?? 0) * 50
                            }
                            self.typeCollectionViewHeight.constant = CGFloat(height ?? 50)

                            self.typeCollection.reloadData()
                        }
                       
                        if self.sharedData.getFilterStartPrize() == nil || self.sharedData.getFilterStartPrize().count == 0
                        {
                            self.lblStartPrize.text = String(self.sMinPriceOfFilter!)
                            self.timerRangeSeeker.minValue = CGFloat(self.sMinPriceOfFilter!)
                            self.timerRangeSeeker.selectedMinValue = CGFloat(self.sMinPriceOfFilter!)


                        }
                        else
                        {

                            self.timerRangeSeeker.minValue = CGFloat(self.sMinPriceOfFilter!)

                            guard let n = NumberFormatter().number(from: self.sharedData.getFilterStartPrize()) else { return }

                            self.timerRangeSeeker.selectedMinValue = CGFloat(truncating: n)

                            self.lblStartPrize.text = self.sharedData.getFilterStartPrize()
                            
                        }
                        

                        
                        if self.sharedData.getFilterSelectedEndPrize() == nil || self.sharedData.getFilterSelectedEndPrize().count == 0
                        {
                            self.lblEndPrice.text = String(self.sMaxPriceOfFilter!)
                            self.timerRangeSeeker.maxValue = CGFloat(self.sMaxPriceOfFilter!)
                            self.timerRangeSeeker.selectedMaxValue = CGFloat(self.sMaxPriceOfFilter!)

                        }
                        else
                        {

                         self.lblEndPrice.text = self.sharedData.getFilterSelectedEndPrize()
                            guard let n = NumberFormatter().number(from: self.sharedData.getFilterSelectedEndPrize()) else { return }
                            
                            self.timerRangeSeeker.maxValue = CGFloat(self.sMaxPriceOfFilter!)

                            self.timerRangeSeeker.selectedMaxValue = CGFloat(truncating: n)

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
    
    
    @IBAction func ActionPriceProgress(_ sender: UIButton)
    {
        if sender.tag == 0
        {
            if !bCheckingPriceProgress1
            {
                btnPrice1.setImage(UIImage(named: "radio_On_Green"), for: .normal)
                bCheckingPriceProgress1 = true
            }
            else
            {
                btnPrice1.setImage(UIImage(named: "radio_Off_green"), for: .normal)
                bCheckingPriceProgress1 = false
            }
        }
        else if sender.tag == 1
        {
            if !bCheckingPriceProgress2
            {
                btnPrice1.setImage(UIImage(named: "radio_On_Green"), for: .normal)
                bCheckingPriceProgress2 = true
            }
            else
            {
                
                bCheckingPriceProgress2 = false
            }
        }
//        else if sender.tag == 2
//        {
//            if !bCheckingPriceProgress3
//            {
//                btnPrice1.setImage(UIImage(named: "radio_On_Green"), for: .normal)
//                btnPrice2.setImage(UIImage(named: "radio_On_Green"), for: .normal)
//                btnPrice3.setImage(UIImage(named: "radio_On_Green"), for: .normal)
//                bCheckingPriceProgress3 = true
//            }
//            else
//            {
//                btnPrice3.setImage(UIImage(named: "radio_Off_green"), for: .normal)
//                bCheckingPriceProgress3 = false
//            }
//        }
        else if sender.tag == 3
        {
            if !bCheckingPriceProgress4
            {
                btnPrice1.setImage(UIImage(named: "radio_On_Green"), for: .normal)
                btnPrice4.setImage(UIImage(named: "radio_On_Green"), for: .normal)
                bCheckingPriceProgress4 = true
            }
            else
            {
                btnPrice4.setImage(UIImage(named: "radio_Off_green"), for: .normal)
                bCheckingPriceProgress4 = false
            }
        }
    }
    
    
    
}
extension FilterScreenViewController: RangeSeekSliderDelegate {

    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider === pricerangeSlider {
            print("timerRangeSeeker slider updated. Min Value: \(minValue) Max Value: \(maxValue)")

            
            let  minutes_Min = Int(minValue) / 60;

            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            
            let sCurrentTime = self.getTodayString()
            
            var parsed = sCurrentTime.replacingOccurrences(of: " AM", with: "")
            parsed = sCurrentTime.replacingOccurrences(of: " PM", with: "")
            
            
        let dateStart = formatter.date(from:  sCurrentTime)
            let tenMinutesLater = Calendar.current.date(byAdding: .second, value: minutes_Min, to: dateStart!)!
        print(formatter.string(from: tenMinutesLater))
        self.lblStartTimerValue.text = formatter.string(from: tenMinutesLater)
            
            self.sSelectedStartTime = String(Int(minutes_Min))
            
            
           


            
            if maxValue <= 86400.0 {
                
           
            
            let  minutes_Max = Int(maxValue) / 60;
            
            
            var sdatee = self.formatTimeInSec(totalSeconds: Int(maxValue))
            
            sdatee = self.timeConversion12(time24: sdatee)
            self.lblEndTimerValue.text = sdatee
                self.sSelectetdEndTime = String(Int(maxValue))
            }
            

        }
        else if slider === timerRangeSeeker {
            print("Currency slider updated. Min Value: \(minValue) Max Value: \(maxValue)")

            let stringFloat =  String(describing: Int(minValue))

            let stringFloat12 =  String(describing: Int(maxValue))
            
            self.lblStartPrize.text = stringFloat

            self.lblEndPrice.text = stringFloat12

            print("Start Price:",self.lblStartPrize.text as Any)
            
            print("End Price:",self.lblEndPrice.text as Any)

          

        }
//        else if slider === rangeSliderCustom {
//            print("Custom slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
//        }
    }

    func didStartTouches(in slider: RangeSeekSlider) {
        print("did start touches")
    }

    func didEndTouches(in slider: RangeSeekSlider) {
        print("did end touches")
    }
    func formatTimeInSec(totalSeconds: Int) -> String {
        let seconds = totalSeconds % 60
        let minutes = (totalSeconds / 60) % 60
        let hours = totalSeconds / 3600
        let strHours = hours > 9 ? String(hours) : "0" + String(hours)
        let strMinutes = minutes > 9 ? String(minutes) : "0" + String(minutes)
        let strSeconds = seconds > 9 ? String(seconds) : "0" + String(seconds)

        if hours > 0 {
            return "\(strHours):\(strMinutes)"
        }
        else {
            return "\(strMinutes):\(strSeconds)"
        }
    }

}
