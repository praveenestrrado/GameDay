//
//  MyBookingListResponseModel.swift
//  GameDay
//
//  Created by MAC on 17/03/21.
//

import Foundation
import SwiftyJSON
class MyBookingListResponseModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let booking_list_arrays: booking_list_array?
    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        
        booking_list_arrays = booking_list_array(json["data"])

            }

}






class booking_list_array
{
    let booking_listdata : [booking_list]?
    init(_ json: JSON)
    {
        booking_listdata = json["booking_list"].arrayValue.map { booking_list($0) }

    }
}

class booking_list
{
    let book_id: Int?
    let book_type: String?
    let pitch_id: Int?
    let location: String?
    let date: String?
    let duration: Int?
    let start_time: String?
    let end_time: String?

    let pitchdatadata: pitchdata?

    
    init(_ json: JSON) {
        
        book_type = json["book_type"].stringValue
        book_id = json["book_id"].intValue
        pitch_id = json["pitch_id"].intValue
        location = json["location"].stringValue
        date = json["date"].stringValue
        start_time = json["start_time"].stringValue
        end_time = json["end_time"].stringValue
        duration = json["duration"].intValue

        pitchdatadata = pitchdata(json["pitchdata"])

    }
    
}
class pitchdata {

  let pitch_id: Int?
    let pitch_name: String?
    let pitch_type: String?
    let pitch_turf: String?
    let pitch_size: String?
    let rate: Int?
    let currency: String?
    let rate_unit: String?
    let discount_type: Int?
    let location: String?
    let latitude: String?
    let longitude: String?
    let favorite_status: Int?
    let image_list: [image_listModel]?

    init(_ json: JSON) {
        pitch_id = json["pitch_id"].intValue
        pitch_name = json["pitch_name"].stringValue
        pitch_type = json["pitch_type"].stringValue
        pitch_turf = json["pitch_turf"].stringValue
        pitch_size = json["pitch_size"].stringValue
        rate = json["rate"].intValue
        currency = json["currency"].stringValue
        rate_unit = json["rate_unit"].stringValue
        discount_type = json["discount_type"].intValue
        location = json["location"].stringValue
        latitude = json["latitude"].stringValue
        longitude = json["longitude"].stringValue
        favorite_status = json["favorite_status"].intValue
        image_list = json["image_list"].arrayValue.map { image_listModel($0) }

    }

}
class image_listModel {

    let id: String?
    let link: String?

    init(_ json: JSON) {
        id = json["id"].stringValue
        link = json["link"].stringValue
    }

}




class BookingDetailsResponseModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let booking_list_arrays: booking_list_Data?
    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        
        booking_list_arrays = booking_list_Data(json["data"])

            }

}






class booking_list_Data
{
    let booking_listdata : bookingDetails_list?
    init(_ json: JSON)
    {
        booking_listdata = bookingDetails_list(json["booking_list"])

    }
}

class bookingDetails_list
{
    let book_id: Int?
    let book_type: String?
    let pitch_id: Int?
    let location: String?
    let date: String?
    let duration: Int?
    let start_time: String?
    let end_time: String?
    let Weeks: Int?

    let pitchdatadata: Bookingpitchdata?

    
    init(_ json: JSON) {
        book_id = json["book_id"].intValue
        book_type = json["book_type"].stringValue
        pitch_id = json["pitch_id"].intValue
        location = json["location"].stringValue
        date = json["date"].stringValue
        start_time = json["start_time"].stringValue
        end_time = json["end_time"].stringValue
        duration = json["duration"].intValue

        pitchdatadata = Bookingpitchdata(json["pitchdata"])
        Weeks = json["weeks"].intValue

    }
    
}
class Bookingpitchdata {

  let pitch_id: Int?
    let pitch_name: String?
    let pitch_type: String?
    let pitch_turf: String?
    let pitch_size: String?
    let rate: Int?
    let discount: Int?

    let currency: String?
    let rate_unit: String?
    let discount_type: String?
    let location: String?
    let latitude: String?
    let longitude: String?
    let favorite_status: Int?
    let image_list: [Bookingimage_list]?

    init(_ json: JSON) {
        pitch_id = json["pitch_id"].intValue
        pitch_name = json["pitch_name"].stringValue
        pitch_type = json["pitch_type"].stringValue
        pitch_turf = json["pitch_turf"].stringValue
        pitch_size = json["pitch_size"].stringValue
        rate = json["rate"].intValue
        discount = json["discount"].intValue

        currency = json["currency"].stringValue
        rate_unit = json["rate_unit"].stringValue
        discount_type = json["discount_type"].stringValue
        location = json["location"].stringValue
        latitude = json["latitude"].stringValue
        longitude = json["longitude"].stringValue
        favorite_status = json["favorite_status"].intValue
        image_list = json["image_list"].arrayValue.map { Bookingimage_list($0) }

    }

}
class Bookingimage_list {

    let id: String?
    let link: String?

    init(_ json: JSON) {
        id = json["id"].stringValue
        link = json["link"].stringValue
    }

}
