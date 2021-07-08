//
//  FavoritesResponseMOdel.swift
//  GameDay
//
//  Created by MAC on 19/04/21.
//

import Foundation
import SwiftyJSON

class FavoritesResponseModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let favoriteslistdata: Favoriteslist?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        favoriteslistdata = Favoriteslist(json["data"])
    }

}
class Favoriteslist
{

    let favorites_list: [Favorites]?

    
    init(_ json: JSON) {
        
        favorites_list = json["favorites"].arrayValue.map { Favorites($0) }
       

    }
    
}
class Favorites {

  let id: Int?
    let pitch_id: Int?
    let pitch_name: String?
    let location: String?
    let image: String?
    let no_of_bookings: Int?
   
    

    init(_ json: JSON) {
        id = json["id"].intValue
        pitch_id = json["pitch_id"].intValue
        pitch_name = json["pitch_name"].stringValue
        location = json["location"].stringValue
        image = json["image"].stringValue
        no_of_bookings = json["no_of_bookings"].intValue
       
    }

}
