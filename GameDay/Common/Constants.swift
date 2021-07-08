//
//  Constants.swift
//  GameDay
//
//  Created by MAC on 22/12/20.
//

import Foundation
import UIKit

class Constants: NSObject {
    static let connectivityErrorMsg = "Please check internet connection"
    static let appName = "Game Day"
    static let logoutMSG = "Are you sure you want to logout"
    static let removeCartMSG = "Your cart having products, do you wish to checkout?"
    static let deleteAddressMSG = "Do you want to delete the address"
    // MARK:Login Page
    static let btnTextColorWhite =  UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    static let btnBGColor =  UIColor(red: 59.0/255.0, green: 160.0/255.0, blue: 13.0/255.0, alpha: 1.0)
    static let txtfieldBGColor =  UIColor(red: 227.0/255.0, green: 243.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    static let pageTitleTextColor =  UIColor(red: 26.0/255.0, green: 98.0/255.0, blue: 164.0/255.0, alpha: 1.0)
    static let txtfieldPlaceHolderColor =  UIColor(red: 26.0/255.0, green: 98.0/255.0, blue: 164.0/255.0, alpha: 1.0)
    static let TxtPhoneEmpty = "Enter Phone Number"
    // MARK:Verify OTP Page
    static let OtpHeaderTextColor =  UIColor(red: 5.0/255.0, green: 5.0/255.0, blue: 5.0/255.0, alpha: 1.0)
    static let OtpSubTitleTextColor =  UIColor(red:117.0/255.0, green: 117.0/255.0, blue: 117.0/255.0, alpha: 1.0)
    static let optTextfieldLineColor =  UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
    static let otpEmptyMsg = "Enter OTP"
    // MARK:Home Page
    static let borderColor =  UIColor(red: 221.0/255.0, green: 221.0/255.0, blue: 221.0/255.0, alpha: 1.0)
    static let pdtNameTxtColor =  UIColor(red: 115.0/255.0, green: 115.0/255.0, blue: 115.0/255.0, alpha: 1.0)
    static let qtyTxtColor =  UIColor(red: 149.0/255.0, green: 149.0/255.0, blue: 149.0/255.0, alpha: 1.0)
    static let amtTxtColor =  UIColor(red: 86.0/255.0, green: 125.0/255.0, blue: 39.0/255.0, alpha: 1.0)
    static let categoryTxtColor =  UIColor(red: 116.0/255.0, green: 116.0/255.0, blue: 116.0/255.0, alpha: 1.0)
    
    static let placeholderColor =  UIColor(red: 116.0/255.0, green: 116.0/255.0, blue: 116.0/255.0, alpha: 1.0)
    
    // MARK:URL's
    static let baseURL = "https://estrradoweb.com/gameday/api/"// stagging
    
    static let termConditionURL = "https://vinshopify.com/home/legal/terms_conditions"
   
//    static let baseURL = "https://vinshopify.com/api/"// Live

   
    static let homeURL = "customer/home"
    static let registerURL = "customer/registration"
    static let loginURL = "customer/login"
    static let ForgetPasswordURL = "customer/forgot/password"

   static let searchPitchURL = "pitch/search"
    static let previousBookingList = "booking/previous/list"
    static let UpcomingBookingList = "booking/upcoming/list"
    static let ProfileURL = "customer/profile"
    static let UpdateProfileURL = "customer/profile/update"
     static let playPositionURL = "customer/playposition"
    static let addFavorites = "favorites/add"
    static let favorites_list = "favorites/list"
    static let favorites_list_delete = "favorites/delete"
static let SocialMediaURL = "customer/socialmedia/login"
    static let ContactURL = "contact/detail"
    static let SaveContactURL = "contact"
  static let SignOutUrl = "customer/logout"
    static let addPitchUrl = "pitch/add/request"
    static let SaveBookingURL = "booking/save"
    static let pitchDetailsURL = "pitch/detail"
    static let updateBookingURL = "booking/update"
    static let bookingDetailURL = "booking/detail"
    static let countryURL = "customer/country"
    static let stateURL = "customer/state"

    
    // MARK:Verify OTP
    static let emptyOTPMsg = "Enter OTP."
    // MARK:Validate Phone
    static let emptyPhoneMsg = "Enter phone number."
    static let phoneLengthMsg = "Mobile number must be at least 7 characters in length."
    static let phoneLengthMsg2 = "Mobile number must be 7-15 digits"

    // MARK:Register
    static let usernameEmptyMsg = "Enter name."
    static let emailEmptyMsg = "Enter emailid."
    static let emptyPWD = "Enter password."
    static let emptyCPWD = "Enter confirm password."
    static let emptyMobile = "Enter mobile number."
    static let confirmPwdMSG = "Password and confirm password should me same."
    static let invalidEmailMSG = "Enter a valid email id."
    
    // MARK:Update Profile
    static let profileNameEmptyMsg = "Enter name."
    static let profileHNameEmptyMsg = "Enter house name."
    static let profileAreaEmptyMsg = "Enter area."
    static let profilePostEmptyMsg = "Enter post."
    static let profileStateEmptyMsg = "Enter state."
    static let profileMobileEmptyMsg = "Enter mobile."
    static let profileEmailEmptyMsg = "Enter email."
    static let profileDistEmptyMsg = "Enter district."
    
    
    // MARK:Save Review

    static let saveReviewTitleEmtyMessage = "Please enter the review title."
    static let saveReviewEmtyMessage = "Please enter your review."
    static let saveRatingEmptyMessage = "Please choose your rating for this product"

}
