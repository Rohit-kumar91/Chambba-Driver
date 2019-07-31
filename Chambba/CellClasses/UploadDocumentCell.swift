//
//  UploadDocumentCell.swift
//  Chambba
//
//  Created by Rohit Kumar on 01/03/19.
//  Copyright © 2019 Mayur chaudhary. All rights reserved.
//

import UIKit

class UploadDocumentCell: UITableViewCell {

    @IBOutlet weak var documentImageView: UIImageView!
    @IBOutlet weak var buttonStaticText: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
