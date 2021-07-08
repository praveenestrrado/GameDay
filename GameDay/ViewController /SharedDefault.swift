//
//  SharedDefault.swift
//  GameDay
//
//  Created by MAC on 08/03/21.
//

import Foundation
import UIKit

class SharedDefault: UIViewController {
   
   
    func setAppName(loginStatus:String)
    {
        UserDefaults.standard.set(loginStatus, forKey: "AppName")
        UserDefaults.standard.synchronize()
    }
    func getAppName() -> String {
        return UserDefaults.standard.string(forKey: "AppName")!
    }
    func setLanguage(language:Int)
    {
        UserDefaults.standard.set(language, forKey: "Language")
        UserDefaults.standard.synchronize()
    }
    
    func getLanguage()-> Int
    {
        return UserDefaults.standard.integer(forKey: "Language")
        
    }
    
    func setLoginStatus(loginStatus:Bool)
    {
        UserDefaults.standard.set(loginStatus, forKey: "LoginStatus")
        UserDefaults.standard.synchronize()
    }
    
    func getLoginStatus() -> Bool {
        return UserDefaults.standard.bool(forKey: "LoginStatus")
    }
    
    func setPhoneNumber(loginStatus:String)
    {
        UserDefaults.standard.set(loginStatus, forKey: "PhoneNumber")
        UserDefaults.standard.synchronize()
    }
    func getPhoneNumber()-> Any
    {
        return UserDefaults.standard.value(forKey: "PhoneNumber")!
        
    }
    
    func setAccessToken(token:String)
    {
        UserDefaults.standard.set(token, forKey: "access_token")
        UserDefaults.standard.synchronize()
    }
    func getAccessToken()-> String
    {
        return UserDefaults.standard.value(forKey: "access_token")! as! String
        
    }
    func clearAccessToken()
    {
        UserDefaults.standard.removeObject(forKey: "access_token")
        UserDefaults.standard.synchronize()
    }
    
/////////////////////////
    
    func clearFilterData()
    {
        UserDefaults.standard.removeObject(forKey: "FilterLocation")
        UserDefaults.standard.removeObject(forKey: "FilterBookingType")
        UserDefaults.standard.removeObject(forKey: "FilterBookingTypeWeeks")
        UserDefaults.standard.removeObject(forKey: "FilterBookingSelectedDate")
        UserDefaults.standard.removeObject(forKey: "FilterDurationId")
        UserDefaults.standard.removeObject(forKey: "FilterPitchTypeId")
        UserDefaults.standard.removeObject(forKey: "FilterPitchSizeId")
        UserDefaults.standard.removeObject(forKey: "FilterPitchTurfId")
        UserDefaults.standard.removeObject(forKey: "FilterStartTime")
        UserDefaults.standard.removeObject(forKey: "FilterSelectedEndTime")
        UserDefaults.standard.removeObject(forKey: "FilterStartPrize")
        UserDefaults.standard.removeObject(forKey: "FilterSelectedEndPrize")

        UserDefaults.standard.synchronize()
    }
    
    
    func setFilterLocation(token:String)
    {
        UserDefaults.standard.set(token, forKey: "FilterLocation")
        UserDefaults.standard.synchronize()
    }
    func getFilterLocation()-> String
    {
        return UserDefaults.standard.value(forKey: "FilterLocation")! as! String
        
    }
    func setFilterBookingType(token:String)
    {
        UserDefaults.standard.set(token, forKey: "FilterBookingType")
        UserDefaults.standard.synchronize()
    }
    func getFilterBookingType()-> String
    {
        return UserDefaults.standard.value(forKey: "FilterBookingType")! as! String
        
    }
    func setFilterBookingTypeWeeks(token:String)
    {
        UserDefaults.standard.set(token, forKey: "FilterBookingTypeWeeks")
        UserDefaults.standard.synchronize()
    }
    func getFilterBookingTypeWeeks()-> String
    {
        return UserDefaults.standard.value(forKey: "FilterBookingTypeWeeks")! as! String
        
    }
    func setFilterBookingSelectedDate(token:String)
    {
        UserDefaults.standard.set(token, forKey: "FilterBookingSelectedDate")
        UserDefaults.standard.synchronize()
    }
    func getFilterBookingSelectedDate()-> String
    {
        return UserDefaults.standard.value(forKey: "FilterBookingSelectedDate")! as! String
        
    }
    func setFilterDurationId(token:String)
    {
        UserDefaults.standard.set(token, forKey: "FilterDurationId")
        UserDefaults.standard.synchronize()
    }
    func getFilterDurationId()-> String
    {
        return UserDefaults.standard.value(forKey: "FilterDurationId")! as! String
        
    }
    
    func setFilterPitchTypeId(token:String)
    {
        UserDefaults.standard.set(token, forKey: "FilterPitchTypeId")
        UserDefaults.standard.synchronize()
    }
    func getFilterPitchTypeId()-> String
    {
        return UserDefaults.standard.value(forKey: "FilterPitchTypeId")! as! String
        
    }
    func setFilterPitchSizeId(token:String)
    {
        UserDefaults.standard.set(token, forKey: "FilterPitchSizeId")
        UserDefaults.standard.synchronize()
    }
    func getFilterPitchSizeId()-> String
    {
        return UserDefaults.standard.value(forKey: "FilterPitchSizeId")! as! String
        
    }
    func setFilterPitchTurfId(token:String)
    {
        UserDefaults.standard.set(token, forKey: "FilterPitchTurfId")
        UserDefaults.standard.synchronize()
    }
    func getFilterPitchTurfId()-> String
    {
        return UserDefaults.standard.value(forKey: "FilterPitchTurfId")! as! String
        
    }
    func setFilterStartTime(token:String)
    {
        UserDefaults.standard.set(token, forKey: "FilterStartTime")
        UserDefaults.standard.synchronize()
    }
    func getFilterStartTime()-> String
    {
        return UserDefaults.standard.value(forKey: "FilterStartTime")! as! String
        
    }
    func setFilterSelectedEndTime(token:String)
    {
        UserDefaults.standard.set(token, forKey: "FilterSelectedEndTime")
        UserDefaults.standard.synchronize()
    }
    func getFilterSelectedEndTime()-> String
    {
        return UserDefaults.standard.value(forKey: "FilterSelectedEndTime")! as! String
        
    }
    func setFilterStartPrize(token:String)
    {
        UserDefaults.standard.set(token, forKey: "FilterStartPrize")
        UserDefaults.standard.synchronize()
    }
    func getFilterStartPrize()-> String
    {
        return UserDefaults.standard.value(forKey: "FilterStartPrize")! as! String
        
    }
    func setFilterSelectedEndPrize(token:String)
    {
        UserDefaults.standard.set(token, forKey: "FilterSelectedEndPrize")
        UserDefaults.standard.synchronize()
    }
    func getFilterSelectedEndPrize()-> String
    {
        return UserDefaults.standard.value(forKey: "FilterSelectedEndPrize")! as! String
        
    }
    ////////////////////
    
    func setProfileImageURL(token:String)
    {
        UserDefaults.standard.set(token, forKey: "profile_image")
        UserDefaults.standard.synchronize()
    }
    func getProfileImageURL()-> String
    {
        return UserDefaults.standard.value(forKey: "profile_image")! as! String
        
    }
    
    func setProfileName(token:String)
    {
        UserDefaults.standard.set(token, forKey: "profile_name")
        UserDefaults.standard.synchronize()
    }
    func getProfileName()-> String
    {
        return UserDefaults.standard.value(forKey: "profile_name")! as! String
        
    }
    
    func setCountyCode(token:String)
    {
        UserDefaults.standard.set(token, forKey: "country_code")
        UserDefaults.standard.synchronize()
    }
    func getCountyCode()-> String
    {
        return UserDefaults.standard.value(forKey: "country_code")! as! String
        
    }
    
    func setCountyImg(token:String)
    {
        UserDefaults.standard.set(token, forKey: "country_img")
        UserDefaults.standard.synchronize()
    }
    func getCountyImg()-> String
    {
        return UserDefaults.standard.value(forKey: "country_img")! as! String
        
    }
    
    
    
    func setCountyName(token:String)
    {
        UserDefaults.standard.set(token, forKey: "country_name")
        UserDefaults.standard.synchronize()
    }
    func getCountyName()-> String
    {
        return UserDefaults.standard.value(forKey: "country_name")! as! String
        
    }
    
    func setOperatorName(token:String)
    {
        UserDefaults.standard.set(token, forKey: "operator_name")
        UserDefaults.standard.synchronize()
    }
    func getOperatorName()-> String
    {
        return UserDefaults.standard.value(forKey: "operator_name")! as! String
        
    }
    func setOperatorID(token:String)
    {
        UserDefaults.standard.set(token, forKey: "operator_id")
        UserDefaults.standard.synchronize()
    }
    func getOperatorID()-> String
    {
        return UserDefaults.standard.value(forKey: "operator_id")! as! String
        
    }
    
    func clearOperatorID()
    {
        UserDefaults.standard.removeObject(forKey: "operator_id")
        UserDefaults.standard.synchronize()
    }
    func clearOperatorName()
    {
        UserDefaults.standard.removeObject(forKey: "operator_name")
        UserDefaults.standard.synchronize()
    }
    
    
    func setZipCode(loginStatus:String)
    {
        UserDefaults.standard.set(loginStatus, forKey: "ZipCode")
        UserDefaults.standard.synchronize()
    }
    
    func getSelectedCountryNameFromMap() -> String {
        return UserDefaults.standard.string(forKey: "country_name_Map")!
    }
    
    
    func setSelectedCountryNameFromMap(loginStatus:String)
    {
        UserDefaults.standard.set(loginStatus, forKey: "country_name_Map")
        UserDefaults.standard.synchronize()
    }
    
    
    func setCity(loginStatus:String)
    {
        UserDefaults.standard.set(loginStatus, forKey: "City")
        UserDefaults.standard.synchronize()
    }
    func getCity() -> String {
        return UserDefaults.standard.string(forKey: "City")!
    }
    func getZipCode() -> String {
        return UserDefaults.standard.string(forKey: "ZipCode")!
    }
    
    func setFlatName(loginStatus:String)
    {
        UserDefaults.standard.set(loginStatus, forKey: "FlatName")
        UserDefaults.standard.synchronize()
    }
    func setRoadName(loginStatus:String)
    {
        UserDefaults.standard.set(loginStatus, forKey: "RoadName")
        UserDefaults.standard.synchronize()
    }
    func getRoadName() -> String {
        return UserDefaults.standard.string(forKey: "RoadName")!
    }
    
    func setLandMArk(loginStatus:String)
    {
        UserDefaults.standard.set(loginStatus, forKey: "LandMark")
        UserDefaults.standard.synchronize()
    }
    func getLandMark() -> String {
        return UserDefaults.standard.string(forKey: "LandMark")!
    }
    func getFlatName() -> String {
        return UserDefaults.standard.string(forKey: "FlatName")!
    }
    func setNewFcmToken(token:String)
    {
        UserDefaults.standard.set(token, forKey: "new_fcm_token")
        UserDefaults.standard.synchronize()
    }
    func getNewFcmToken()-> String
    {
        return UserDefaults.standard.value(forKey: "new_fcm_token")! as! String
        
    }
    func clearFcmToken()
       {
           UserDefaults.standard.removeObject(forKey: "fcm_token")
           UserDefaults.standard.synchronize()
       }
    func setFcmToken(token:String)
       {
           UserDefaults.standard.set(token, forKey: "fcm_token")
           UserDefaults.standard.synchronize()
       }
       func getFcmToken()-> String
       {
           return UserDefaults.standard.value(forKey: "fcm_token")! as! String
           
       }
    
    
    
    func setEmail(token:String)
       {
           UserDefaults.standard.set(token, forKey: "email")
           UserDefaults.standard.synchronize()
       }
       func getEmail()-> String
       {
           return UserDefaults.standard.value(forKey: "email")! as! String
           
       }
    
    func setfname(token:String)
       {
           UserDefaults.standard.set(token, forKey: "fname")
           UserDefaults.standard.synchronize()
       }
       func getfname()-> String
       {
           return UserDefaults.standard.value(forKey: "fname")! as! String
           
       }
    
    
    func setisd_code(token:String)
       {
           UserDefaults.standard.set(token, forKey: "isd_code")
           UserDefaults.standard.synchronize()
       }
       func getisd_code()-> String
       {
           return UserDefaults.standard.value(forKey: "email")! as! String
           
       }
    
    
    func setlname(token:String)
       {
           UserDefaults.standard.set(token, forKey: "lname")
           UserDefaults.standard.synchronize()
       }
       func getlname()-> String
       {
           return UserDefaults.standard.value(forKey: "lname")! as! String
           
       }
    
    func setlocation(token:String)
       {
           UserDefaults.standard.set(token, forKey: "location")
           UserDefaults.standard.synchronize()
       }
       func getlocation()-> String
       {
           return UserDefaults.standard.value(forKey: "location")! as! String
           
       }
    
    func setphone(token:String)
       {
           UserDefaults.standard.set(token, forKey: "phone")
           UserDefaults.standard.synchronize()
       }
       func getphone()-> String
       {
           return UserDefaults.standard.value(forKey: "phone")! as! String
           
       }
    
    func setnotify(token:String)
       {
           UserDefaults.standard.set(token, forKey: "notify")
           UserDefaults.standard.synchronize()
       }
       func getnotify()-> String
       {
           return UserDefaults.standard.value(forKey: "notify")! as! String
           
       }
    func setpush_notify(token:String)
       {
           UserDefaults.standard.set(token, forKey: "push_notify")
           UserDefaults.standard.synchronize()
       }
       func getpush_notify()-> String
       {
           return UserDefaults.standard.value(forKey: "push_notify")! as! String
           
       }
    func setstate(token:String)
       {
           UserDefaults.standard.set(token, forKey: "state")
           UserDefaults.standard.synchronize()
       }
       func getstate()-> String
       {
           return UserDefaults.standard.value(forKey: "state")! as! String
           
       }
    
    func setuser_id(token:String)
       {
           UserDefaults.standard.set(token, forKey: "user_id")
           UserDefaults.standard.synchronize()
       }
       func getuser_id()-> String
       {
           return UserDefaults.standard.value(forKey: "user_id")! as! String
           
       }
}
