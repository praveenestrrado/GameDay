//
//  BookingConformationViewController.swift
//  GameDay
//
//  Created by MAC on 15/01/21.
//

import UIKit

class BookingConformationViewController: UIViewController {

    @IBOutlet var lblBookingpitchNameAndLocation: UILabel!
    
    @IBOutlet var lblUSerName: UILabel!
    @IBOutlet var lblbookingTimeAndDate: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblPitchName: UILabel!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet weak var btnLetsDoIt: UIButton!
    @IBOutlet weak var lblPichName: UILabel!
    @IBOutlet weak var btnShareLocation: UIButton!
    @IBOutlet weak var lblPichBookingDate: UILabel!
    @IBOutlet weak var lblHeading1: UILabel!
    
    @IBOutlet var lblIngfoooo: UILabel!
    @IBOutlet weak var lblHeadingggg: UILabel!
    
    var sPitchName:String?
    var sPitchAddress:String?
    var sStartTime:String?
    var sEndTime:String?
    var sBookingDate:String?
    let sharedData = SharedDefault()

    
    let mainString = "No fun to play alone so invite your crew to join your game!"
    let stringToColor = "invite"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.btnLetsDoIt.layer.borderColor = UIColor.white.cgColor
        self.btnLetsDoIt.layer.borderWidth = 0.5
        
        var sStartTimeGetted:String?
        
        if self.sStartTime?.count ?? 0 > 6
        {
             sStartTimeGetted = self.timeConversion12AMPM2(time24: self.sStartTime!)

        }
        else
        {
            sStartTimeGetted = self.timeConversion12AMPM(time24: self.sStartTime!)

        }
        
        self.lblUSerName.text = self.sharedData.getfname() + " " + self.sharedData.getlname()
       
        self.lblPitchName.text = "Your booking at  " + self.sPitchName! + ","
        self.lblTime.text = "at " + sStartTimeGetted! + " is confirmed"
        
        self.lblUSerName.text = "Awesome " + self.sharedData.getfname()
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd"

        let date: NSDate? = dateFormatterGet.date(from: self.sBookingDate!) as NSDate?
        
        
        if  date == nil
        {
            self.lblLocation.text = self.sPitchAddress! + " On " + self.sBookingDate!
            self.lblbookingTimeAndDate.text = self.sBookingDate! + ", " + sStartTimeGetted! + " at"


        }
        else
        {
        self.lblLocation.text = self.sPitchAddress! + " On " + dateFormatterPrint.string(from: date! as Date)

        
        self.lblbookingTimeAndDate.text = dateFormatterPrint.string(from: date! as Date) + ", " + sStartTimeGetted! + " at"
        }
        self.lblBookingpitchNameAndLocation.text = self.sPitchName! + ", " + self.sPitchAddress!
        var range = (mainString as NSString).range(of: stringToColor)

        let attributedString = NSMutableAttributedString(string:mainString)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white , range: range)

         self.lblHeadingggg.attributedText = attributedString
        
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
    func timeConversion12AMPM2(time24: String) -> String {
        let dateAsString = time24
        let df = DateFormatter()
        df.dateFormat = "HH:mm:ss"

        let date = df.date(from: dateAsString)
        df.dateFormat = "hh a"

        let time12 = df.string(from: date!)
        print(time12)
        return time12
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func BookAnotheGame(_ sender: Any) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(next, animated: false)
    }
    
    @IBAction func ACtionDoIt(_ sender: Any)
    {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "ContentShareViewController") as! ContentShareViewController
        next.sPitchAddress = self.sPitchAddress
        next.sStartTime = self.sStartTime
        next.sEndTime = self.sEndTime
        next.sBookingDate = self.sBookingDate
        next.sPitchName = self.sPitchName
        self.navigationController?.pushViewController(next, animated: false)
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
