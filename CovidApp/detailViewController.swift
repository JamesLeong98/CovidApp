//
//  detailViewController.swift
//  Homework3
//
//  Created by James Leong on 9/18/20.
//  Copyright © 2020 Carrie Hunner. All rights reserved.
//

import UIKit

class detailViewController: UIViewController {
    
    var propStateInitials:String = ""
    var propStateName:String = ""
    var propTotalCases:String = ""
    var propDeaths:String = ""
    var propDailyIncrease:String = ""
    var propRecovered:String = ""
    var propHospitalized:String = ""
    var propLastUpdated:String = ""
    
    @IBOutlet weak var stateFlag: UIImageView!
    @IBOutlet weak var stateName: UILabel!
    @IBOutlet weak var totalCases: UILabel!
    @IBOutlet weak var deaths: UILabel!
    @IBOutlet weak var dailyIncrease: UILabel!
    @IBOutlet weak var recovered: UILabel!
    @IBOutlet weak var hospitalized: UILabel!
    @IBOutlet weak var lastUpdated: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = propStateInitials
        
        self.stateName.text = propStateName
        self.totalCases.text = propTotalCases
        self.deaths.text = propDeaths
        self.dailyIncrease.text = "(+" + propDailyIncrease + ")"
        self.recovered.text = propRecovered
        self.hospitalized.text = propHospitalized
        self.lastUpdated.text = propLastUpdated
        self.stateFlag.image = UIImage(named: propStateInitials.lowercased())

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
