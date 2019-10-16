//
//  ProductTableViewCell.swift
//  Moneybox
//
//  Created by Jack Munkonge on 16/10/2019.
//  Copyright © 2019 Organisation. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var planValue: UILabel!
    @IBOutlet weak var moneybox: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
