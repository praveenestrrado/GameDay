//
//  FilterResponseModel.swift
//  GameDay
//
//  Created by MAC on 11/03/21.
//

import Foundation
import SwiftyJSON

class FilterResponseModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let filterData: FilterData?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        filterData = FilterData(json["data"])
    }

}
class FilterData
{
    let filter_datas: filter_data?
    let filter_masters: filter_master?

    let user_details: User_details?
    let pitch_list: [Pitch_list]?

    
    init(_ json: JSON) {
        
        pitch_list = json["pitch_list"].arrayValue.map { Pitch_list($0) }
        user_details = User_details(json["user_details"])
        filter_datas = filter_data(json["filter_data"])
        filter_masters = filter_master(json["filter_master"])

    }
    
}
class filter_data {

  let access_token: String?
    let book_type: Int?
    let date: String?
    let latitude: String?
    let longitude: String?
    let offset: Int?
    let pitch_type: String?
    let weeks: Int?
    

    init(_ json: JSON) {
        book_type = json["book_type"].intValue
        access_token = json["access_token"].stringValue
        date = json["date"].stringValue
        latitude = json["latitude"].stringValue
        longitude = json["longitude"].stringValue
        offset = json["offset"].intValue
        pitch_type = json["pitch_type"].stringValue
        weeks = json["weeks"].intValue
      


    }

}

class filter_master {

    let durations: [Durations]?

    let pitch_sizes: [Pitch_sizes]?
    let pitch_turfs: [Pitch_turfs]?
    let pitch_types: [Pitch_typess]?
    let max_price: Int?
    let min_price: Int?


    init(_ json: JSON) {
        durations = json["durations"].arrayValue.map { Durations($0) }
        pitch_sizes = json["pitch_sizes"].arrayValue.map { Pitch_sizes($0) }
        pitch_turfs = json["pitch_turfs"].arrayValue.map { Pitch_turfs($0) }
        pitch_types = json["pitch_types"].arrayValue.map { Pitch_typess($0) }
        max_price = json["max_price"].intValue
        min_price = json["min_price"].intValue



    }

}
class Durations {

    var id: Int?
    var duration: String?

    init(_ json: JSON) {
        id = json["id"].intValue
        duration = json["duration"].stringValue
    }

}
class Pitch_sizes {
    
    var id: Int?
    var size_name: String?

    init(_ json: JSON) {
        id = json["id"].intValue
        size_name = json["size_name"].stringValue
    }

}
class Pitch_turfs {
    
    var id: Int?
    var turf_name: String?

    init(_ json: JSON) {
        id = json["id"].intValue
        turf_name = json["turf_name"].stringValue
    }

}
class Pitch_typess {
    
    var id: Int?
    var type_name: String?

    init(_ json: JSON) {
        id = json["id"].intValue
        type_name = json["type_name"].stringValue
    }

}
class Pitch_list {

  let pitch_id: Int?
    let pitch_name: String?
    let pitch_type: String?
    let pitch_turf: String?
    let pitch_size: String?
    let rate: String?
    let currency: String?
    let rate_unit: String?
    let discount: String?
    let discount_type: String?
    let location: String?
    let latitude: String?
    let longitude: String?
    let booking_type: Int?

    let favorite_status: String?

    let Iimage_list: [image_list]?

    init(_ json: JSON) {
        pitch_id = json["pitch_id"].intValue
        pitch_name = json["pitch_name"].stringValue
        pitch_type = json["pitch_type"].stringValue
        pitch_turf = json["pitch_turf"].stringValue
        pitch_size = json["pitch_size"].stringValue
        rate = json["rate"].stringValue
        currency = json["currency"].stringValue
        rate_unit = json["rate_unit"].stringValue
        discount = json["discount"].stringValue
        discount_type = json["discount_type"].stringValue
        location = json["location"].stringValue
        latitude = json["latitude"].stringValue
        longitude = json["longitude"].stringValue
        favorite_status = json["favorite_status"].stringValue
        booking_type = json["booking_type"].intValue

        Iimage_list = json["image_list"].arrayValue.map { image_list($0) }


    }

}
class image_list {

    let id: String?
    let link: String?
   

    init(_ json: JSON) {
        id = json["id"].stringValue
        link = json["link"].stringValue
    }

}
