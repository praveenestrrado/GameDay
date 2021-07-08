//
//  LoginResponseModel.swift
//  GameDay
//
//  Created by MAC on 10/03/21.
//

import Foundation
import SwiftyJSON

class LoginResponseModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let loginData: LoginData?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        loginData = LoginData(json["data"])
    }

}
class LoginData {

    let access_token: String?
    let users_details: user_details?
   

    init(_ json: JSON) {
        access_token = json["access_token"].stringValue
        users_details = user_details(json["user_details"])
       
    }

}
class user_details {

    let user_id: Int?
    let fname: String?
    let lname: String?
    let email: String?
    let isd_code: Int?
    let phone: Int?
    let location: String?
    let state: String?
    let country: String?
    let notify: Int?
    let push_notify: Int?


    init(_ json: JSON) {
        user_id = json["user_id"].intValue
        fname = json["fname"].stringValue
        lname = json["lname"].stringValue
        email = json["email"].stringValue
        isd_code = json["isd_code"].intValue
        phone = json["phone"].intValue
        location = json["location"].stringValue
        state = json["state"].stringValue

        country = json["country"].stringValue
        notify = json["notify"].intValue
        push_notify = json["push_notify"].intValue

    }

}
