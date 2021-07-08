//
//  AppDelegate.swift
//  GameDay
//
//  Created by MAC on 14/12/20.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import GooglePlaces
import GoogleMaps
import Firebase
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let sharedData = SharedDefault()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var initialPage = UIViewController()
        FirebaseApp.configure()

        // Initialize Google sign-in
//               GIDSignIn.sharedInstance().clientID = "[OAuth_Client_ID]"
        
//        GIDSignIn.sharedInstance().clientID = "com.googleusercontent.apps.2886557903-4flgbrf21v97gr94c6vcv79fi26ipcgm"
          GIDSignIn.sharedInstance().clientID = "2886557903-4flgbrf21v97gr94c6vcv79fi26ipcgm.apps.googleusercontent.com"
          GIDSignIn.sharedInstance().delegate = self

        GMSServices.provideAPIKey("AIzaSyAlTu-Y-lCiV9vDegg0rIN58WQgEgxYAy8")
       GMSPlacesClient.provideAPIKey("AIzaSyAlTu-Y-lCiV9vDegg0rIN58WQgEgxYAy8")
        
        
//
//        GMSServices.provideAPIKey("AIzaSyB_d-yD08SD-ujHMsICMAEoyjKw5WpvKm4")
//       GMSPlacesClient.provideAPIKey("AIzaSyB_d-yD08SD-ujHMsICMAEoyjKw5WpvKm4")

        
               // If user already sign in, restore sign-in state.
               GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        
        
        
        
        
        ApplicationDelegate.shared.application(
                   application,
                   didFinishLaunchingWithOptions: launchOptions
               )
        if UserDefaults.standard.value(forKey: "access_token") == nil || UserDefaults.standard.value(forKey: "access_token") as! String == ""

        {
            self.sharedData.setAccessToken(token: "")

        }
        
       
        if UserDefaults.standard.value(forKey: "country_name") == nil || UserDefaults.standard.value(forKey: "country_name") as! String == ""

        {
            self.sharedData.setCountyName(token:"")

        }
        if UserDefaults.standard.value(forKey: "email") == nil || UserDefaults.standard.value(forKey: "email") as! String == ""

        {
            self.sharedData.setEmail(token:"")

        }
        if UserDefaults.standard.value(forKey: "fname") == nil || UserDefaults.standard.value(forKey: "fname") as! String == ""

        {
            self.sharedData.setfname(token:"")

        }
        if UserDefaults.standard.value(forKey: "isd_code") == nil || UserDefaults.standard.value(forKey: "isd_code") as! String == ""

        {
            self.sharedData.setisd_code(token:"")

        }
        if UserDefaults.standard.value(forKey: "lname") == nil || UserDefaults.standard.value(forKey: "lname") as! String == ""

        {
            self.sharedData.setlname(token:"")

        }
        if UserDefaults.standard.value(forKey: "location") == nil || UserDefaults.standard.value(forKey: "location") as! String == ""

        {
            self.sharedData.setlocation(token:"")

        }
        if UserDefaults.standard.value(forKey: "notify") == nil || UserDefaults.standard.value(forKey: "notify") as! String == ""

        {
            self.sharedData.setnotify(token:"")

        }
        
        if UserDefaults.standard.value(forKey: "phone") == nil || UserDefaults.standard.value(forKey: "phone") as! String == ""

        {
            self.sharedData.setphone(token:"")

        }
        if UserDefaults.standard.value(forKey: "push_notify") == nil || UserDefaults.standard.value(forKey: "push_notify") as! String == ""

        {
            self.sharedData.setpush_notify(token:"")

        }
        if UserDefaults.standard.value(forKey: "state") == nil || UserDefaults.standard.value(forKey: "state") as! String == ""

        {
            self.sharedData.setstate(token:"")

        }
        
        if UserDefaults.standard.value(forKey: "user_id") == nil || UserDefaults.standard.value(forKey: "user_id") as! String == ""

        {
            self.sharedData.setuser_id(token:"")

        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
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
        
        
        
        initialPage = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let navigationController = UINavigationController(rootViewController: initialPage)
        navigationController.interactivePopGestureRecognizer?.isEnabled = false

        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
//        UITabBar.appearance().unselectedItemTintColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 1)

        return true
    }
    
   
   
    
    
//
//    func application(_ app: UIApplication,
//                     open url: URL,
//                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
//        ApplicationDelegate.shared.application(
//                  app,
//                  open: url,
//                  sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//                  annotation: options[UIApplication.OpenURLOptionsKey.annotation]
//              )
//        return GIDSignIn.sharedInstance().handle(url)
//    }
//
    
    
    func application(application: UIApplication,
            openURL url: NSURL,
            sourceApplication: String?,
            annotation: AnyObject) -> Bool {
        return ApplicationDelegate.shared.application(
            application,
            open: url as URL,
                    sourceApplication: sourceApplication,
                    annotation: annotation)
        }
    
    
    
    
    
    
    // MARK: UISceneSession Lifecycle

    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!,
              didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        
        // Check for sign in error
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }

        // Post notification after user successfully sign in
        NotificationCenter.default.post(name: .signInGoogleCompleted, object: nil)
    }
}

// MARK:- Notification names
extension Notification.Name {
    
    /// Notification when user successfully sign in using Google
    static var signInGoogleCompleted: Notification.Name {
        return .init(rawValue: #function)
    }
}
