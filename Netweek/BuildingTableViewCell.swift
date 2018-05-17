//
//  BuildingTableViewCell.swift
//  Netweek
//
//  Created by Saul Garza on 5/15/18.
//  Copyright © 2018 University of San Diego. All rights reserved.
//

import UIKit

class BuildingTableViewCell: UITableViewCell {

    @IBOutlet weak var buildingName: UILabel!
    @IBOutlet weak var buildingImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
