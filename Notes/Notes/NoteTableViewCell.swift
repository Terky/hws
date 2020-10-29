//
//  NoteTableViewCell.swift
//  Notes
//
//  Created by Артём Бурмистров on 5/1/20.
//  Copyright © 2020 Артём Бурмистров. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var desctiptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        desctiptionLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
