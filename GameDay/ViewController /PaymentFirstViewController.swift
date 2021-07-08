//
//  PaymentFirstViewController.swift
//  GameDay
//
//  Created by MAC on 04/01/21.
//

import UIKit
import Alamofire
import SwiftyJSON
class PaymentFirstViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate, UIGestureRecognizerDelegate {

    var presentWindow : UIWindow?

    @IBOutlet weak var tblPaymentFirst: UITableView!
    var bChecking:Bool = false
    let datePickerView:UIDatePicker = UIDatePicker()
    let datePickerViewForDemo:UIDatePicker = UIDatePicker()
    let sharedData = SharedDefault()
    var sSelectedDate:String?
    var sBookingID:String?
    var sPitchId:String?

    var iBookType:Int?
    var iNo_of_Weeks:Int?
    var iTotalAmount:Int?
    var sDuration:String?
    var sDurationId:String?
    var sPitchName:String?
    var sPitchAddress:String?
    var sStartTime:String?
    var sEndTime:String?
    var saveBookingResponseModel:SaveBookingResponseModel?
    var paymentinfo: Paymentinfo?
    var paymentinfoData: PaymentinfoData?
    var saved_cards: [Saved_cards]?

    override func viewDidLoad() {
        super.viewDidLoad()

        if self.sBookingID == nil
        {
            self.sBookingID = ""
        }
        self.tblPaymentFirst.isScrollEnabled = true
        // Disable swipe-to-pop gesture
                navigationController?.interactivePopGestureRecognizer?.delegate = self
                navigationController?.interactivePopGestureRecognizer?.isEnabled = false

                // Detect swipe gesture to load next entry
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipeNextEntry)))
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipeNextEntry)))

        presentWindow = UIApplication.shared.keyWindow
        UIView.hr_setToastThemeColor(color: UIColor.white)
        UIView.hr_setToastFontColor(color: self.hexStringToUIColor(hex: "#6fc13a"))
        UIView.hr_setToastFontName(fontName: "TTOctosquares-Medium")
        
        
        // Do any additional setup after loading the view.
       
//        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
//        numberToolbar.barStyle = .default
//        numberToolbar.items = [
//            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker)),
//            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
//            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker))]
//        numberToolbar.sizeToFit()
//
//        let indexPath = tblPaymentFirst.indexPathForSelectedRow!
//        let currentCellValue = tblPaymentFirst.cellForRow(at: indexPath)! as! PaymentFirst3TableViewCell
//
//        currentCellValue.txtExpDate.inputAccessoryView = numberToolbar
//        currentCellValue.txtExpDate.inputView = datePickerViewForDemo

//        
//        txtExpDate.inputAccessoryView = numberToolbar
        datePickerViewForDemo.datePickerMode = UIDatePicker.Mode.date
//        txtExpDate.inputView = datePickerViewForDemo
        datePickerViewForDemo.addTarget(self, action: #selector(self.datePickerDemoFromValueChanged), for: UIControl.Event.valueChanged)
//
        if #available(iOS 13.4, *) {
            datePickerViewForDemo.preferredDatePickerStyle = .wheels
        }
        datePickerViewForDemo.datePickerMode = .date;

        datePickerViewForDemo.minimumDate = NSDate() as Date
//
//        txtExpDate.attributedPlaceholder = NSAttributedString(string: " Selecte Date",
//                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
//
//        
//        self.btnVisa.layer.borderWidth = 0.5
//        self.btnVisa.layer.borderColor = UIColor.white.cgColor
//        
//        self.btnMasterCard.layer.borderWidth = 0.5
//        self.btnMasterCard.layer.borderColor = UIColor.white.cgColor
//        
//        self.btnApplePay.layer.borderWidth = 0.5
//        self.btnApplePay.layer.borderColor = UIColor.white.cgColor
//        
//        self.btnSamsungPay.layer.borderWidth = 0.5
//        self.btnSamsungPay.layer.borderColor = UIColor.white.cgColor
//        
//        txtExpDate.attributedPlaceholder = NSAttributedString(string: "Expiry Date (mm/yy)",
//                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
//        txtCardHolderName.attributedPlaceholder = NSAttributedString(string: "Card Holder Name",
//                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
//        txtCardnumber.attributedPlaceholder = NSAttributedString(string: "Card Number",
//                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
//        txtCVV.attributedPlaceholder = NSAttributedString(string: "CVV",
//                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])

        tblPaymentFirst.reloadData()
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
    @IBAction func ACtionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // MARK: keyboard notification
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.tblPaymentFirst.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.tblPaymentFirst.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.tblPaymentFirst.contentInset = contentInset
    }
    @objc func cancelPicker() {
        
        view.endEditing(true)
        
        
    }
    @objc func donePicker()
    {
        view.endEditing(true)
        let index = IndexPath(row: 2, section: 0)
        let currentCellValue: PaymentFirst3TableViewCell = self.tblPaymentFirst.cellForRow(at: index) as! PaymentFirst3TableViewCell
       
        if currentCellValue.txtExpDate.text?.count == 0
        {
            currentCellValue.txtExpDate.text = Date.getCurrentDate()
        }
    }
    @objc func datePickerDemoFromValueChanged(sender:UIDatePicker)
    {
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd" //"dd-MM-yyyy""HH:mm:ss"
        
        dateFormatter.dateFormat = "yyyy-MM-dd" //"dd-MM-yyyy""HH:mm:ss"
        
//        self.sSelectedDate = dateFormatter.string(from: sender.date)

        
        dateFormatter.dateFormat = "MM/yyyy" //"dd-MM-yyyy""HH:mm:ss"

        
        //specialDateTextField.text = dateFormatter.string(from: sender.date)
        print("Selected date ::: ",dateFormatter.string(from: sender.date))
//        txtExpDate.text = dateFormatter.string(from: sender.date)
        let index = IndexPath(row: 2, section: 0)
        let currentCellValue: PaymentFirst3TableViewCell = self.tblPaymentFirst.cellForRow(at: index) as! PaymentFirst3TableViewCell
       
        currentCellValue.txtExpDate.text = dateFormatter.string(from: sender.date)
        
        tblPaymentFirst.reloadData()
//        print(textLabelText)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
       }

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 5
       }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
       {
        if indexPath.row == 0 {
            let cell:PaymentFirst1TableViewCell = tblPaymentFirst.dequeueReusableCell(withIdentifier: "PaymentFirst1TableViewCell", for: indexPath) as! PaymentFirst1TableViewCell
            cell.lblPitchName.text = self.sPitchName
            cell.lblPitchAddress.text = self.sPitchAddress
                return cell
            }
        else if indexPath.row == 1 {
            let cell:PaymentFirst2TableViewCell = tblPaymentFirst.dequeueReusableCell(withIdentifier: "PaymentFirst2TableViewCell", for: indexPath) as! PaymentFirst2TableViewCell
            
//            cell.btnMasterCard.backgroundColor = hexStringToUIColor(hex: "#6FC13A")
//            cell.btnMasterCard.setTitleColor(.white, for: .normal)

                return cell
            }
        else if indexPath.row == 2 {
            let cell:PaymentFirst3TableViewCell = tblPaymentFirst.dequeueReusableCell(withIdentifier: "PaymentFirst3TableViewCell", for: indexPath) as! PaymentFirst3TableViewCell
               
            let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
            numberToolbar.barStyle = .default
            numberToolbar.items = [
                UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker)),
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker))]
            numberToolbar.sizeToFit()
    
    cell.txtExpDate.inputAccessoryView = numberToolbar
    cell.txtExpDate.inputView = datePickerViewForDemo

    
    cell.txtExpDate.inputAccessoryView = numberToolbar
            datePickerViewForDemo.datePickerMode = UIDatePicker.Mode.date
    cell.txtExpDate.inputView = datePickerViewForDemo
            datePickerViewForDemo.addTarget(self, action: #selector(self.datePickerDemoFromValueChanged), for: UIControl.Event.valueChanged)
    //
            datePickerViewForDemo.minimumDate = NSDate() as Date
                return cell
            }
        else if indexPath.row == 3 {
            let cell:PaymentFirst4TableViewCell = tblPaymentFirst.dequeueReusableCell(withIdentifier: "PaymentFirst4TableViewCell", for: indexPath) as! PaymentFirst4TableViewCell
               
                return cell
            }
        else {
            let cell:PaymentFirst5TableViewCell = tblPaymentFirst.dequeueReusableCell(withIdentifier: "PaymentFirst5TableViewCell", for: indexPath) as! PaymentFirst5TableViewCell
               
                return cell
            }
       }
    
    @objc func buttonPressed(sender: UIButton){
        print(sender.tag)
            let button = sender as? UIButton
            let cell = button?.superview?.superview as? PaymentFirst2TableViewCell
            let indexPath = tblPaymentFirst.indexPath(for: cell!)
        
        cell?.btnMasterCard.backgroundColor = UIColor.clear
        cell?.btnMasterCard.layer.borderColor = UIColor.lightGray.cgColor
        cell?.btnMasterCard.layer.borderWidth = 0.5
        cell?.btnMasterCard.setTitleColor(.white, for: .normal)

       


        cell?.btnVisa.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
        cell?.btnVisa.layer.borderColor = UIColor(red: 42.0/255.0, green: 43.0/255.0, blue: 44.0/255.0, alpha: 1.0).cgColor
        cell?.btnVisa.layer.borderWidth = 0.5
        cell?.btnVisa.setTitleColor(.black, for: .normal)
        tblPaymentFirst.reloadData()

            print(indexPath?.row)
        }
    @objc func buttonPressed1(sender: UIButton){
        print(sender.tag)
            let button = sender as? UIButton
            let cell = button?.superview?.superview as? PaymentFirst5TableViewCell
            let indexPath = tblPaymentFirst.indexPath(for: cell!)
            print(indexPath?.row)
       
        cell?.btnSamsungPay.backgroundColor = UIColor.clear
        cell?.btnSamsungPay.layer.borderColor = UIColor.lightGray.cgColor
        cell?.btnSamsungPay.layer.borderWidth = 0.5
        cell?.btnSamsungPay.setTitleColor(.white, for: .normal)

    

        cell?.btnApplePay.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
        cell?.btnApplePay.layer.borderColor = UIColor(red: 42.0/255.0, green: 43.0/255.0, blue: 44.0/255.0, alpha: 1.0).cgColor
        cell?.btnApplePay.layer.borderWidth = 0.5
        cell?.btnApplePay.setTitleColor(.black, for: .normal)
        
        tblPaymentFirst.reloadData()
        }
    @objc func buttonPressed2(sender: UIButton){
        print(sender.tag)
            let button = sender as? UIButton
            let cell = button?.superview?.superview as? PaymentFirst5TableViewCell
            let indexPath = tblPaymentFirst.indexPath(for: cell!)
        
       

        cell?.btnApplePay.backgroundColor = UIColor.clear
        cell?.btnApplePay.layer.borderColor = UIColor.lightGray.cgColor
        cell?.btnApplePay.layer.borderWidth = 0.5
        cell?.btnApplePay.setTitleColor(.white, for: .normal)

        cell?.btnSamsungPay.backgroundColor = UIColor.clear
        cell?.btnSamsungPay.layer.borderColor = UIColor.lightGray.cgColor
        cell?.btnSamsungPay.layer.borderWidth = 0.5
        cell?.btnSamsungPay.setTitleColor(.white, for: .normal)


     
        tblPaymentFirst.reloadData()
        
            print(indexPath?.row)
        }
    @objc func buttonPressed3(sender: UIButton){
        print(sender.tag)
            let button = sender as? UIButton
            let cell = button?.superview?.superview as? PaymentFirst2TableViewCell
            let indexPath = tblPaymentFirst.indexPath(for: cell!)
            print(indexPath?.row)
        
        cell?.btnVisa.backgroundColor = UIColor.clear
        cell?.btnVisa.layer.borderColor = UIColor.lightGray.cgColor
        cell?.btnVisa.layer.borderWidth = 0.5
        cell?.btnVisa.setTitleColor(.white, for: .normal)

      

        cell?.btnMasterCard.backgroundColor = UIColor.clear
        cell?.btnMasterCard.layer.borderColor = UIColor.lightGray.cgColor
        cell?.btnMasterCard.layer.borderWidth = 0.5
        cell?.btnMasterCard.setTitleColor(.white, for: .normal)


      
        tblPaymentFirst.reloadData()
        
        }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            var height:CGFloat = CGFloat()
            if indexPath.row == 0
            {
                height = 110
            }
            else if indexPath.row == 1
            {
                height = 85
            }
            else if indexPath.row == 2
            {
                height = 245
            }
            else if indexPath.row == 3
            {
                height = 50
                print(height)
            }
            else if indexPath.row == 4
            {
                height = 150
                print(height)
            }
            return height
        }
    
    @IBAction func ActionCheck(_ sender: Any)
    {
        let index = IndexPath(row: 3, section: 0)
        let currentCellValue: PaymentFirst4TableViewCell = self.tblPaymentFirst.cellForRow(at: index) as! PaymentFirst4TableViewCell
        
        if !bChecking
        {
            currentCellValue.btnCheckMark.setBackgroundImage(UIImage(named: "CheckMark"), for: .normal)
            bChecking = true
        }
        else
        {
            currentCellValue.btnCheckMark.setBackgroundImage(UIImage(named: "UnCheckBox"), for: .normal)
            bChecking = false
        }
        tblPaymentFirst.reloadData()

    }
    @IBAction func ActionPayNow(_ sender: Any)
    {
        

        if self.sBookingID!.count > 0
        {
            self.UpdateBookingDetails()
        }
        else if self.sBookingID?.count == 0
        {
            self.SaveBookingDetails()

        }
       
       
        
        
    }
    @IBAction func ActionDatePicker(_ sender: Any)
    {
        
    }
    
    
    @IBAction func ActionSamsungPay(_ sender: Any)
    {
        
        let index = IndexPath(row: 4, section: 0)
        let currentCellValue: PaymentFirst5TableViewCell = self.tblPaymentFirst.cellForRow(at: index) as! PaymentFirst5TableViewCell
        
        

        currentCellValue.btnApplePay.backgroundColor = UIColor.clear
        currentCellValue.btnApplePay.layer.borderColor = UIColor.lightGray.cgColor
        currentCellValue.btnApplePay.layer.borderWidth = 0.5
        currentCellValue.btnApplePay.setTitleColor(.white, for: .normal)

      

        currentCellValue.btnSamsungPay.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
        currentCellValue.btnSamsungPay.layer.borderColor = UIColor(red: 42.0/255.0, green: 43.0/255.0, blue: 44.0/255.0, alpha: 1.0).cgColor
        currentCellValue.btnSamsungPay.layer.borderWidth = 0.5
        currentCellValue.btnSamsungPay.setTitleColor(.black, for: .normal)
        tblPaymentFirst.reloadData()
        
    }
    @IBAction func ActionApplePay(_ sender: Any)
    {
        let index = IndexPath(row: 4, section: 0)
        let currentCellValue: PaymentFirst5TableViewCell = self.tblPaymentFirst.cellForRow(at: index) as! PaymentFirst5TableViewCell
        
      

        currentCellValue.btnSamsungPay.backgroundColor = UIColor.clear
        currentCellValue.btnSamsungPay.layer.borderColor = UIColor.lightGray.cgColor
        currentCellValue.btnSamsungPay.layer.borderWidth = 0.5
        currentCellValue.btnSamsungPay.setTitleColor(.white, for: .normal)



        currentCellValue.btnApplePay.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
        currentCellValue.btnApplePay.layer.borderColor = UIColor(red: 42.0/255.0, green: 43.0/255.0, blue: 44.0/255.0, alpha: 1.0).cgColor
        currentCellValue.btnApplePay.layer.borderWidth = 0.5
        currentCellValue.btnApplePay.setTitleColor(.black, for: .normal)
        
        tblPaymentFirst.reloadData()

    }
    @IBAction func ActionMasterCard(_ sender: Any)
    {
        
        let index = IndexPath(row: 1, section: 0)
        let currentCellValue: PaymentFirst2TableViewCell = self.tblPaymentFirst.cellForRow(at: index) as! PaymentFirst2TableViewCell
        
        currentCellValue.btnVisa.backgroundColor = UIColor.clear
        currentCellValue.btnVisa.layer.borderColor = UIColor.lightGray.cgColor
        currentCellValue.btnVisa.layer.borderWidth = 0.5
        currentCellValue.btnVisa.setTitleColor(.white, for: .normal)

       

        currentCellValue.btnMasterCard.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
        currentCellValue.btnMasterCard.layer.borderColor = UIColor(red: 42.0/255.0, green: 43.0/255.0, blue: 44.0/255.0, alpha: 1.0).cgColor
        currentCellValue.btnMasterCard.layer.borderWidth = 0.5
        currentCellValue.btnMasterCard.setTitleColor(.black, for: .normal)
        tblPaymentFirst.reloadData()
    }
    @IBAction func ActionCard(_ sender: Any)
    {
        
        let index = IndexPath(row: 1, section: 0)
        let currentCellValue: PaymentFirst2TableViewCell = self.tblPaymentFirst.cellForRow(at: index) as! PaymentFirst2TableViewCell
        
        currentCellValue.btnMasterCard.backgroundColor = UIColor.clear
        currentCellValue.btnMasterCard.layer.borderColor = UIColor.lightGray.cgColor
        currentCellValue.btnMasterCard.layer.borderWidth = 0.5
        currentCellValue.btnMasterCard.setTitleColor(.white, for: .normal)

       

        currentCellValue.btnVisa.backgroundColor = UIColor(red: 111.0/255.0, green: 193.0/255.0, blue: 58.0/255.0, alpha: 1.0)
        currentCellValue.btnVisa.layer.borderColor = UIColor(red: 42.0/255.0, green: 43.0/255.0, blue: 44.0/255.0, alpha: 1.0).cgColor
        currentCellValue.btnVisa.layer.borderWidth = 0.5
        currentCellValue.btnVisa.setTitleColor(.black, for: .normal)
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
    func SaveBookingDetails()
    {
     
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = ["access_token":self.sharedData.getAccessToken(),
                    "pitch_id":self.sPitchId!,
                    "date":self.sSelectedDate!,
                    "book_type":String(self.iBookType!),
                    "number_of_week":String(self.iNo_of_Weeks!),
                    "duration":self.sDurationId!,
                    "start_time":self.sStartTime!,
                    "end_time":self.sEndTime!,
                    "booking_amount":String(iTotalAmount!),
                    "total_booking_amount":String(iTotalAmount!),


        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.SaveBookingURL
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
                    self.paymentinfo = self.saveBookingResponseModel?.paymentinfo
                    self.paymentinfoData = self.paymentinfo?.paymentinfoData
                    self.saved_cards = self.paymentinfo?.saved_cards

 
//                    
                    let statusCode = self.saveBookingResponseModel?.httpcode
                    if statusCode == 200{
//                        print("registerResponseModel ----- ",self.filterResponseModel)
//                        if self.search_results!.count > 0
//                        {
//                            
//                        }
                        
                        
//                        self.showToast(message:(self.saveBookingResponseModel?.message)!)
                        self.presentWindow?.makeToast(message: "Your booking details submitted successfully", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                        let index = IndexPath(row: 4, section: 0)
                        
                        self.tblPaymentFirst.scrollToRow(at: index, at: .top, animated: false)

                        let cell1: PaymentFirst5TableViewCell = self.tblPaymentFirst.cellForRow(at: index) as! PaymentFirst5TableViewCell
                        print("Text Input Values",cell1.btnPayBow.titleLabel?.text as Any)
                        
                        cell1.btnPayBow.isEnabled = false

                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0)
                        {
                        
                        let next = self.storyboard?.instantiateViewController(withIdentifier: "BookingConformationViewController") as! BookingConformationViewController
                            next.sPitchAddress = self.sPitchAddress
                            next.sStartTime = self.sStartTime
                            next.sEndTime = self.sEndTime
                            next.sBookingDate = self.sSelectedDate
                            next.sPitchName = self.sPitchName
                        self.navigationController?.pushViewController(next, animated: false)
                        
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
    
    func UpdateBookingDetails()
    {
     
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = ["access_token":self.sharedData.getAccessToken(),
                    "book_id":self.sBookingID!,
                    "date":self.convertDateFormater(self.sSelectedDate!),
                    "start_time":self.sStartTime!,
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
                        
//                        self.showToast(message:(self.saveBookingResponseModel?.message)!)
                        self.presentWindow?.makeToast(message: (self.saveBookingResponseModel?.message)!, duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
                        {
                        let next = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                        self.navigationController?.pushViewController(next, animated: false)
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
