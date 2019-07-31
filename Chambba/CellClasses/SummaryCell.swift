//
//  SummaryCell.swift
//  Chambba
//
//  Created by Rohit Kumar on 12/03/19.
//  Copyright © 2019 Mayur chaudhary. All rights reserved.
//

import UIKit
import UICountingLabel

class SummaryCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UICountingLabel!
    @IBOutlet weak var staticImageView: UIImageView!
    @IBOutlet weak var backgroundview: UIView!
    @IBOutlet weak var currencyLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
