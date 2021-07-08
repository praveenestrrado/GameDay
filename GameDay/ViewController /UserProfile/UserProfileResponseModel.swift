//
//  UserProfileResponseModel.swift
//  GameDay
//
//  Created by MAC on 18/03/21.
//

import Foundation
import SwiftyJSON

class UserProfileResponseModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let user_details_Data_Main: User_details_Data_Main?
    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        
        user_details_Data_Main = User_details_Data_Main(json["data"])

            }

}

class User_details_Data_Main {
    
    let user_details_data: User_details_Data?
    init(_ json: JSON) {
       
        
        user_details_data = User_details_Data(json["user_details"])

            }

}
class User_details_Data {

  let profile_user_id: Int?
    let profile_fname: String?
    let profile_lname: String?
    let profile_email: String?
    let profile_Isd_code: Int?
    let profile_phone: Int?
    
    let profile_gender: String?
    let profile_dob: String?

    
    let profile_location: String?
    let profile_profile_state: String?
    let profile_country: String?
    let profile_play_position: String?

    let profile_avatar: String?
    
    let positionId: Int?
    let stateId: Int?
    let countryId: Int?

    
    let profile_favorite_pitch: String?

    init(_ json: JSON) {
        profile_user_id = json["user_id"].intValue
        profile_fname = json["fname"].stringValue
        profile_lname = json["lname"].stringValue
        profile_email = json["email"].stringValue
        profile_Isd_code = json["isd_code"].intValue
        profile_phone = json["phone"].intValue
        positionId = json["positionId"].intValue
        stateId = json["stateId"].intValue
        countryId = json["countryId"].intValue

        profile_gender = json["gender"].stringValue
        profile_dob = json["dob"].stringValue

        profile_location = json["location"].stringValue
        profile_profile_state = json["state"].stringValue
        profile_country = json["country"].stringValue
        profile_play_position = json["play_position"].stringValue
        profile_avatar = json["avatar"].stringValue
        profile_favorite_pitch = json["favorite_pitch"].stringValue

    }

}
class PlaypositionResponseModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let play_positions: play_position?
    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        
        play_positions = play_position(json["data"])

            }

}
class play_position {

    
    let play_positionsData: [play_positionData]?

  

    init(_ json: JSON) {
        play_positionsData = json["play_position"].arrayValue.map { play_positionData($0) }

        
    }

}
class play_positionData {

    let id: Int?
      let position: String?
      

      init(_ json: JSON) {
          id = json["id"].intValue
          position = json["position"].stringValue
          
      }

}



class CountryResponseModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let countryData: CountryArrayData?
    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        
        countryData = CountryArrayData(json["data"])

            }

}

class CountryArrayData {
    
    let country_Data: [Country_Data]?

    init(_ json: JSON) {
       
        
        country_Data = json["Country"].arrayValue.map { Country_Data($0) }

            }

}
class Country_Data {

  let id: Int?
    let sortname: String?
    let name: String?
    let phonecode: Int?
    let status: Int?
   
    init(_ json: JSON) {
        id = json["id"].intValue
        sortname = json["sortname"].stringValue
        name = json["name"].stringValue
        phonecode = json["phonecode"].intValue
        status = json["status"].intValue


    }

}
class StateResponseModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let stateData: StateArrayData?
    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        
        stateData = StateArrayData(json["data"])

            }

}

class StateArrayData {
    
    let state_Data: [State_Data]?

    init(_ json: JSON) {
       
        
        state_Data = json["States"].arrayValue.map { State_Data($0) }

            }

}
class State_Data {

  let id: Int?
    let name: String?
    let country_id: Int?
    let status: Int?
   
    init(_ json: JSON) {
        id = json["id"].intValue
        name = json["name"].stringValue
        country_id = json["country_id"].intValue
        status = json["status"].intValue


    }

}
