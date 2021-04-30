//
//  MyOrderViewCell.swift
//  Nibm Cafeteria
//
//  Created by Nimesh Lakshan on 2021-03-07.
//

import UIKit

class MyOrderViewCell: UITableViewCell {
    
    @IBOutlet weak var lblOrdeID: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var labltemQty: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    class var reuseIdentifier: String {
        return "OrderCellIdentifier"
    }
    
    class var nibName: String {
        return "MyOrderViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(order: Order) {
        lblOrdeID.text = order.orderID
        lblDate.text = DateUtil.getDate(date: order.orderDate)
        labltemQty.text = "\(order.itemCount) Items"
        lblStatus.text = order.orderStatus.rawValue
        lblAmount.text = order.orderTotal.lkrString
    }
    
}
