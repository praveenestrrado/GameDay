//
//  HomeViewController.swift
//  GameDay
//
//  Created by MAC on 15/12/20.
//

import UIKit
import ImageSlideshow
import iOSDropDown
import AlamofireImage
import SwiftyJSON
import Alamofire
import CoreLocation


class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CLLocationManagerDelegate {
    var presentWindow : UIWindow?

    @IBOutlet var lblWelcome: UILabel!
    @IBOutlet var btnNearMe: UIButton!
    @IBOutlet weak var lblTemperatureWithHumidity: UILabel!
    @IBOutlet weak var lbltemp: UILabel!
    @IBOutlet weak var txtDropSownWeekly: DropDown!
    @IBOutlet weak var lblHome: UILabel!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnGameOn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtSelectedDate: UITextField!
    @IBOutlet weak var btnOutDoor: UIButton!
    @IBOutlet weak var btnIndoor: UIButton!
    @IBOutlet weak var btnAny2: UIButton!
    @IBOutlet weak var viewNearMe: UIView!
    @IBOutlet weak var viewSelectedDate: UIView!
    @IBOutlet weak var btnWeeklyBooking: UIButton!
    @IBOutlet weak var btnSingleBooking: UIButton!
    @IBOutlet weak var viewBase: UIView!
    var sdImageSource = [SDWebImageSource]()
    let TempAPIKey = "bf02c109eaade4a99c7ab856d9c5fbd3"
    var sSelectedButton = String()
    var sSelectedType = String()
    var sPitch_type : String?
    var sSelectedTypeName = String()

    var sCurrentLattitude = Double()
    var sCurrentLongitude = Double()
    let locationManager = CLLocationManager()
    var book_type : Int?
    var book_type_Selection : Int?

    var weeks : Int?
    var iBtnLocationType : Int?

    let sharedData = SharedDefault()
    var homeResponseModel: HomeResponseModel?
    var pitch_types = [Pitch_types]()

    var arrayDropDownWeekly = ["2 weeks","3 weeks","4 weeks","5 weeks","6 weeks","7 weeks","8 weeks","9 weeks","10 weeks","11 weeks","12 weeks",]

    var locManager = CLLocationManager()
    var currentLocation: CLLocation!

    @IBOutlet weak var imgSlideShow: ImageSlideshow!
    let datePickerView:UIDatePicker = UIDatePicker()
    let datePickerViewForDemo:UIDatePicker = UIDatePicker()
    @IBOutlet weak var collectioType: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weeks = 0
        self.book_type = 0
        self.iBtnLocationType = 0
        self.book_type_Selection = 0
        // Do any additional setup after loading the view.
        
        presentWindow = UIApplication.shared.keyWindow
        UIView.hr_setToastThemeColor(color: UIColor.white)
        UIView.hr_setToastFontColor(color: self.hexStringToUIColor(hex: "#6fc13a"))
        UIView.hr_setToastFontName(fontName: "TTOctosquares-Medium")
        
        self.sCurrentLattitude =  0.00
        self.sCurrentLongitude = 0.00
        
        self.btnAny2.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
        self.btnAny2.layer.borderColor = UIColor(red: 42.0/255.0, green: 43.0/255.0, blue: 44.0/255.0, alpha: 1.0).cgColor
        self.btnAny2.layer.borderWidth = 0.5
        self.btnAny2.setTitleColor(.black, for: .normal)

        self.iBtnLocationType = 1
        self.viewNearMe.backgroundColor = UIColor.clear
        self.viewNearMe.layer.borderColor = UIColor.lightGray.cgColor
        self.viewNearMe.layer.borderWidth = 0.5
        self.btnNearMe.setTitleColor(.white, for: .normal)
        self.getHomeContent()
        
        self.btnWeeklyBooking.backgroundColor = UIColor.clear
        self.btnWeeklyBooking.layer.borderColor = UIColor.lightGray.cgColor
        self.btnWeeklyBooking.layer.borderWidth = 0.5
        self.btnWeeklyBooking.setTitleColor(.white, for: .normal)

        self.btnWeeklyBooking.setTitle("Weekly Booking", for: .normal)
        self.book_type = 0
        self.book_type_Selection = 1

        self.btnSingleBooking.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
        self.btnSingleBooking.layer.borderColor = UIColor(red: 42.0/255.0, green: 43.0/255.0, blue: 44.0/255.0, alpha: 1.0).cgColor
        self.btnSingleBooking.layer.borderWidth = 0.5
        self.btnSingleBooking.setTitleColor(.black, for: .normal)
        self.SetUI()

    }
    
    override func viewWillAppear(_ animated: Bool) {
     

    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    @IBAction func ACtionweeklyBooking(_ sender: Any)
    {
        self.btnWeeklyBooking.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
        self.btnWeeklyBooking.layer.borderColor = UIColor(red: 42.0/255.0, green: 43.0/255.0, blue: 44.0/255.0, alpha: 1.0).cgColor
        self.btnWeeklyBooking.layer.borderWidth = 0.5
        self.btnWeeklyBooking.setTitleColor(.black, for: .normal)

        self.book_type = 1
        self.book_type_Selection = 2

        self.btnSingleBooking.backgroundColor = UIColor.clear
        self.btnSingleBooking.layer.borderColor = UIColor.lightGray.cgColor
        self.btnSingleBooking.layer.borderWidth = 0.5
        self.btnSingleBooking.setTitleColor(.white, for: .normal)

        
    }
    
    @IBAction func ACtionDateSelection(_ sender: Any)
    {
       
    }
    @IBAction func ActionSingle_Weekly_Booking(_ sender: Any)
    {
        self.btnWeeklyBooking.backgroundColor = UIColor.clear
        self.btnWeeklyBooking.layer.borderColor = UIColor.lightGray.cgColor
        self.btnWeeklyBooking.layer.borderWidth = 0.5
        self.btnWeeklyBooking.setTitleColor(.white, for: .normal)

        self.btnWeeklyBooking.setTitle("Weekly Booking", for: .normal)
        self.book_type = 0
        self.book_type_Selection = 1

        self.btnSingleBooking.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
        self.btnSingleBooking.layer.borderColor = UIColor(red: 42.0/255.0, green: 43.0/255.0, blue: 44.0/255.0, alpha: 1.0).cgColor
        self.btnSingleBooking.layer.borderWidth = 0.5
        self.btnSingleBooking.setTitleColor(.black, for: .normal)

    }
    @IBAction func ActionGameOn(_ sender: Any)
    {
        if self.book_type_Selection == 0
        {
//            self.showToast(message: "Please select booking type")
            
            presentWindow?.makeToast(message: "Please select booking type", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.


        }
        else if self.book_type == 1 && self.weeks == 0
        {
//            self.showToast(message: "Please select the weeks")
            presentWindow?.makeToast(message: "Please select the weeks", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

        }
       
        else if self.book_type == 0 && self.txtSelectedDate.text?.count == 0
        {
//            self.showToast(message: "Please select date")
            presentWindow?.makeToast(message: "Please select date", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

        }
//        else if self.iBtnLocationType == 0
//        {
//            self.showToast(message: "Please select type of location")
//
//        }
//        else if self.sSelectedType.count == 0
//        {
//            self.showToast(message: "Please select type of pitch")
//        }
        else if self.txtSelectedDate.text?.count == 0
        {
//            self.showToast(message: "Please select date")
            presentWindow?.makeToast(message: "Please select date", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.
        }
        else
        {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "PItchListViewController") as! PItchListViewController
            
            if self.txtSelectedDate.text?.count == 0
            {
                next.sSelectedDate = Date.getCurrentDate()

            }
            else
            {
        next.sSelectedDate = self.txtSelectedDate.text
            }
        next.sLatitude = ""
        next.sLongitude = ""
        next.book_type = self.book_type
        next.bFromFilter = 2 
        next.sPitch_typeNameFromFilter = sSelectedTypeName
        next.weeks = self.weeks
        next.sPitch_typeFromFilter =  self.sSelectedType

        self.navigationController?.pushViewController(next, animated: false)
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
    func SetUI()
    {
        
        
       
        
        txtSelectedDate.text = ""

        if self.sharedData.getfname().count > 0
        {
            self.lblWelcome.text = "Welcome " + self.sharedData.getfname()

        }
        else
        {
            self.lblWelcome.text = ""

        }
        self.locManager.requestWhenInUseAuthorization()

        self.sSelectedType = "0"
        if(CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
       // Booking Type Defoult all clear color
//        self.btnWeeklyBooking.backgroundColor = UIColor.clear
//        self.btnWeeklyBooking.layer.borderColor = UIColor.lightGray.cgColor
//        self.btnWeeklyBooking.layer.borderWidth = 0.5
//        self.btnWeeklyBooking.setTitleColor(.white, for: .normal)
//
//        self.btnWeeklyBooking.setTitle("Weekly Booking", for: .normal)
//        self.book_type = 0
//
//        self.btnSingleBooking.backgroundColor = UIColor.clear
//        self.btnSingleBooking.layer.borderColor = UIColor.lightGray.cgColor
//        self.btnSingleBooking.layer.borderWidth = 0.5
//        self.btnSingleBooking.setTitleColor(.white, for: .normal)
        
        
        
        
        
//        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
//                    CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
//                    guard let currentLocation = locManager.location else {
//                        return
//                    }
//                    print(currentLocation.coordinate.latitude)
//            self.sCurrentLattitude = currentLocation.coordinate.latitude
//            self.sCurrentLongitude = currentLocation.coordinate.longitude
//                    print(currentLocation.coordinate.longitude)
//                }
        self.datePickerViewForDemo.setDate(Date(), animated: true)
        self.datePickerViewForDemo.minimumDate = Date()
       
        self.datePickerViewForDemo.reloadInputViews()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.collectioType.collectionViewLayout = layout
        self.txtDropSownWeekly.optionArray = arrayDropDownWeekly
        self.txtDropSownWeekly.didSelect{(selectedText , index ,id) in
            print("selectedText ----- ",selectedText)
            
            
            let index1 = selectedText.index(selectedText.startIndex, offsetBy: 0)
            String(selectedText[index1])    // "S"
            self.book_type = 1
            self.book_type_Selection = 2

            self.weeks = Int(String(selectedText[index1]))
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
        
        
        self.scrollView.isScrollEnabled = true
        self.collectioType.isUserInteractionEnabled = true

        let pageIndicator = UIPageControl()
        pageIndicator.frame = CGRect(x: pageIndicator.frame.origin.x, y: pageIndicator.frame.origin.y, width: pageIndicator.frame.size.width, height: 0)
        pageIndicator.currentPageIndicatorTintColor = UIColor.white
        pageIndicator.pageIndicatorTintColor = UIColor.lightGray
        pageIndicator.layer.cornerRadius = 10.0
        pageIndicator.sizeToFit()
        imgSlideShow.pageIndicator = pageIndicator

        imgSlideShow.contentScaleMode = .scaleToFill
        imgSlideShow.slideshowInterval = 2.0
//        imgSlideShow.setImageInputs([ImageSource(image: UIImage(named: "Image1")!),
//                                     ImageSource(image: UIImage(named: "ground-1")!),
//                                     ImageSource(image: UIImage(named: "ground-2")!),
//                                     ImageSource(image: UIImage(named: "ground-4")!),ImageSource(image: UIImage(named: "ground-5")!
//                                                 )])
        
        imgSlideShow.setImageInputs([ImageSource(image: UIImage(named: "Image1")!)
                                                 ])
        
       
        viewBase.clipsToBounds = true
        viewBase.layer.cornerRadius = 35
        btnGameOn.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
        
        
        
        
        // For Loc Defoult Selection
        self.sCurrentLattitude =  0.00
        self.sCurrentLongitude = 0.00
        
        self.btnAny2.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
        self.btnAny2.layer.borderColor = UIColor(red: 42.0/255.0, green: 43.0/255.0, blue: 44.0/255.0, alpha: 1.0).cgColor
        self.btnAny2.layer.borderWidth = 0.5
        self.btnAny2.setTitleColor(.black, for: .normal)

        self.iBtnLocationType = 1
        self.viewNearMe.backgroundColor = UIColor.clear
        self.viewNearMe.layer.borderColor = UIColor.lightGray.cgColor
        self.viewNearMe.layer.borderWidth = 0.5
        self.btnNearMe.setTitleColor(.white, for: .normal)

        
        
        
        
        
        
        viewBase.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively
//        btnOutDoor.layer.borderWidth = 1
        viewSelectedDate.layer.borderWidth = 1
        viewNearMe.layer.borderWidth = 1
//        btnIndoor.layer.borderWidth = 1
//        btnOutDoor.layer.borderWidth = 1
        btnWeeklyBooking.layer.borderWidth = 1

//        btnOutDoor.layer.borderColor = UIColor.lightGray.cgColor
        viewSelectedDate.layer.borderColor = UIColor.lightGray.cgColor
        viewNearMe.layer.borderColor = UIColor.lightGray.cgColor
//        btnAny2.layer.borderColor = UIColor.lightGray.cgColor
//        btnIndoor.layer.borderColor = UIColor.lightGray.cgColor
        
        self.viewNearMe.backgroundColor = UIColor.clear
        self.viewNearMe.layer.borderColor = UIColor.lightGray.cgColor
        self.viewNearMe.layer.borderWidth = 0.5
        self.btnNearMe.setTitleColor(.white, for: .normal)
        
        
        btnWeeklyBooking.layer.borderColor = UIColor.lightGray.cgColor
//        txtSelectedDate.attributedPlaceholder = NSAttributedString(string: "Select Date ",
//                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
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
        
        if #available(iOS 13.4, *) {
            datePickerViewForDemo.preferredDatePickerStyle = .wheels
        }

        datePickerViewForDemo.addTarget(self, action: #selector(self.datePickerDemoFromValueChanged), for: UIControl.Event.valueChanged)
        
        datePickerViewForDemo.minimumDate = NSDate() as Date

        txtSelectedDate.attributedPlaceholder = NSAttributedString(string: " Select Date",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])

      
        
        btnHome.setImage(UIImage(named: "GroupG"), for: .normal)
        self.lblHome.textColor = self.hexStringToUIColor(hex: "#6fc13a")
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        self.sCurrentLattitude = location.coordinate.latitude
        self.sCurrentLongitude = location.coordinate.longitude
        AF.request("http://api.openweathermap.org/data/2.5/weather?lat=\(self.sCurrentLattitude)&lon=\(self.sCurrentLongitude)&appid=\(self.TempAPIKey)&units=metric").responseJSON { (data) in
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
                    let jsonResponse = JSON(data.data!)
                    let jsonWeather = jsonResponse["weather"].array![0]
                    let jsonTemp = jsonResponse["main"]
//                    let iconName = jsonWeather["icon"].stringValue
//                    self.locationLabel.text = jsonResponse["name"].stringValue
//                    self.conditionImageView.image = UIImage(named: iconName)
//                    self.conditionLabel.text = jsonWeather["main"].stringValue
                    self.lbltemp.text = "\(Int(round(jsonTemp["temp"].doubleValue)))"
                   
                    self.lblTemperatureWithHumidity.text = "Temperature with \(Int(round(jsonTemp["humidity"].doubleValue))) % humidity"
                    self.view.activityStopAnimating()
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }

//
//            if let responseStr = response.result.value {
//                let jsonResponse = JSON(responseStr)
//                let jsonWeather = jsonResponse["weather"].array![0]
//                let jsonTemp = jsonResponse["main"]
//                let iconName = jsonWeather["icon"].stringValue
//
//                self.locationLabel.text = jsonResponse["name"].stringValue
//                self.conditionImageView.image = UIImage(named: iconName)
//                self.conditionLabel.text = jsonWeather["main"].stringValue
//                self.lblHome.text = "\(Int(round(jsonTemp["temp"].doubleValue)))"
//
//                let date = Date()
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "EEEE"
//
//                let suffix = iconName.suffix(1)
//                if(suffix == "n"){
//                    self.setGreyGradientBackground()
//                }else{
//                    self.setBlueGradientBackground()
//                }
//            }
//        }
        self.locationManager.stopUpdatingLocation()
    }
    
    
    
    
    
    
    func GetWhetherAPI()
    {
        let APIUrl = NSURL(string:"https://api.openweathermap.org/data/2.5/weather?lat=\(self.sCurrentLattitude)&lon=\(self.sCurrentLongitude)&appid=\(self.TempAPIKey)&units=Metric")
        var request = URLRequest(url:APIUrl! as URL)
        request.httpMethod = "GET"

        let dataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in

            if (error != nil) {
                print(error ?? "Error is empty.")
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse ?? "HTTP response is empty.")
            }

            guard data != nil else {
                print("Error: did not receive data")
                return
            }

            do {

//                let weatherData = try JSONDecoder().decode(MyWeather.self, from: responseData)
//                let ggtemp = weatherData.main?.temp
//                print(ggtemp, "THIS IS THE TEMP")
////                DispatchQueue.main.async {
////
////                }
//
//                self.lblHome.text = String (ggtemp) + " c"


            } catch  {
                print("error parsing response from POST on /todos")
                return
            }

        })

        dataTask.resume()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        self.datePickerViewForDemo.setDate(Date(), animated: true)

//        let next = self.storyboard?.instantiateViewController(withIdentifier: "PItchListViewController") as! PItchListViewController
//        self.navigationController?.pushViewController(next, animated: false)
        textField.resignFirstResponder()

    }
    
    
    
    
    
    // MARK: keyboard notification
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
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
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        var countVar:Int = 0

        
        if collectionView == collectioType {
            countVar =  self.pitch_types.count
        }
        return countVar
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if collectionView == collectioType
        {
            
            
            
            
            let homeTypeCollectionViewCell = collectioType.dequeueReusableCell(withReuseIdentifier: "HomeTypeCollectionViewCell", for: indexPath as IndexPath) as! HomeTypeCollectionViewCell
            
            homeTypeCollectionViewCell.btnAny.layer.cornerRadius = 20.0
            homeTypeCollectionViewCell.btnAny.tag = self.pitch_types[indexPath.row].id!
            homeTypeCollectionViewCell.btnAny.addTarget(self, action: #selector(masterAction3(_:)), for: .touchUpInside)

           
            homeTypeCollectionViewCell.btnAny.setTitle(self.pitch_types[indexPath.row].type_name, for: .normal)
            homeTypeCollectionViewCell.btnAny.setTitleColor(.white, for: .normal)
                           homeTypeCollectionViewCell.btnAny.backgroundColor = UIColor.clear
                           homeTypeCollectionViewCell.btnAny.layer.borderColor = UIColor.lightGray.cgColor
                           homeTypeCollectionViewCell.btnAny.layer.borderWidth = 0.5
                           homeTypeCollectionViewCell.btnAny.titleLabel?.font = UIFont(name: "TTOctosquares-Medium", size: 16)
            if String(indexPath.row) == self.sSelectedType
            {
                homeTypeCollectionViewCell.btnAny.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
                homeTypeCollectionViewCell.btnAny.setTitleColor(.black, for: .normal)
                self.sSelectedTypeName = "All Pitches"


            }
//            else if indexPath.row == 1
//            {
//                homeTypeCollectionViewCell.btnAny.setTitle("Indoor", for: .normal)
//                homeTypeCollectionViewCell.btnAny.backgroundColor = UIColor.clear
//                homeTypeCollectionViewCell.btnAny.layer.borderColor = UIColor.lightGray.cgColor
//                homeTypeCollectionViewCell.btnAny.layer.borderWidth = 0.5
//                homeTypeCollectionViewCell.btnAny.setTitleColor(.white, for: .normal)
//                homeTypeCollectionViewCell.btnAny.titleLabel?.font = UIFont(name: "Verdana", size: 16)
//
//            }
//            else
//            {
//                homeTypeCollectionViewCell.btnAny.backgroundColor = UIColor.clear
//                homeTypeCollectionViewCell.btnAny.setTitle("Outdoor", for: .normal)
//                homeTypeCollectionViewCell.btnAny.layer.borderColor = UIColor.lightGray.cgColor
//                homeTypeCollectionViewCell.btnAny.layer.borderWidth = 0.5
//                homeTypeCollectionViewCell.btnAny.setTitleColor(.white, for: .normal)
//                homeTypeCollectionViewCell.btnAny.titleLabel?.font = UIFont(name: "Verdana", size: 16)
//
//            }
//

            cell = homeTypeCollectionViewCell

 
            }

        
        
        
        return cell
    }
    
    func btnTapped(btn:UIButton, indexPath:IndexPath) {
        print("Selected Cell IndexPath : \(indexPath.row)")
        
        let cell = collectioType.cellForItem(at: indexPath) as!HomeTypeCollectionViewCell

    }
 
    @objc func masterAction3(_ sender: UIButton)
    {
        

        for index in 0..<self.pitch_types.count  {
            
            
            
            
            if index == sender.tag
            {
                let index = IndexPath(row: index, section: 0)
                print("Selected Cell  equel :",index)
                let cell: HomeTypeCollectionViewCell = self.collectioType.cellForItem(at: index) as! HomeTypeCollectionViewCell
                cell.btnAny.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
                self.sSelectedType = String(sender.tag)
                cell.btnAny.setTitleColor(.black, for: .normal)
                self.sSelectedTypeName = (cell.btnAny.titleLabel?.text)!
                
                if self.sSelectedTypeName == "Any"
                {
                    self.sSelectedTypeName = "Any"

                }

            }
            else
            {
                 let index = IndexPath(row: index, section: 0)
                    print("Selected Cell Not equel :::::",index)

                    let cell: HomeTypeCollectionViewCell = self.collectioType.cellForItem(at: index) as! HomeTypeCollectionViewCell
                    cell.btnAny.backgroundColor = UIColor.clear
                    cell.btnAny.setTitleColor(.white, for: .normal)




            }

        }
        print(sender.tag)
//        for indexs in 0..<self.pitch_types.count
//        {
//
//         print(indexs)
            
//            if indexs == sender.tag
//            {
//                let index = IndexPath(row: sender.tag, section: 0)
//                let cell: HomeTypeCollectionViewCell = self.collectioType.cellForItem(at: index) as! HomeTypeCollectionViewCell
//                cell.btnAny.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
//                cell.btnAny.setTitleColor(.black, for: .normal)
//            }
//           else
//            {
//                let index = IndexPath(row: indexs, section: 0)
//                let cell: HomeTypeCollectionViewCell = self.collectioType.cellForItem(at: index) as! HomeTypeCollectionViewCell
//                cell.btnAny.backgroundColor = UIColor.clear
//                cell.btnAny.setTitleColor(.white, for: .normal)
//            }

//        }
        
       
//        collectioType.reloadData()


        }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
     
            
     
    }
    
    @IBAction func ActionCollectionAny(_ sender: UIButton)
    {
    
    }
    
    
    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        var val = view.bounds.width/2.0
//        val = val.rounded()
//        print("Val")
//        print(val)
//        return CGSize(width: 100, height: 100)
//    }
//
//
    
    
    
    // MARK: - UICollectionViewDelegate protocol
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
//    {
//        return 15
//    }
    
    @IBAction func ActionButtonType(_ sender: UIButton)
    {

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if indexPath.row == 0
        {
            return CGSize(width: 100, height: 50)

        }
        else
        {
            return CGSize(width: 115, height: 50)

        }
//
//        return CGSize(width: 100, height: 50)

    }
    
    @IBAction func ActionLocation(_ sender: UIButton) {
        
        if sender.tag == 1
        {
            self.sCurrentLattitude =  0.00
            self.sCurrentLongitude = 0.00
            
            self.btnAny2.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
            self.btnAny2.layer.borderColor = UIColor(red: 42.0/255.0, green: 43.0/255.0, blue: 44.0/255.0, alpha: 1.0).cgColor
            self.btnAny2.layer.borderWidth = 0.5
            self.btnAny2.setTitleColor(.black, for: .normal)

            self.iBtnLocationType = 1
            self.viewNearMe.backgroundColor = UIColor.clear
            self.viewNearMe.layer.borderColor = UIColor.lightGray.cgColor
            self.viewNearMe.layer.borderWidth = 0.5
            self.btnNearMe.setTitleColor(.white, for: .normal)

        }
        else if sender.tag == 2
        {
            if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
                        CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
                        guard let currentLocation = locManager.location else {
                            return
                        }
                        print(currentLocation.coordinate.latitude)
                self.sCurrentLattitude = currentLocation.coordinate.latitude
                self.sCurrentLongitude = currentLocation.coordinate.longitude
                        print(currentLocation.coordinate.longitude)
                    }
            
            self.iBtnLocationType = 2
            self.viewNearMe.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
            self.viewNearMe.layer.borderColor = UIColor(red: 42.0/255.0, green: 43.0/255.0, blue: 44.0/255.0, alpha: 1.0).cgColor
            self.viewNearMe.layer.borderWidth = 0.5
            self.btnNearMe.setTitleColor(.black, for: .normal)


            self.btnAny2.backgroundColor = UIColor.clear
            self.btnAny2.layer.borderColor = UIColor.lightGray.cgColor
            self.btnAny2.layer.borderWidth = 0.5
            self.btnAny2.setTitleColor(.white, for: .normal)
            
            
            let next = self.storyboard?.instantiateViewController(withIdentifier: "CurrentMapViewController") as! CurrentMapViewController
            self.navigationController?.pushViewController(next, animated: true)
        }
        
    }
    
    
    func getHomeContent(){
        self.view.activityStartAnimating()
        var postDict = Dictionary<String,String>()
        

       
        postDict = [
            "access_token":""

        ]
        print(postDict)
        let loginURL = Constants.baseURL+Constants.homeURL
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
                    self.homeResponseModel = HomeResponseModel(response)
                    let statusCode = Int((self.homeResponseModel?.httpcode)!)
                    if statusCode == 200
                    {
                        self.view.activityStopAnimating()

//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
//                        {
                            self.view.activityStopAnimating()
                        DispatchQueue.main.async {
                        self.pitch_types = (self.homeResponseModel?.homedata?.pitch_types)!
                        print("Pitch Count :",self.pitch_types.count)
                        
                        if self.pitch_types.count > 0
                        {
                            
                            self.collectioType.delegate = self
                            self.collectioType.dataSource = self
                            
                           
                            self.collectioType.reloadData()
                            
                        }
                        }

                    }
                    if statusCode == 400{
                        self.view.activityStopAnimating()
//                        self.showToast(message: (self.homeResponseModel?.message)!)
                        self.presentWindow?.makeToast(message: (self.homeResponseModel?.message)!, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                    }
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
    
}
extension Date {

 static func getCurrentDate() -> String {

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd"

        return dateFormatter.string(from: Date())

    }
}
