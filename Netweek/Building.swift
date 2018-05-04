//
//  Building.swift
//  Netweek
//
//  Created by Saul Garza on 5/3/18.
//  Copyright © 2018 University of San Diego. All rights reserved.
//

import Foundation
class Building{
    var buildingName : String
    var rooms : [Room]?
    
    init(buildingName : String){
        self.buildingName = buildingName
    }
}
