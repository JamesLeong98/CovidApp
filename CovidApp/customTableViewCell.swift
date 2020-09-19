//
//  customTableViewCell.swift
//  Homework3
//
//  Created by James Leong on 9/18/20.
//  Copyright © 2020 Carrie Hunner. All rights reserved.
//

import UIKit

class customTableViewCell: UITableViewCell {
    
    var state: String!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var stateCases: UILabel!
    @IBOutlet weak var stateFlag: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib();
        
        self.stateFlag.layer.cornerRadius = self.stateFlag.frame.height/2
        self.stateFlag.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
