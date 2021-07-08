//
//  ForgotPasswordResponseModel.swift
//  GameDay
//
//  Created by MAC on 19/04/21.
//

import Foundation
import SwiftyJSON

class ForgotPasswordResponseModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let forgotPassword: ForgotPassword?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        forgotPassword = ForgotPassword(json["data"])
    }

}
class ForgotPassword {

    let message: String?
   

    init(_ json: JSON) {
        message = json["message"].stringValue
       
    }

}
