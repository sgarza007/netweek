//
//  Student.swift
//  Netweek
//
//  Created by Saul Garza on 5/3/18.
//  Copyright © 2018 University of San Diego. All rights reserved.
//

import Foundation
class Student{
    var name : String?
    var id : String?
    var helped = false
    init(name : String, id: String) {
        self.name = name
        self.id = id
    }
}
