//
//  TabBarController.swift
//  GameDay
//
//  Created by MAC on 15/12/20.
//

import UIKit
let gradientlayer = CAGradientLayer()

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.setGradientBackground(colorOne:UIColor(red: 67.0/255.0, green: 67.0/255.0, blue: 67.0/255.0, alpha: 1.0) , colorTwo: UIColor(red: 67.0/255.0, green: 67.0/255.0, blue: 67.0/255.0, alpha: 1.0))
        
        self.setGradientBackground(colorOne: UIColor.darkGray, colorTwo: UIColor.darkGray)
//        if #available(iOS 13, *) {
//            let appearance = UITabBarAppearance()
//            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//           appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//            tabBar.standardAppearance = appearance
//        } else {
//            //UITabBarItem.appearance().setTitleTextAttributes(UIColor.white, for: UIControl.State.selected)
//           UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
//           UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
//        }
////        // Do any additional setup after loading the view.
//        UITabBar.appearance().unselectedItemTintColor = UIColor.green

//        if let count = self.tabBar.items?.count {
//               for i in 0...(count-1) {
//                   let imageNameForSelectedState   = arrayOfImageNameForSelectedState[i]
//                   let imageNameForUnselectedState = arrayOfImageNameForUnselectedState[i]
//
//                   self.tabBar.items?[i].selectedImage = UIImage(named: imageNameForSelectedState)?.withRenderingMode(.alwaysOriginal)
//                   self.tabBar.items?[i].image = UIImage(named: imageNameForUnselectedState)?.withRenderingMode(.alwaysOriginal)
//               }
//           }
        
//        UITabBar.appearance().barTintColor = UIColor.clear // your color
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray

                   UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .selected)

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor)  {
        gradientlayer.frame = tabBar.bounds
        gradientlayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientlayer.locations = [0, 1]
        gradientlayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientlayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        self.tabBar.layer.insertSublayer(gradientlayer, at: 0)

    }
}
