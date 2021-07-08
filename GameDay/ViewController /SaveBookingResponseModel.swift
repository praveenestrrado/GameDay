//
//  SaveBookingResponseModel.swift
//  GameDay
//
//  Created by MAC on 13/04/21.
//

import Foundation
import SwiftyJSON

class SaveBookingResponseModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let paymentinfo: Paymentinfo?
    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        
        paymentinfo = Paymentinfo(json["data"])

            }

}



class PaymentinfoData {

    let booking_id: Int?
    let pitch_id: Int?
    let pitch_name: String?
    let pitch_location: String?
    let amount: String?
    let code: String?
    let discount_type: String?
    let discount_value: String?
    let booking_amount: String?
    let coupon_discount: String?
    let total_booking_amount: String?

    
    
    
    init(_ json: JSON) {
        booking_id = json["booking_id"].intValue
        pitch_id = json["pitch_id"].intValue
        pitch_name = json["pitch_name"].stringValue
        pitch_location = json["pitch_location"].stringValue
        amount = json["amount"].stringValue
        code = json["code"].stringValue
        discount_type = json["discount_type"].stringValue
        discount_value = json["discount_value"].stringValue

        booking_amount = json["booking_amount"].stringValue
        coupon_discount = json["coupon_discount"].stringValue
        
        total_booking_amount = json["total_booking_amount"].stringValue

            }

}
class Paymentinfo {
    
    let paymentinfoData: PaymentinfoData?
    let saved_cards: [Saved_cards]?



    init(_ json: JSON) {
       
        paymentinfoData = PaymentinfoData(json["paymentinfo"])
        saved_cards = json["saved_cards"].arrayValue.map { Saved_cards($0) }


      


            }

}


class Saved_cards {

    let id: Int?
      let size_name: String?
    let size: String?


      init(_ json: JSON) {
          id = json["id"].intValue
        size_name = json["size_name"].stringValue
        size = json["size"].stringValue

          
      }

}
