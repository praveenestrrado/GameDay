//
//  ContentShareViewController.swift
//  GameDay
//
//  Created by MAC on 07/01/21.
//

import UIKit
import MessageUI
import Alamofire
import SwiftyJSON

class ContentShareViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var btnLetsDoIt: UIButton!
    @IBOutlet weak var viewBase1: UIView!
    @IBOutlet weak var viewBase2: UIView!
    @IBOutlet weak var lblPichBookingDate: UILabel!
    @IBOutlet weak var lblPichName: UILabel!

    var iSelectedBookingId = Int()
    let sharedData = SharedDefault()
    var bookingDetailsResponseModel:BookingDetailsResponseModel?
    var booking_list_data: booking_list_Data?
    var bookingDetails_lists:bookingDetails_list?
    var bookingpitchdata: Bookingpitchdata?
    var bookingimage_list: [Bookingimage_list]?
    var sMessage:String?
    var presentWindow : UIWindow?

    var sPitchName:String?
    var sPitchAddress:String?
    var sStartTime:String?
    var sEndTime:String?
    var sBookingDate:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        viewBase2.clipsToBounds = true
//        viewBase2.layer.cornerRadius = 20
//        viewBase2.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
//        self.btnLetsDoIt.layer.borderColor = UIColor.white.cgColor
//        self.btnLetsDoIt.layer.borderWidth = 1
//        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
//        self.view.addGestureRecognizer(gesture)
//
        
        
        presentWindow = UIApplication.shared.keyWindow
        UIView.hr_setToastThemeColor(color: UIColor.white)
        UIView.hr_setToastFontColor(color: self.hexStringToUIColor(hex: "#6fc13a"))
        UIView.hr_setToastFontName(fontName: "TTOctosquares-Medium")
        
        
////        self.FetchBookingDetails()
//
//        self.lblPichBookingDate.text = self.sBookingDate! + "." +  self.timeConversion12AMPMFromBookingDetails(time24: self.sStartTime!) + " at "
//        self.lblPichName.text = self.sPitchName! + "," + self.sPitchAddress!
//      
//        sMessage = "Hey! I've booked a GameDay on " + self.lblPichBookingDate.text! + self.lblPichName.text!
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewBase2.clipsToBounds = true
        viewBase2.layer.cornerRadius = 20
        viewBase2.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.btnLetsDoIt.layer.borderColor = UIColor.white.cgColor
        self.btnLetsDoIt.layer.borderWidth = 1
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        self.view.addGestureRecognizer(gesture)
        

        self.lblPichBookingDate.text = self.sBookingDate! + "." +  self.timeConversion12AMPMFromBookingDetails(time24: self.sStartTime!) + " at "
        self.lblPichName.text = self.sPitchName! + "," + self.sPitchAddress!
      
        sMessage = "Hey! I've booked a GameDay on " + self.lblPichBookingDate.text! + self.lblPichName.text! + ". Here's your Location Map \n(bit.ly/shortlink)  Ready to get your game on ?"
        
    }
    
    
    @objc func checkAction(sender : UITapGestureRecognizer)
    {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "BookingConformationViewController") as! BookingConformationViewController
//        next.iSelectedBookingId = self.iSelectedBookingId
        next.sPitchAddress = self.sPitchAddress
        next.sStartTime = self.sStartTime
        next.sEndTime = self.sEndTime
        next.sBookingDate = self.sBookingDate
        next.sPitchName = self.sPitchName
        self.navigationController?.pushViewController(next, animated: false)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func ACtionShareOtherOption(_ sender: Any)
    {
        self.ShareTextOnOtherApps(sText: self.sMessage!)
    }
    
    @IBAction func ActionShareWhatsup(_ sender: Any) {
        
        let urlWhats = "whatsapp://send?text=\(String(describing: self.sMessage))"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
              if let whatsappURL = NSURL(string: urlString) {
                    if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                         UIApplication.shared.open(whatsappURL as URL)
                     }
                     else {
                         print("please install watsapp")
                        self.presentWindow?.makeToast(message: "Whatsapp not installed", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.

                     }
              }
        }
        
        
//        let urlString = "whatsapp://send?text=" + self.sMessage!
//        print("urlString ",urlString)
//        
//        print("urlString ",urlString)
//        
//        if let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
//            if let whatsappURL = NSURL(string: urlString)
//            {
//                if UIApplication.shared.canOpenURL(whatsappURL as URL)
//                {
//                    if #available(iOS 10.0, *)
//                    {
//                        UIApplication.shared.open(whatsappURL as URL, options: [:], completionHandler: nil)
//                    }
//                    else
//                    {
//                        UIApplication.shared.openURL(whatsappURL as URL)
//                    }
//                    
//                }
//                else
//                {
//                  print("Cannot open whatsapp")
//                    self.presentWindow?.makeToast(message: "Whatsapp not installed", duration: 2, position: HRToastPositionDefault as AnyObject)        // Do any additional setup after loading the view.
//
//                }
//            }
//        }
        
        
        
    }
    func FetchBookingDetails()
    {
     
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = ["access_token":self.sharedData.getAccessToken(),
                    "book_id":String(self.iSelectedBookingId)
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
                        
                       
                       
                        self.lblPichBookingDate.text = (self.bookingDetails_lists?.date)! + "." +  self.timeConversion12AMPMFromBookingDetails(time24: (self.bookingDetails_lists?.start_time)!)
                        self.lblPichName.text = (self.bookingpitchdata?.pitch_name)! + "," + (self.bookingpitchdata?.location)!
                      
                        self.view.activityStopAnimating()

                    }
                    if statusCode == 400{

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
    
    func timeConversion12FromBookingDetails(time24: String) -> String {
        var dateAsString = time24
        var df = DateFormatter()
        df.dateFormat = "HH:mm:ss"

        var date = df.date(from: dateAsString)
        df.dateFormat = "hh"
        if date == nil
        {
             dateAsString = time24
             df = DateFormatter()
            df.dateFormat = "HH:mm"

             date = df.date(from: dateAsString)
            df.dateFormat = "hh"

        }
        let time12 = df.string(from: date!)
        print(time12)
        return time12
    }
    func timeConversion12AMPMFromBookingDetails(time24: String) -> String {
        var dateAsString = time24
        var df = DateFormatter()
        df.dateFormat = "HH:mm:ss"

        var date = df.date(from: dateAsString)
        df.dateFormat = "HH:mm a"
        
        if date == nil
        {
             dateAsString = time24
             df = DateFormatter()
            df.dateFormat = "HH:mm"

             date = df.date(from: dateAsString)
            df.dateFormat = "hh:mm a"

        }

        let time12 = df.string(from: date!)
        print(time12)
        return time12
    }

    
    func timeConversion12(time24: String) -> String {
        let dateAsString = time24
        let df = DateFormatter()
        df.dateFormat = "HH:mm"

        let date = df.date(from: dateAsString)
        df.dateFormat = "hh"

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
    @IBAction func ActionShareGmail(_ sender: Any)
    {
              
        let mailComposeViewController = configureMailComposer()
           if MFMailComposeViewController.canSendMail(){
               self.present(mailComposeViewController, animated: true, completion: nil)
           }else{
               print("Can't send email")
           }
        
        
    }
    
    func configureMailComposer() -> MFMailComposeViewController{
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients([self.sharedData.getEmail()])
        mailComposeVC.setSubject("GameDayApp Invitation")
        mailComposeVC.setMessageBody(self.sMessage!, isHTML: false)
        return mailComposeVC
    }
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
               let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
               let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
               
               let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
               let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
               let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
               let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
               let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
               
               if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
                   return gmailUrl
               } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
                   return outlookUrl
               } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
                   return yahooMail
               } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
                   return sparkUrl
               }
               
               return defaultUrl
           }
           
    //MARK: - MFMail compose method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
  
    func ShareTextOnOtherApps(sText:String)
    {
//        let text = "https://apps.apple.com/in/app/whatsapp-messenger/id310633997"
        
        let text = self.sMessage!

        let textShare = [ text ]
            let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
//        [activityViewController.view setTintColor:[UIColor blueColor]];
        activityViewController.navigationController?.navigationBar.tintColor = UIColor.black
        activityViewController.navigationController?.navigationItem.rightBarButtonItem?.tintColor = UIColor.red

        UIButton.appearance().tintColor = .blue
//            self.present(activityViewController, animated: true, completion: nil)
        self.present(activityViewController, animated: true, completion: {
                    DispatchQueue.main.async {
                        UIButton.appearance().tintColor = .red
                    }
                })
    }
}
