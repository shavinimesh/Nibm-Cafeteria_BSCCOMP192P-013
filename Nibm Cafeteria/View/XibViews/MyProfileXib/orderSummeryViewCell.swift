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
    
    class var reuseIdentifier: String {
        return "orderSummeryReuseIdentifier"
    }
    
    class var nibName: String {
        return "orderSummeryViewCell"
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
        lblItemName.addInterlineSpacing(spacingValue: 5)
        lblSubTotalAmount.addInterlineSpacing(spacingValue: 5, alignment: .right)
        
        var foodNames: String = ""
        var orderInfo: String = ""
        var totalAmount: Double = 0
                
        for item in order.orderItems {
            foodNames += "\n\(item.foodItem.foodName)"
            orderInfo += "\n\(item.qty) X \(item.foodItem.foodPrice.lkrString)"
            totalAmount += Double(item.qty) * item.foodItem.foodPrice
        }
        
        lblDate.text = DateUtil.getDate(date: order.orderDate)
        lblItemName.text = foodNames
        lblSubTotalAmount.text = orderInfo
        lblTotalAmount.text = "Total : \(totalAmount.lkrString)"
    }
    
}
