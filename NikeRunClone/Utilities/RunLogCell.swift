//
//  RunLogCell.swift
//  NikeRunClone
//
//  Created by Fred Lefevre on 2019-06-01.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import UIKit

class RunLogCell: UITableViewCell {
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(run: Run) {
        durationLabel.text = run.duration.formatTimeDurationToString()
        distanceLabel.text = "\(run.distance.convertMetersToMiles(places: 2)) mi"
        paceLabel.text = run.pace.formatTimeDurationToString()
        dateLabel.text = run.date.getDateString()
    }

}
