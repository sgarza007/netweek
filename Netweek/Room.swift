//
//  Room.swift
//  Netweek
//
//  Created by Saul Garza on 5/3/18.
//  Copyright © 2018 University of San Diego. All rights reserved.
//

import Foundation
class Room{
    var roommates : [Student]?
    var roomNum : String?
    var status = false
    init(roomNumber: String) {
        self.roomNum = roomNumber
    }
}
