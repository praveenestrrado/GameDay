//
//  HomeResponseModel.swift
//  GameDay
//
//  Created by MAC on 08/03/21.
//

import Foundation
import SwiftyJSON

class HomeResponseModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let homedata: HomeData?
    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        
        homedata = HomeData(json["data"])

            }

}
class HomeData
{
    
    let user_details: User_details?
    let pitch_types: [Pitch_types]?

    
    init(_ json: JSON) {
        
        pitch_types = json["pitch_types"].arrayValue.map { Pitch_types($0) }
        user_details = User_details(json["user_details"])

    }
    
}
class Pitch_types {

    let id: Int?
    let type_name: String?

    init(_ json: JSON) {
        id = json["id"].intValue
        type_name = json["type_name"].stringValue
    }

}
class User_details {

  let user_id: Int?
    let fname: String?
    let lname: String?
    let email: String?
    let Isd_code: String?
    let phone: String?
    let location: String?
    let state: String?
    let country: String?
    let notify: String?
    let push_notify: String?

    init(_ json: JSON) {
        user_id = json["user_id"].intValue
        fname = json["fname"].stringValue
        lname = json["lname"].stringValue
        email = json["email"].stringValue
        Isd_code = json["Isd_code"].stringValue
        phone = json["phone"].stringValue
        location = json["location"].stringValue
        state = json["state"].stringValue
        country = json["country"].stringValue
        notify = json["notify"].stringValue
        push_notify = json["push_notify"].stringValue

    }

}
