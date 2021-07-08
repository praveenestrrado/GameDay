//
//  ContactResponseModel.swift
//  GameDay
//
//  Created by MAC on 19/03/21.
//

import Foundation
import SwiftyJSON

class ContactResponseModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let contact_Data_Main: Contact_Data_Main?
    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        
        contact_Data_Main = Contact_Data_Main(json["data"])

            }

}



class ContactSaveResponseModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let contact_SaveData_Main: Contact_SaveData_Main?
    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        
        contact_SaveData_Main = Contact_SaveData_Main(json["data"])

            }

}
class Contact_SaveData_Main {
    
    let message: String?
   


    init(_ json: JSON) {
       
        message = json["message"].stringValue


      


            }

}

class Contact_Data_Main {
    
    let phone_number: String?
    let pitch_types_data: [pitch_typesData]?
    let pitch_sizes_Data: [pitch_sizesData]?

    let pitch_turfs_data: [pitch_turfsData]?



    init(_ json: JSON) {
       
        phone_number = json["phone_number"].stringValue


        pitch_types_data = json["pitch_types"].arrayValue.map { pitch_typesData($0) }
        pitch_sizes_Data = json["pitch_sizes"].arrayValue.map { pitch_sizesData($0) }
        pitch_turfs_data = json["pitch_turfs"].arrayValue.map { pitch_turfsData($0) }


            }

}
class pitch_sizesData {

    let id: Int?
      let size_name: String?
    let size: String?


      init(_ json: JSON) {
          id = json["id"].intValue
        size_name = json["size_name"].stringValue
        size = json["size"].stringValue

          
      }

}
class pitch_turfsData {

    let id: Int?
      let turf_name: String?


      init(_ json: JSON) {
          id = json["id"].intValue
        turf_name = json["turf_name"].stringValue

          
      }

}
class pitch_typesData {

    let id: Int?
      let type_name: String?
      

      init(_ json: JSON) {
          id = json["id"].intValue
        type_name = json["type_name"].stringValue
          
      }

}
