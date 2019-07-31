//
//  ServicesCell.swift
//  Chambba
//
//  Created by Rohit Kumar on 19/03/19.
//  Copyright © 2019 Mayur chaudhary. All rights reserved.
//

import UIKit

class ServicesCell: UITableViewCell {

    
    @IBOutlet weak var serviceImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var providerLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var checkUncheckImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
