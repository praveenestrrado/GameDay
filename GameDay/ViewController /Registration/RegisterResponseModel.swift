//
//  RegisterResponseModel.swift
//  GameDay
//
//  Created by MAC on 09/03/21.
//

import Foundation
import SwiftyJSON

class RegistrationResponseModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let registrationData: RegistrationData?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        registrationData = RegistrationData(json["data"])
    }

}
class RegistrationData {

    let message: String?
   

    init(_ json: JSON) {
        message = json["message"].stringValue
       
    }

}
