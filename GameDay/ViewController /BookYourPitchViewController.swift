//
//  BookYourPitchViewController.swift
//  GameDay
//
//  Created by MAC on 24/12/20.
//

import UIKit
import ImageSlideshow
import Alamofire
import SwiftyJSON
import iOSDropDown

class BookYourPitchViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate,UICollectionViewDelegateFlowLayout {
    var presentWindow : UIWindow?

    @IBOutlet var lblDate: UILabel!
    @IBOutlet var pitchDetailsCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet var timeCollectionViewHeght: NSLayoutConstraint!
    @IBOutlet var durationCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet var btnHeading: UIButton!
    @IBOutlet weak var scerollPitchbooking: UIScrollView!
    @IBOutlet weak var viewSelectedDate: UIView!
    @IBOutlet weak var TimeCollectionView: UICollectionView!
    @IBOutlet weak var durationCollectionView: UICollectionView!
    @IBOutlet weak var btnWeeklyBooking: UIButton!
    @IBOutlet weak var btnSingleBooking: UIButton!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var pitchDetailsCollectionView: UICollectionView!
    @IBOutlet weak var lblPitchCurrency: UILabel!
    @IBOutlet weak var lblPitchPrice: UILabel!
    @IBOutlet weak var lblPitchTurfType: UILabel!
    @IBOutlet weak var lblPitchAddres1: UILabel!
    @IBOutlet weak var lblPitchType: UILabel!
    @IBOutlet weak var lblPitchname: UILabel!
    @IBOutlet weak var lblofferPrice: UILabel!
    @IBOutlet weak var btnBookNow: UIButton!
    let datePickerView:UIDatePicker = UIDatePicker()
    let datePickerViewForDemo:UIDatePicker = UIDatePicker()
    @IBOutlet weak var lblOutDoorPitch: UILabel!
    @IBOutlet weak var imageBookYourPitch: ImageSlideshow!
    var sdImageSource = [SDWebImageSource]()
    var sSelectedButton1 = String()
    var sSelectedButton2 = String()
    var sSelectedDate:String?
    var saveBookingResponseModel:SaveBookingResponseModel?
    var paymentinfo: Paymentinfo?
    var paymentinfoData: PaymentinfoData?
    var saved_cards: [Saved_cards]?
    var sBookingDetailsDuration:String?
    var sTimeSelected:Bool?
    @IBOutlet weak var txtDropSownWeekly: DropDown!
    var book_type_Selection : Int?

    var sBookingID:String?
    var sPitchId:String?
    var iBookType:Int?
    var iNo_of_Weeks:Int?
    var iTotalAmount:Int?
    var sDuration:Int?
    var sStart_Time:String?
    var sEndTime:String?
    var sPitchName:String?
    var sPitchAddress:String?
    var bFromFav = Bool()

    var bFromPreviusBookingList = Bool()
    var bfromUpcomingBookingList = Bool()
    var sGetedDuration = String()
    var iDurationId = String()
    var iTimeId = String()
    var sstartTime = String()
    var sendTime = String()

    var arrayDropDownWeekly = ["2 weeks","3 weeks","4 weeks","5 weeks","6 weeks","7 weeks","8 weeks","9 weeks","10 weeks","11 weeks","12 weeks",]

    
    var sStartTimeFromBookingListData = String()
    var sEndTimeFromBookingListData  = String()
    
    
    var sGetedDurationFromBooking = String()

    var sGetedTime = String()

    var bookingDetailsResponseModel:BookingDetailsResponseModel?
    var booking_list_data: booking_list_Data?
    var bookingDetails_lists:bookingDetails_list?
    var bookingpitchdata: Bookingpitchdata?
    var bookingimage_list: [Bookingimage_list]?
    
    
    var pitchDetailsResponseModel : PitchDetailsResponseModel?

    var pitch_detail: Pitch_detail?
    var pitch_detail_datas: Pitch_detail_data?
    var available_durations = [Available_durations]()
    var available_timeslots = [Available_timeslots]()
    var extra_features = [Extra_features]()
    var image_list = [Image_list]()


    let sharedData = SharedDefault()

    var iSelectedBookingId = Int()
    var sArrayTimeSlot = [String]()
    var sArrayImageGetted = [String]()

    var sArrayTimeSlot1 = ["6 - 8 PM","8 - 10 PM","10 - 12 PM"]
    var sArrayTimeSlot2 = ["6 - 7 PM","7 - 8 PM","8 - 9 PM"]
    var sArrayTimeSlot3 = ["6 - 7:30 PM","7:30 - 9 PM","9 - 10:30 PM"]

    var sArrayDuration = ["120 Min","60 Min","90 Min"]
    
    
    
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

    
    

    override func viewWillAppear(_ animated: Bool) {
        
        presentWindow = UIApplication.shared.keyWindow
        UIView.hr_setToastThemeColor(color: UIColor.white)
        UIView.hr_setToastFontColor(color: self.hexStringToUIColor(hex: "#6fc13a"))
        UIView.hr_setToastFontName(fontName: "TTOctosquares-Medium")
        
        self.lblDate.text = self.sSelectedDate
        self.available_timeslots.removeAll()
        if self.sBookingID == nil
        {
            self.sDuration = 0
            self.sBookingID = ""
            self.sstartTime = "05:00"
            self.sendTime = "23:59"
        }
        self.sTimeSelected = false
        
        
        if self.sBookingID!.count > 0
        {
            self.FetchBookingDetails()
            
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "dd MMM yyyy"

            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "yyyy-MM-dd"

            let date: NSDate? = dateFormatterGet.date(from: self.sSelectedDate!) as NSDate?
            print(dateFormatterPrint.string(from: date! as Date))
            
            self.sSelectedDate = dateFormatterPrint.string(from: date! as Date)
            
            
            
            if bFromPreviusBookingList
            {
                self.btnSubmit.isHidden = true
            }
            else
            {
                self.btnSubmit.isHidden = false

            }

        }
        else
        {
            self.sDuration = 0
            self.iDurationId = "0"
            self.sstartTime = "05:00"
            self.sendTime = "23:59"
            print(self.sPitchId)
            self.GetPitchListDetails(sStartTime: self.sstartTime, sEndTime: self.sendTime)
            self.TimeCollectionView.isHidden = true
        }
        
        self.txtDropSownWeekly.optionArray = arrayDropDownWeekly
        self.txtDropSownWeekly.didSelect{(selectedText , index ,id) in
            print("selectedText ----- ",selectedText)
            
            
            let index1 = selectedText.index(selectedText.startIndex, offsetBy: 0)
            String(selectedText[index1])    // "S"
            self.iBookType = 1
            self.book_type_Selection = 2

            self.iNo_of_Weeks = Int(String(selectedText[index1]))
            self.btnWeeklyBooking.setTitle(self.arrayDropDownWeekly[index], for: .normal)

            self.btnWeeklyBooking.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
            self.btnWeeklyBooking.layer.borderColor = UIColor(red: 42.0/255.0, green: 43.0/255.0, blue: 44.0/255.0, alpha: 1.0).cgColor
            self.btnWeeklyBooking.layer.borderWidth = 0.5
            self.btnWeeklyBooking.setTitleColor(.black, for: .normal)

//            self.txtSelectedDate.isEnabled = false
            
            self.btnSingleBooking.backgroundColor = UIColor.clear
            self.btnSingleBooking.layer.borderColor = UIColor.lightGray.cgColor
            self.btnSingleBooking.layer.borderWidth = 0.5
            self.btnSingleBooking.setTitleColor(.white, for: .normal)
            
            
        }
        
      
        
        // Disable swipe-to-pop gesture
                navigationController?.interactivePopGestureRecognizer?.delegate = self
                navigationController?.interactivePopGestureRecognizer?.isEnabled = false

                // Detect swipe gesture to load next entry
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipeNextEntry)))
        
        if bFromPreviusBookingList
        {
            self.btnHeading.setTitle("Booking Details", for: .normal)
        }
        else if bfromUpcomingBookingList
        {
            self.btnHeading.setTitle("Booking Details", for: .normal)
            self.btnSubmit.setTitle("Save", for: .normal)
        }
        else
        
        {
            if self.sSelectedDate!.count > 0
            {
                self.txtDate.text = self.sSelectedDate
            }

            if self.iBookType == 0
            {

                if bFromFav
                {
                    self.btnWeeklyBooking.backgroundColor = UIColor.clear
                    self.btnWeeklyBooking.layer.borderColor = UIColor.lightGray.cgColor
                    self.btnWeeklyBooking.layer.borderWidth = 0.5
                    self.btnWeeklyBooking.setTitleColor(.white, for: .normal)

                    self.btnWeeklyBooking.setTitle("Weekly Booking", for: .normal)
                    self.iBookType = 0
                    
                    self.btnSingleBooking.backgroundColor = UIColor.clear
                    self.btnSingleBooking.layer.borderColor = UIColor.lightGray.cgColor
                    self.btnSingleBooking.layer.borderWidth = 0.5
                    self.btnSingleBooking.setTitleColor(.white, for: .normal)
                }
               else
                {
                    self.btnWeeklyBooking.backgroundColor = UIColor.clear
                                    self.btnWeeklyBooking.layer.borderColor = UIColor.lightGray.cgColor
                                    self.btnWeeklyBooking.layer.borderWidth = 0.5
                                    self.btnWeeklyBooking.setTitleColor(.white, for: .normal)
                    
                    
                    
                                    self.btnSingleBooking.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
                                    self.btnSingleBooking.layer.borderColor = UIColor.darkGray.cgColor
                                    self.btnSingleBooking.layer.borderWidth = 0.5
                                    self.btnSingleBooking.setTitleColor(.black, for: .normal)
                                    
                }
                
                
                
                
            }
            else
            {
                if self.iNo_of_Weeks == nil
                {
                    self.iNo_of_Weeks = 0
                }
                let sTitle = String(self.iNo_of_Weeks!) + " " + "Weeks"
                self.btnWeeklyBooking.setTitle(sTitle, for: .normal)
                self.btnWeeklyBooking.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
                self.btnWeeklyBooking.layer.borderColor = UIColor.darkGray.cgColor
                self.btnWeeklyBooking.layer.borderWidth = 0.5
                self.btnWeeklyBooking.setTitleColor(.black, for: .normal)

                
                self.btnSingleBooking.backgroundColor = UIColor.clear
                self.btnSingleBooking.layer.borderColor = UIColor.lightGray.cgColor
                self.btnSingleBooking.layer.borderWidth = 0.5
                self.btnSingleBooking.setTitleColor(.white, for: .normal)
            }
        }
        
//        self.sArrayTimeSlot = self.sArrayTimeSlot1
        
       
        
      //  scerollPitchbooking.contentSize = CGSize(width: scerollPitchbooking.contentSize.width, height: 1000)
        scerollPitchbooking.isScrollEnabled = true

        // Do any additional setup after loading the view.
        btnWeeklyBooking.layer.borderWidth = 0.5
        btnWeeklyBooking.layer.borderColor = UIColor.lightGray.cgColor
        viewSelectedDate.layer.borderColor = UIColor.lightGray.cgColor
        viewSelectedDate.layer.borderWidth = 0.5
        btnBookNow.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
//        btnSingleBooking.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
        let pageIndicator = UIPageControl()
        pageIndicator.frame = CGRect(x: pageIndicator.frame.origin.x, y: pageIndicator.frame.origin.y, width: pageIndicator.frame.size.width, height: 0)
        pageIndicator.currentPageIndicatorTintColor = UIColor.white
        pageIndicator.pageIndicatorTintColor = UIColor.lightGray
        pageIndicator.layer.cornerRadius = 10.0
        pageIndicator.sizeToFit()
        imageBookYourPitch.pageIndicator = pageIndicator
//        imgSlideShow.layer.borderWidth = 1.5
//        imgSlideShow.layer.borderColor = UIColor.lightGray.cgColor
//        imgSlideShow.layer.cornerRadius = 5.0
        imageBookYourPitch.contentScaleMode = .scaleToFill
        imageBookYourPitch.slideshowInterval = 2.0
//        imageBookYourPitch.setImageInputs([ImageSource(image: UIImage(named: "Image1")!),
//                                     ImageSource(image: UIImage(named: "ground-1")!),
//                                     ImageSource(image: UIImage(named: "ground-2")!),
//                                     ImageSource(image: UIImage(named: "ground-4")!),ImageSource(image: UIImage(named: "ground-5")!
//                                                 )])
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        self.viewSelectedDate.layer.borderWidth = 0.5
        self.viewSelectedDate.layer.borderColor = UIColor.lightGray.cgColor
        
//        self.pitchDetailsCollectionView.collectionViewLayout = layout
//        pitchDetailsCollectionView.reloadData()
//        self.TimeCollectionView.collectionViewLayout = layout
//        TimeCollectionView.reloadData()
//        self.durationCollectionView.collectionViewLayout = layout
//        durationCollectionView.reloadData()
        
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker))]
        numberToolbar.sizeToFit()
        
        txtDate.inputAccessoryView = numberToolbar
        datePickerViewForDemo.datePickerMode = UIDatePicker.Mode.date
        txtDate.inputView = datePickerViewForDemo
        datePickerViewForDemo.addTarget(self, action: #selector(self.datePickerDemoFromValueChanged), for: UIControl.Event.valueChanged)
        
        datePickerViewForDemo.minimumDate = NSDate() as Date
        if #available(iOS 13.4, *) {
            datePickerViewForDemo.preferredDatePickerStyle = .wheels
        }
        txtDate.attributedPlaceholder = NSAttributedString(string: " Selecte Date",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        if self.iSelectedBookingId > 0
        {
            txtDate.isEnabled = true
        }
        self.pitchDetailsCollectionView.delegate = self
        self.TimeCollectionView.delegate = self
        self.durationCollectionView.delegate = self
        
        self.pitchDetailsCollectionView.dataSource = self
        self.TimeCollectionView.dataSource = self
        self.durationCollectionView.dataSource = self
        self.pitchDetailsCollectionView.reloadData()
        self.TimeCollectionView.reloadData()
        self.durationCollectionView.reloadData()
        
        
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
      //  scerollPitchbooking.delegate = self

     

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
    
    
    
    // MARK: keyboard notification
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scerollPitchbooking.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scerollPitchbooking.contentInset = contentInset
    }
    @objc func cancelPicker() {
        
        view.endEditing(true)
        
        
    }
    @objc func donePicker()
    {
        view.endEditing(true)

    }
    @objc func datePickerDemoFromValueChanged(sender:UIDatePicker)
    {
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd" //"dd-MM-yyyy""HH:mm:ss"
        
        dateFormatter.dateFormat = "yyyy-MM-dd" //"dd-MM-yyyy""HH:mm:ss"
        
//        self.sSelectedDate = dateFormatter.string(from: sender.date)

        
//        dateFormatter.dateFormat = "dd/MM/yyyy" //"dd-MM-yyyy""HH:mm:ss"

        
        //specialDateTextField.text = dateFormatter.string(from: sender.date)
        print("Selected date ::: ",dateFormatter.string(from: sender.date))
        txtDate.text = dateFormatter.string(from: sender.date)
        self.sSelectedDate = txtDate.text
    }
    
    
    
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scerollPitchbooking.contentInset = contentInset
    }
    @IBAction func ACtionBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func ActionDateSelection(_ sender: Any) {
    }
    @IBAction func btnBookingType(_ sender: UIButton) {
    }
    
    
    @IBAction func SubmitBooking(_ sender: Any)
    {
        if self.sBookingID?.count == 0
        {
            if self.sDuration == 0
             {
//                 self.showToast(message: "Please select duration")
                self.presentWindow?.makeToast(message: "Please select duration", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

             }
            
           else if self.sStart_Time?.count == 0 || self.sEndTime?.count == 0 ||  self.sStart_Time == nil || self.sEndTime == nil
            {
//                self.showToast(message: "Please select time slots")
            self.presentWindow?.makeToast(message: "Please select time slots", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

            }
           else if self.book_type_Selection == 0
            {
//                self.showToast(message: "Please select booking type")
            self.presentWindow?.makeToast(message: "Please select booking type", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.


            }
           else if self.iBookType == 1 && self.iNo_of_Weeks == 0
           {
//               self.showToast(message: "Please select the weeks")
            self.presentWindow?.makeToast(message: "Please select the weeks", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.


           }
          
           else if self.iBookType == 0 && self.txtDate.text?.count == 0
           {
//               self.showToast(message: "Please select date")
            self.presentWindow?.makeToast(message: "Please select date", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

           }
            else
            {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "PitchDetailsViewController") as! PitchDetailsViewController
            next.sSelectedDate = self.sSelectedDate
            next.sBookingID = self.sBookingID
            next.sPitchId = self.sPitchId
            next.iBookType = self.iBookType
            next.iNo_of_Weeks = self.iNo_of_Weeks
                
                next.sPitchName = self.sPitchName
                next.sPitchAddress = self.sPitchAddress

                next.sDuration =  self.sGetedDuration
                next.sDurationId = self.iDurationId
            next.sStartTime = self.sStart_Time
            next.sEndTime = self.sEndTime
            next.iTotalAmount = Int(self.lblPitchPrice.text!)

            self.navigationController?.pushViewController(next, animated: false)
            }
        }
        else
        {
        
//        let next = self.storyboard?.instantiateViewController(withIdentifier: "PitchDetailsViewController") as! PitchDetailsViewController
//        next.sSelectedDate = self.sSelectedDate
//        next.sBookingID = self.sBookingID
//        next.sPitchId = self.sPitchId
//        next.iBookType = self.iBookType
//        next.iNo_of_Weeks = 0
//        next.sDuration = self.sGetedDurationFromBooking
//        next.sStartTime = self.sStart_Time
//        next.sEndTime = self.sEndTime
//        next.iTotalAmount = Int(self.lblPitchPrice.text!)
//
//        self.navigationController?.pushViewController(next, animated: false)
            if bfromUpcomingBookingList
            {
                self.UpdateBookingDetails()

            }
        }
    
    }
    
    @IBAction func ActionDuration(_ sender: Any) {
    }
    
    @IBAction func ActionTime(_ sender: Any) {
    }
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var countVar:Int = 0
        
        
        if collectionView == pitchDetailsCollectionView
        {
            countVar = self.extra_features.count

        }
        else if collectionView == TimeCollectionView
        {
            if self.sBookingID?.count == 0
            {
                countVar = self.available_timeslots.count
            }
            else
            {
                
                countVar = self.available_timeslots.count + 1

            }
        }
        else
        {
            if self.sBookingID?.count == 0
            {
                countVar = self.available_durations.count
            }
            else
            {
                countVar = self.available_durations.count
//                countVar = 1

            }
        }
        
        
        return countVar
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        var countVar:Int = 0
//
//
//        if collectionView == pitchDetailsCollectionView
//        {
//            countVar = 1
//
//        }
//        else if collectionView == TimeCollectionView
//        {
//            if self.sBookingID?.count == 0
//            {
//                countVar = 1
//            }
//            else
//            {
//                countVar = 1
//
//            }
//        }
//        else
//        {
//            if self.sBookingID?.count == 0
//            {
//                countVar = 1
//            }
//            else
//            {
//                countVar = 1
//
//            }
//        }
        
        
        return 1
    }

    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
//        var color1 = hexStringToUIColor(hex: "#6FC13A")

        if collectionView == pitchDetailsCollectionView
        {


            let homeTypeCollectionViewCell = pitchDetailsCollectionView.dequeueReusableCell(withReuseIdentifier: "PitchDetailsCollectionViewCell", for: indexPath as IndexPath) as! PitchDetailsCollectionViewCell
      
          
            homeTypeCollectionViewCell.imgDetails.sd_setImage(with: URL(string: self.extra_features[indexPath.row].icon!), placeholderImage: UIImage(named: ""))
            homeTypeCollectionViewCell.lblDetails.text = self.extra_features[indexPath.row].name

            

         
            cell = homeTypeCollectionViewCell
 
            }
        
else  if collectionView == durationCollectionView
{


    let homeTypeCollectionViewCell1 = durationCollectionView.dequeueReusableCell(withReuseIdentifier: "DurationCollectionViewCell", for: indexPath as IndexPath) as! DurationCollectionViewCell

    homeTypeCollectionViewCell1.btnDuration.addTarget(self, action: #selector(masterAction3(_:)), for: .touchUpInside)

    homeTypeCollectionViewCell1.btnDuration.tag = indexPath.row

    homeTypeCollectionViewCell1.btnDuration.backgroundColor = UIColor.clear
    homeTypeCollectionViewCell1.btnDuration.layer.borderColor = UIColor.lightGray.cgColor
    homeTypeCollectionViewCell1.btnDuration.layer.borderWidth = 0.5
    homeTypeCollectionViewCell1.btnDuration.setTitleColor(.white, for: .normal)


    if self.sBookingID!.count > 0
    {
        if self.available_durations.count > 0 {
        homeTypeCollectionViewCell1.btnDuration.setTitle(self.available_durations[indexPath.row].duration! + " " + "Min", for: .normal)
        }

    if bFromPreviusBookingList
    {
        if self.sGetedDuration != nil || self.sGetedDuration.count != 0
        {
            
            if self.available_durations.count > 0 {
                if self.available_durations[indexPath.row].duration == self.sGetedDurationFromBooking
                {
                    homeTypeCollectionViewCell1.btnDuration.setTitle(self.sGetedDuration + " " + "Min", for: .normal)
            
                    homeTypeCollectionViewCell1.btnDuration.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
                    homeTypeCollectionViewCell1.btnDuration.setTitleColor(.black, for: .normal)
                    
                    self.iDurationId = String(self.available_durations[indexPath.row].id!)
                    self.GetPitchListDetailsForSelecteDuration(sStartDate: self.sStartTimeFromBookingListData, sEndDate: self.sEndTimeFromBookingListData)

                }
            }
            
        }
    }
    if bfromUpcomingBookingList
    {
        if self.sGetedDuration != nil || self.sGetedDuration.count != 0
        {
            
            
            if self.available_durations.count > 0 {
                if self.available_durations[indexPath.row].duration == self.sGetedDurationFromBooking
                {
                    homeTypeCollectionViewCell1.btnDuration.setTitle(self.sGetedDuration + " " + "Min", for: .normal)
            
                    homeTypeCollectionViewCell1.btnDuration.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
                    homeTypeCollectionViewCell1.btnDuration.setTitleColor(.black, for: .normal)
                    self.iDurationId = String(self.available_durations[indexPath.row].id!)
                    self.GetPitchListDetailsForSelecteDuration(sStartDate: self.sStartTimeFromBookingListData, sEndDate: self.sEndTimeFromBookingListData)
                }
            }
           
        }
    }
    }
    else
    {
        homeTypeCollectionViewCell1.btnDuration.setTitle(self.available_durations[indexPath.row].duration! + " " + "Min", for: .normal)
        
    }


    
    cell = homeTypeCollectionViewCell1

    }
else  if collectionView == TimeCollectionView
{
    

    
    let homeTypeCollectionViewCell2 = TimeCollectionView.dequeueReusableCell(withReuseIdentifier: "TimeCollectionViewCell", for: indexPath as IndexPath) as! TimeCollectionViewCell

    homeTypeCollectionViewCell2.btnTime.addTarget(self, action: #selector(TimeSelection(_:)), for: .touchUpInside)

    homeTypeCollectionViewCell2.btnTime.tag = indexPath.row
    homeTypeCollectionViewCell2.btnTime.backgroundColor = UIColor.clear
    homeTypeCollectionViewCell2.btnTime.layer.borderColor = UIColor.lightGray.cgColor
    homeTypeCollectionViewCell2.btnTime.layer.borderWidth = 0.5
    homeTypeCollectionViewCell2.btnTime.setTitleColor(.white, for: .normal)
    
    if self.sBookingID!.count > 0
    {
        

        
        
        if !self.sTimeSelected!
        {
        if indexPath .row == 0
        {
           
            homeTypeCollectionViewCell2.btnTime.setTitle(self.sGetedTime, for: .normal)
            
                homeTypeCollectionViewCell2.btnTime.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
                homeTypeCollectionViewCell2.btnTime.setTitleColor(.black, for: .normal)

            

        }
        else
        {
            let sStartTimeGetted = self.timeConversion12(time24: (self.available_timeslots[indexPath.row - 1].start_time)!)
            let sEndTimeGetted = self.timeConversion12AMPM(time24: (self.available_timeslots[indexPath.row - 1].end_time)!)
            let sOldtime = sStartTimeGetted + " - " + sEndTimeGetted
            
            homeTypeCollectionViewCell2.btnTime.setTitle(sOldtime, for: .normal)

        }
        }
        else
        {
            if indexPath .row == 0
            {
               
                homeTypeCollectionViewCell2.btnTime.setTitle(self.sGetedTime, for: .normal)
//
//                    homeTypeCollectionViewCell2.btnTime.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
//                    homeTypeCollectionViewCell2.btnTime.setTitleColor(.black, for: .normal)

                

            }
            else
            {
                let sStartTimeGetted = self.timeConversion12(time24: (self.available_timeslots[indexPath.row - 1].start_time)!)
                let sEndTimeGetted = self.timeConversion12AMPM(time24: (self.available_timeslots[indexPath.row - 1].end_time)!)
                let sOldtime = sStartTimeGetted + " - " + sEndTimeGetted
                homeTypeCollectionViewCell2.btnTime.setTitle(self.sGetedTime, for: .normal)

            }
        }

    }
else
    {
        let sStartTimeGetted = self.timeConversion12(time24: (self.available_timeslots[indexPath.row].start_time)!)
         let sEndTimeGetted = self.timeConversion12AMPM(time24: (self.available_timeslots[indexPath.row].end_time)!)
         self.sGetedTime = sStartTimeGetted + " - " + sEndTimeGetted
        
        
        homeTypeCollectionViewCell2.btnTime.setTitle(self.sGetedTime, for: .normal)

    }

    cell = homeTypeCollectionViewCell2

    }
//
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
//        if collectionView == pitchDetailsCollectionView
//        {
//            return CGSize(width:100 , height:35)
//        }
//        else
//        {
            
            let noOfCellsInRow = 3   //number of column you want
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
            return CGSize(width: size, height: 40)
            
//            return CGSize(width:145 , height:40)


//        }
        
       
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func GetFilterMasterListDetails()
    {
     
        self.view.activityStartAnimating()
        if txtDate.text?.count == 0
        {
            self.sSelectedDate = Date.getCurrentDate()
        }
        var postDict = Dictionary<String,String>()
        postDict = ["access_token":self.sharedData.getAccessToken(),
                    "date":self.sSelectedDate!,
                    "duration":String(self.iDurationId),
                    "start_time":self.sstartTime,
                    "end_time":self.sendTime,
                    "pitch_id":String(self.sPitchId!)


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
                    self.filterResponseModel = FilterResponseModel(response)
//
                    self.filter_datas = self.filterResponseModel?.filterData?.filter_datas
                    self.filter_masters = self.filterResponseModel?.filterData?.filter_masters
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

//                        if self.durations!.count > 0
//                        {
//                            self.durationCollection.reloadData()
//                        }
//                        if self.pitch_sizes!.count > 0
//                        {
//                            self.sizeCollection.reloadData()
//                        }
//                        if self.pitch_turfs!.count > 0
//                        {
//                            self.TurfCollection.reloadData()
//                        }
//                        if self.pitch_types!.count > 0
//                        {
//                            self.typeCollection.reloadData()
//                        }
//


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
    
    @objc func masterAction3(_ sender: UIButton)
    {
       
      
        if self.sBookingID?.count == 0
        {
            
        
        
        print(sender.tag)
            for index in 0..<self.available_durations.count
        {
                self.TimeCollectionView.isHidden = false

         print(index)
            
            if index == sender.tag
            {

                let index = IndexPath(row: index, section: 0)
                print("Selected Cell  equel :",index)

                let cell: DurationCollectionViewCell = self.durationCollectionView.cellForItem(at: index) as! DurationCollectionViewCell
                cell.btnDuration.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
                cell.btnDuration.setTitleColor(.black, for: .normal)
                
                self.sGetedDuration = String(self.available_durations[sender.tag].duration!)
                self.iDurationId = String(self.available_durations[sender.tag].id!)
                self.sGetedDurationFromBooking =  self.sGetedDuration
                
                
                self.GetPitchListDetailsForSelecteDuration(sStartDate: "05:00", sEndDate: "23:00")

//                self.GetPitchListDetailsForSelecteDuration(sStartDate: self.sStartTimeFromBookingListData, sEndDate: self.sEndTimeFromBookingListData)
                self.sDuration = self.available_durations[sender.tag].id
                
                if cell.btnDuration.titleLabel?.text == "120 Min"
                {
                    print("Selected index",index)
                    
//                    self.sArrayTimeSlot = self.sArrayTimeSlot1
                }
                else  if cell.btnDuration.titleLabel?.text == "60 Min"
                {
                    print("Selected iondex",index)
                    
//                    self.sArrayTimeSlot = self.sArrayTimeSlot2

                }
                else  if cell.btnDuration.titleLabel?.text == "90 Min"
                {
                    print("Selected iondex",index)
//                    self.sArrayTimeSlot = self.sArrayTimeSlot3

                }
//                self.TimeCollectionView.reloadData()
            }
//           else if index < 3 && sender.tag <= 2
                else

           
            {
                let index = IndexPath(row: index, section: 0)
                print("Selected Cell Not equel :::::",index)

                let cell: DurationCollectionViewCell = self.durationCollectionView.cellForItem(at: index) as! DurationCollectionViewCell
                cell.btnDuration.backgroundColor = UIColor.clear
                cell.btnDuration.setTitleColor(.white, for: .normal)
            }

        
        }
        
        }
    }
    
    @objc func TimeSelection(_ sender: UIButton)
    {
       
        
//        if self.sBookingID?.count == 0
//        {
//
        print(sender.tag)
            for index in 0..<self.available_timeslots.count
        {
                self.sTimeSelected = true
         print(index)
            
            if index == sender.tag
            {
                let index = IndexPath(row: index, section: 0)
                print("Selected Cell  equel :::::",index)

                let cell: TimeCollectionViewCell = self.TimeCollectionView.cellForItem(at: index) as! TimeCollectionViewCell
                cell.btnTime.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
                cell.btnTime.setTitleColor(.black, for: .normal)
                if self.sBookingID!.count > 0
                {
                    if sender.tag > 0
                    {
                        self.sStart_Time = self.available_timeslots[sender.tag - 1].start_time
                        self.sEndTime = self.available_timeslots[sender.tag - 1].end_time
                    }
                    else
                    {
                        self.sStart_Time = self.available_timeslots[sender.tag].start_time
                        self.sEndTime = self.available_timeslots[sender.tag].end_time
                    }
                   
                }
                else
                {
                self.sStart_Time = self.available_timeslots[sender.tag].start_time
                self.sEndTime = self.available_timeslots[sender.tag].end_time
                }

            }
           else
            {
//                if index < 3 && sender.tag <= 2
//                {
                    let index = IndexPath(row: index, section: 0)
                    print("Selected Cell Not equel :::::",index)

                    let cell: TimeCollectionViewCell = self.TimeCollectionView.cellForItem(at: index) as! TimeCollectionViewCell
                    cell.btnTime.backgroundColor = UIColor.clear
                    cell.btnTime.setTitleColor(.white, for: .normal)
//                }
               
            }

        
        }
//        }
    }
    
    @IBAction func ACtionweeklyBooking(_ sender: Any)
    {
        if self.sBookingID?.count == 0
        {
        if bfromUpcomingBookingList
        {
        self.btnWeeklyBooking.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
        self.btnWeeklyBooking.layer.borderColor = UIColor(red: 42.0/255.0, green: 43.0/255.0, blue: 44.0/255.0, alpha: 1.0).cgColor
        self.btnWeeklyBooking.layer.borderWidth = 0.5
        self.btnWeeklyBooking.setTitleColor(.black, for: .normal)

        self.iBookType = 1

        self.btnSingleBooking.backgroundColor = UIColor.clear
        self.btnSingleBooking.layer.borderColor = UIColor.lightGray.cgColor
        self.btnSingleBooking.layer.borderWidth = 0.5
        self.btnSingleBooking.setTitleColor(.white, for: .normal)
        }
        }
        
    }
    @IBAction func ActionSingle_Weekly_Booking(_ sender: Any)
    {
        if self.sBookingID?.count == 0
        {
//            {
                self.btnWeeklyBooking.backgroundColor = UIColor.clear
                self.btnWeeklyBooking.layer.borderColor = UIColor.lightGray.cgColor
                self.btnWeeklyBooking.layer.borderWidth = 0.5
                self.btnWeeklyBooking.setTitleColor(.white, for: .normal)

                self.btnWeeklyBooking.setTitle("Weekly Booking", for: .normal)
                self.iBookType = 0
                self.book_type_Selection = 1

                self.btnSingleBooking.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
                self.btnSingleBooking.layer.borderColor = UIColor(red: 42.0/255.0, green: 43.0/255.0, blue: 44.0/255.0, alpha: 1.0).cgColor
                self.btnSingleBooking.layer.borderWidth = 0.5
                self.btnSingleBooking.setTitleColor(.black, for: .normal)

//            }
        }
        
//
    }
    
    func FetchBookingDetails()
    {
     
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = ["access_token":self.sharedData.getAccessToken(),
                    "book_id":self.sBookingID!
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
                        
                        for item in self.bookingimage_list!
                        {
                            self.sArrayImageGetted.append(item.link!)
                            
                        }
                       
                        self.sdImageSource.removeAll()
                        
                        for img in self.sArrayImageGetted{
                            self.sdImageSource.append(SDWebImageSource(urlString: img)!)
                        }
                        self.imageBookYourPitch.setImageInputs(self.sdImageSource)
                        
                        self.lblPitchname.text = self.bookingpitchdata?.pitch_name
                        self.lblofferPrice.text = String((self.bookingpitchdata?.discount!)!) + "" + (self.bookingpitchdata?.discount_type)!
                        self.lblOutDoorPitch.text = self.bookingpitchdata?.pitch_type;             self.btnWeeklyBooking.layer.borderWidth = 0.5
                        self.btnWeeklyBooking.setTitleColor(.black, for: .normal)

                      
                        self.lblPitchPrice.text = String((self.bookingpitchdata?.rate)!)
                        if self.bookingpitchdata?.rate_unit == "Hour"
                        {
                            self.lblPitchCurrency.text = "AED/HR"

                        }
                        else
                        {
                            self.lblPitchCurrency.text =  "AED/HR"

                        }
                        self.lblPitchAddres1.text = self.bookingpitchdata?.pitch_size
                        self.lblPitchTurfType.text = self.bookingpitchdata?.pitch_turf
                        if self.bookingDetails_lists?.book_type == "recurring"
                        {
                            self.btnWeeklyBooking.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
                            self.btnWeeklyBooking.layer.borderColor = UIColor.darkGray.cgColor
                 self.iBookType = 1
                            
                            
                            
                            let sTitle = String((self.bookingDetails_lists?.Weeks)!) + " " + "Weeks"
                            self.btnWeeklyBooking.setTitle(sTitle, for: .normal)
                            
                            
                            
                            self.btnSingleBooking.backgroundColor = UIColor.clear
                            self.btnSingleBooking.layer.borderColor = UIColor.lightGray.cgColor
                            self.btnSingleBooking.layer.borderWidth = 0.5
                            self.btnSingleBooking.setTitleColor(.white, for: .normal)
                        }
                        else
                        {
                            self.btnWeeklyBooking.backgroundColor = UIColor.clear
                            self.btnWeeklyBooking.layer.borderColor = UIColor.lightGray.cgColor
                            self.btnWeeklyBooking.layer.borderWidth = 0.5
                            self.btnWeeklyBooking.setTitleColor(.white, for: .normal)

                            self.iBookType = 0
                            
                            self.btnSingleBooking.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
                            self.btnSingleBooking.layer.borderColor = UIColor.darkGray.cgColor
                            self.btnSingleBooking.layer.borderWidth = 0.5
                            self.btnSingleBooking.setTitleColor(.black, for: .normal)
                        }
                        self.txtDate.text = self.convertDateFormater((self.bookingDetails_lists?.date)!)
                        
                        self.sGetedDuration =  String((self.bookingDetails_lists?.duration)!) + " " + "Min"
//                        self.sGetedTime = (self.bookingDetails_lists?.start_time)! + " - " + (self.bookingDetails_lists?.end_time)!
                        self.sGetedDurationFromBooking = String((self.bookingDetails_lists?.duration)!)
                        self.sStart_Time = (self.bookingDetails_lists?.start_time)!
                        if String((self.bookingDetails_lists?.pitch_id)!).count == 0 || String((self.bookingDetails_lists?.pitch_id)!) == nil
                        {
                            self.sPitchId =  String((self.bookingDetails_lists?.pitch_id)!)

                        }
                        
                        self.sEndTime = (self.bookingDetails_lists?.end_time)!
                        self.sPitchId = String((self.bookingDetails_lists?.pitch_id)!)
                        
                        self.sstartTime = (self.bookingDetails_lists?.start_time)!
                        self.sendTime = (self.bookingDetails_lists?.end_time)!
                        self.sGetedDuration = String((self.bookingDetails_lists?.duration)!)
                        self.sDuration = 0
                        
                        
                        let dateAsString = self.sstartTime
                        let df = DateFormatter()
                        df.dateFormat = "HH:mm:ss"

                        let date = df.date(from: dateAsString)
                        df.dateFormat = "hh:mm"

                        let time12 = df.string(from: date!)
                        print(time12)
                        
                        let dateAsString1 = self.sendTime
                        let df1 = DateFormatter()
                        df1.dateFormat = "HH:mm:ss"

                        let date1 = df1.date(from: dateAsString1)
                        df1.dateFormat = "hh:mm"

                        let time121 = df.string(from: date1!)
                        print(time121)
                        self.sStartTimeFromBookingListData = time12
                        self.sEndTimeFromBookingListData = time121
                        
                        
                        
                        if self.sGetedDuration == "60"
                        {
                            self.iDurationId =  "2"
                        }
                        else  if self.sGetedDuration == "120"
                         {
                            self.iDurationId =  "1"

                           }
                        else  if self.sGetedDuration == "90"
                         {
                            self.iDurationId =  "3"

                           }
//                        let dateFormatterGet = DateFormatter()
//                        dateFormatterGet.dateFormat = "dd MMM,yyyy"
//
//                        let dateFormatterPrint = DateFormatter()
//                        dateFormatterPrint.dateFormat = "yyyy-MM-dd"
//
//                        let _: NSDate? = dateFormatterGet.date(from: self.sSelectedDate!) as NSDate?
//                        print(dateFormatterPrint.string(from: date! as Date))
//                        self.sSelectedDate = dateFormatterPrint.string(from: date! as Date)
                        
                       let sStartTimeGetted = self.timeConversion12FromBookingDetails(time24: (self.sStart_Time)!)
                        let sEndTimeGetted = self.timeConversion12AMPMFromBookingDetails(time24: (self.sEndTime)!)
                        self.sGetedTime = sStartTimeGetted + " - " + sEndTimeGetted
                        self.GetPitchListDetails(sStartTime: "05:00", sEndTime: "23:59")

                        self.TimeCollectionView.isHidden = false
                        self.TimeCollectionView.reloadData()
                        self.pitchDetailsCollectionView.reloadData()
                        self.view.activityStopAnimating()

                    }
                    if statusCode == 400
                    {

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
    
    func timeConversion12(time24: String) -> String {
        let dateAsString = time24
        let df = DateFormatter()
        df.dateFormat = "HH:mm"

        let date = df.date(from: dateAsString)
        df.dateFormat = "hh:mm"

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
    
    
    
    func timeConversion12FromBookingDetails(time24: String) -> String {
        let dateAsString = time24
        let df = DateFormatter()
        df.dateFormat = "HH:mm:ss"

        let date = df.date(from: dateAsString)
        df.dateFormat = "hh:mm"

        let time12 = df.string(from: date!)
        print(time12)
        return time12
    }
    func timeConversion12AMPMFromBookingDetails(time24: String) -> String {
        let dateAsString = time24
        let df = DateFormatter()
        df.dateFormat = "HH:mm:ss"

        let date = df.date(from: dateAsString)
        df.dateFormat = "hh:mm a"

        let time12 = df.string(from: date!)
        print(time12)
        return time12
    }
    
    
    func GetPitchList()
    {
     
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = ["access_token":self.sharedData.getAccessToken(),
                    "book_type":String(self.iBookType!),
                    "weeks":String(self.iNo_of_Weeks!),
                    "start_time":"05:00",
                    "end_time":"23:59",
                    "date":self.sSelectedDate!,
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
                    self.filter_datas = self.filterResponseModel?.filterData?.filter_datas
                    self.filter_masters = self.filterResponseModel?.filterData?.filter_masters
                    self.durations = self.filter_masters?.durations
                    self.pitch_sizes = self.filter_masters?.pitch_sizes
                    self.pitch_turfs = self.filter_masters?.pitch_turfs
                    self.pitch_types = self.filter_masters?.pitch_types
                    self.user_details = self.filterResponseModel?.filterData?.user_details
                    self.pitch_list = (self.filterResponseModel?.filterData?.pitch_list)!
                    var height:Int?
                    var nHieght:Int?
                    let statusCode = Int((self.filterResponseModel?.httpcode)!)
                    if statusCode == 200{
                        print("registerResponseModel ----- ",self.filterResponseModel)
//                        if self.pitch_list.count > 0
//                        {
//                            self.tblPitchList.delegate = self
//                            self.tblPitchList.dataSource = self
//                            self.tblPitchList.allowsSelection = true
//                            self.tblPitchList.reloadData()
//                        }
                        
                        
                        print("Pitch list count:--->", self.pitch_list.count)
                        print("Duration list count:--->", self.durations?.count ?? "0")
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
                            self.durationCollectionView.reloadData()
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
    func GetPitchListDetailsForSelecteDuration(sStartDate:String,sEndDate:String)
    {
     
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = ["access_token":self.sharedData.getAccessToken(),
                    "pitch_id":String(self.sPitchId!),
                    "duration":String(iDurationId),
                    "start_time":sStartDate,
                    "end_time":sEndDate,
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
                    var height:Int?
                    var nHieght:Int?
                  
                    let statusCode = Int((self.pitchDetailsResponseModel?.httpcode)!)
                    if statusCode == 200{
                        self.pitch_detail_datas = self.pitch_detail?.pitch_detail_datas

                        if self.sBookingID?.count == 0
                        {
                            self.available_timeslots = (self.pitch_detail_datas?.available_timeslots)!
                            if self.available_timeslots.count > 0
                            {
                                let q = self.available_timeslots.count.quotientAndRemainder(dividingBy: 3)

                                print(q ?? 0)
                                
                                let iSize  = Double(self.available_timeslots.count ?? 0) / 3.0
                                
                                if iSize.rounded(.up) == iSize.rounded(.down)
                                {
                                    height = Int(q.quotient ?? 0) * 50
                                }
                                else
                                {
                                    nHieght = Int(q.quotient ?? 0) + 1
                                    height = Int(nHieght ?? 0) * 50
                                }
                                self.timeCollectionViewHeght.constant = CGFloat(height ?? 50)

                                self.TimeCollectionView.reloadData()
                            }
                            
                        }
                        if self.available_timeslots.count == 0 && self.sBookingID?.count == 0
                        {
//                            self.showToast(message: "No available time slot for selected duration")
                            self.presentWindow?.makeToast(message: "No available time slot for selected duration", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                            self.durationCollectionView.reloadData()
                        }
      
                        self.TimeCollectionView.reloadData()
                        self.view.activityStopAnimating()

                    }
                    if statusCode == 400{
                        self.view.activityStopAnimating()

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
    
    func GetPitchListDetails(sStartTime:String,sEndTime:String)
    {
     
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = ["access_token":self.sharedData.getAccessToken(),
                    "pitch_id":self.sPitchId!,
                    "duration":self.iDurationId,
//                    "duration":"1",
                    "start_time":sStartTime,
                    "end_time":sEndTime,
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
                    var height:Int?
                    var nHieght:Int?
                  
                    let statusCode = Int((self.pitchDetailsResponseModel?.httpcode)!)
                    if statusCode == 200{
                        self.pitch_detail_datas = self.pitch_detail?.pitch_detail_datas

//                        if self.sBookingID?.count == 0
//                        {
                        
                        
                        self.available_timeslots.removeAll()
                        
                            self.image_list = (self.pitch_detail_datas?.image_list)!
                            self.available_durations = (self.pitch_detail_datas?.available_durations)!
                            self.available_timeslots = (self.pitch_detail_datas?.available_timeslots)!
                            
                        
                        if self.available_durations.count > 0
                        {
                            
                            
                            
                            let q = self.available_durations.count.quotientAndRemainder(dividingBy: 3)

                            print(q ?? 0)
                            
                            let iSize  = Double(self.available_durations.count ?? 0) / 3.0
                            
                            if iSize.rounded(.up) == iSize.rounded(.down)
                            {
                                height = Int(q.quotient ?? 0) * 50
                            }
                            else
                            {
                                nHieght = Int(q.quotient ?? 0) + 1
                                height = Int(nHieght ?? 0) * 50
                            }
                            self.durationCollectionViewHeight.constant = CGFloat(height ?? 50)
                            self.durationCollectionView.reloadData()
                        }
//                        if self.available_timeslots.count > 0
//                        {
//                            let q = self.available_timeslots.count.quotientAndRemainder(dividingBy: 3)
//
//                            print(q ?? 0)
//                            
//                            let iSize  = Double(self.available_timeslots.count ?? 0) / 3.0
//                            
//                            if iSize.rounded(.up) == iSize.rounded(.down)
//                            {
//                                height = Int(q.quotient ?? 0) * 50
//                            }
//                            else
//                            {
//                                nHieght = Int(q.quotient ?? 0) + 1
//                                height = Int(nHieght ?? 0) * 50
//                            }
//                            self.timeCollectionViewHeght.constant = CGFloat(height ?? 50)
//
//                            self.TimeCollectionView.reloadData()
//                        }
                        
                            self.sdImageSource.removeAll()
                            
                            
                            
                            self.lblPitchname.text = self.pitch_detail_datas?.pitch_name
                        self.lblofferPrice.text = self.pitch_detail_datas?.discount ?? "" + " " + (self.pitch_detail_datas?.discount_type)! 
                            self.lblOutDoorPitch.text = self.pitch_detail_datas?.pitch_type
                            self.lblPitchPrice.text = String((self.pitch_detail_datas?.rate)!)
                        
//                        if self.pitch_detail_datas?.rate_unit == "Hour"
//                        {
                            self.lblPitchCurrency.text = "AED/HR"

//                        }
//                        else
//                        {
//                            self.lblPitchCurrency.text =  "AED/HR"
//
//                        }
                        
                        
                        
                        self.lblPitchAddres1.text = self.pitch_detail_datas?.pitch_size
                            self.lblPitchTurfType.text = self.pitch_detail_datas?.pitch_turf
                            self.sArrayImageGetted.removeAll()
                        
                        if self.image_list.count > 0
                        {
                            for item in self.image_list
                            {
                                self.sArrayImageGetted.append(item.link!)
                                
                            }
                            
                            for img in self.sArrayImageGetted{
                                self.sdImageSource.append(SDWebImageSource(urlString: img)!)
                            }
                            
                            self.imageBookYourPitch.setImageInputs(self.sdImageSource)
                        }
                            

//                        }
                       
                        self.extra_features = (self.pitch_detail_datas?.extra_features)!
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
                            self.pitchDetailsCollectionViewHeight.constant = CGFloat(height ?? 50)

                            self.pitchDetailsCollectionView.reloadData()

                            
                        }
                        
                       
                 
//                        self.TimeCollectionView.reloadData()
                        self.durationCollectionView.reloadData()
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
    
    func UpdateBookingDetails()
    {
     
        self.view.activityStartAnimating()
        
        
        
        var postDict = Dictionary<String,String>()
        postDict = ["access_token":self.sharedData.getAccessToken(),
                    "book_id":self.sBookingID!,
                    "date":self.txtDate.text!,
                    "start_time":self.sStart_Time!,
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
                        
                        self.showToast(message:(self.saveBookingResponseModel?.message)!)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
                        {
                        
//                        let next = self.storyboard?.instantiateViewController(withIdentifier: "BookingConformationViewController") as! BookingConformationViewController
//                            next.sPitchAddress = self.sPitchAddress
//                            next.sStartTime = self.sStart_Time
//                            next.sEndTime = self.sEndTime
//                            next.sBookingDate = self.sSelectedDate
//                            next.sPitchName = self.sPitchName
//                        self.navigationController?.pushViewController(next, animated: false)
                            
                            
                            self.navigationController?.popViewController(animated: true)
                        
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
    func convertDateFormater(_ date: String) -> String
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            let date = dateFormatter.date(from: date)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return  dateFormatter.string(from: date!)

        }
    
}
