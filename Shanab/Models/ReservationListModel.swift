//
//  ReservationListModel.swift
//  Shanab
//
//  Created by Macbook on 5/28/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
struct ReservationListModelJSON: Codable {
    var status: Bool?
    var data: AdditionsDataClass?
}

// MARK: - DataClass
struct AdditionsDataClass: Codable {
    var reservation: [reservationList]?
}

// MARK: - Reservation
struct reservationList: Codable {
    var id, clientID, restaurantID: Int?
    var numberOfPersons, date: String?
    var time: Time?
    var cancelation: Int?
    var createdAt, updatedAt: String?
    var restaurant: Restaurant?

    enum CodingKeys: String, CodingKey {
        case id
        case clientID = "client_id"
        case restaurantID = "restaurant_id"
        case numberOfPersons = "number_of_persons"
        case date, time, cancelation
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case restaurant
    }
}




enum Time: String, Codable {
    case the1000Am = "10:00 Am"
    case the10Am = "10 am"
    case time10Am = "10 Am"
}


   
