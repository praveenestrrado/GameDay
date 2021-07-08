//
//  PitchDetailsResponseModel.swift
//  GameDay
//
//  Created by MAC on 15/04/21.
//

import Foundation
import SwiftyJSON

class PitchDetailsResponseModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let pitch_detail: Pitch_detail?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        pitch_detail = Pitch_detail(json["data"])
    }

}
class Pitch_detail
{
    let pitch_detail_datas: Pitch_detail_data?
  

    
    init(_ json: JSON) {
        
        pitch_detail_datas = Pitch_detail_data(json["pitch_details"])
       

    }
    
}
class Pitch_detail_data {

  let pitch_id: Int?
    let pitch_name: String?
    let pitch_description: String?
    let location: String?
    let latitude: String?
    let longitude: String?
    let pitch_type: String?
    let pitch_size: String?
    let pitch_turf: String?
    let rate: String?
    let currency: String?
    let rate_unit: String?
    let discount: String?
    let discount_rate: String?
    let favorite_status: String?
    let singlebooking_status: String?
    let weeklybooking_status: String?
    let booking_type: Int?
    let discount_type: String?


    let weeks: Int?
    let available_durations: [Available_durations]?

    let available_timeslots: [Available_timeslots]?
    let extra_features: [Extra_features]?
    let image_list: [Image_list]?


    init(_ json: JSON) {
        pitch_id = json["pitch_id"].intValue
        pitch_name = json["pitch_name"].stringValue
        pitch_description = json["pitch_description"].stringValue
        location = json["location"].stringValue
        latitude = json["latitude"].stringValue
        longitude = json["longitude"].stringValue
        pitch_type = json["pitch_type"].stringValue
        pitch_size = json["pitch_size"].stringValue
        pitch_turf = json["pitch_turf"].stringValue
        rate = json["rate"].stringValue
        currency = json["currency"].stringValue
        rate_unit = json["rate_unit"].stringValue
        discount = json["discount"].stringValue
        discount_rate = json["discount_rate"].stringValue
        favorite_status = json["favorite_status"].stringValue
        singlebooking_status = json["singlebooking_status"].stringValue
        weeklybooking_status = json["weeklybooking_status"].stringValue
        booking_type = json["booking_type"].intValue
        discount_type = json["discount_type"].stringValue

        available_durations = json["available_durations"].arrayValue.map { Available_durations($0) }
        available_timeslots = json["available_timeslots"].arrayValue.map { Available_timeslots($0) }
        extra_features = json["extra_features"].arrayValue.map { Extra_features($0) }
        image_list = json["image_list"].arrayValue.map { Image_list($0) }

      
        weeks = json["weeks"].intValue
      


    }

}

class Available_durations {

    let id: Int?
    let duration: String?

    init(_ json: JSON) {
        id = json["id"].intValue
        duration = json["duration"].stringValue
    }

}
class Available_timeslots {
    
    let start_time: String?
    let end_time: String?
    let duration: String?

    init(_ json: JSON) {
        start_time = json["start"].stringValue
        end_time = json["end"].stringValue
        duration = json["duration"].stringValue

    }

}
class Extra_features {
    
    let id: Int?
    let name: String?
    let icon: String?

    init(_ json: JSON) {
        id = json["id"].intValue
        name = json["amenity"].stringValue
        icon = json["icon"].stringValue

    }

}
class Image_list {
    
    let id: Int?
    let link: String?

    init(_ json: JSON) {
        id = json["id"].intValue
        link = json["link"].stringValue
    }

}
