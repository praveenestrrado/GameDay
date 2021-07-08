//
//  SearchPitchViewController.swift
//  GameDay
//
//  Created by MAC on 22/01/21.
//

import UIKit

class SearchPitchViewController: UIViewController,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tblPitchList: UITableView!
    @IBOutlet weak var viewBase1: UIView!
    
    var sSelectedButton1 = String()
    var sSelectedButton2 = String()
    var sSelectedDate:String?
    
    var sBookingDetailsDuration:String?

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
    var sLatitude : String?
    var sLongitude : String?
    var bFromPreviusBookingList = Bool()
    var bfromUpcomingBookingList = Bool()
    var sGetedDuration = String()
    var iDurationId = String()
    var iTimeId = String()
    var sstartTime = String()
    var sendTime = String()
    var book_type : Int?

    var sGetedDurationFromBooking = String()
    var sPitch_typeFromFilter : String?
    var sPitch_typeNameFromFilter : String?
    var sGetedTime = String()

    
    
    
    
    @IBOutlet weak var txtSearch: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        txtSearch.attributedPlaceholder = NSAttributedString(string: "Outdoor Pitch Al Barsha",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        self.viewBase1.addGestureRecognizer(gesture)
    }
    @objc func checkAction(sender : UITapGestureRecognizer)
    {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "PItchListViewController") as! PItchListViewController
        
       
    next.sSelectedDate = self.sSelectedDate
        
        next.sLatitude = String(self.sLatitude!)
        next.sLongitude = String(self.sLongitude!)
    next.book_type = self.book_type
    next.bFromFilter = 2
        next.sPitch_typeNameFromFilter = sPitch_typeNameFromFilter
    next.weeks = self.iNo_of_Weeks
    next.sPitch_typeFromFilter =  self.sPitch_typeFromFilter
        next.book_type = book_type
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "PItchListViewController") as! PItchListViewController
        self.navigationController?.pushViewController(next, animated: false)
        textField.resignFirstResponder()

    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()

        let next = self.storyboard?.instantiateViewController(withIdentifier: "PItchListViewController") as! PItchListViewController
        self.navigationController?.pushViewController(next, animated: false)
        
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            var height:CGFloat = CGFloat()

        height = 345
            return height
        }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if tableView == tblPitchList {
            let settingsTCell = tblPitchList.dequeueReusableCell(withIdentifier: "SearchDummyTableViewCell", for: indexPath) as! SearchDummyTableViewCell

            settingsTCell.selectionStyle = .none
            
            cell = settingsTCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
      
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
}
