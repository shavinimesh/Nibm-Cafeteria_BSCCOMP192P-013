//
//  orderSummeryViewCell.swift
//  Nibm Cafeteria
//
//  Created by Nimesh Lakshan on 2021-03-07.
//

import UIKit

class orderSummeryViewCell: UITableViewCell {
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblSubTotalAmount: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
