//
//  LoginRegisterPopUpViewController.swift
//  GameDay
//
//  Created by MAC on 04/01/21.
//

import UIKit

class LoginRegisterPopUpViewController: UIViewController {

    var presentWindow : UIWindow?

    @IBOutlet weak var lbldata: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnRegistration: UIButton!
    @IBOutlet weak var imgBackGround: UIImageView!
    @IBOutlet weak var viewBase: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnLogin.layer.borderColor = UIColor.white.cgColor
        btnLogin.layer.borderWidth = 0.5
        // Do any additional setup after loading the view.
        viewBase.clipsToBounds = true
        viewBase.layer.cornerRadius = 20
        viewBase.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively
        presentWindow = UIApplication.shared.keyWindow
        UIView.hr_setToastThemeColor(color: UIColor.white)
        UIView.hr_setToastFontColor(color: self.hexStringToUIColor(hex: "#6fc13a"))
        UIView.hr_setToastFontName(fontName: "TTOctosquares-Medium")
            }
    
    @IBAction func ActionRegister(_ sender: Any)
    {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "RegisteredUserViewController") as! RegisteredUserViewController
        next.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(next, animated: false, completion: nil)
        
//        self.navigationController?.pushViewController(next, animated: false)
    }
    @IBAction func ActionLoginAsGuest(_ sender: Any)
    {
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

}
