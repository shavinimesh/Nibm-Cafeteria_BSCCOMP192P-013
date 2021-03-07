//
//  CartItemViewCell.swift
//  Nibm Cafeteria
//
//  Created by Nimesh Lakshan on 2021-03-06.
//

import UIKit
import Kingfisher

class CartItemViewCell: UITableViewCell {
    @IBOutlet weak var imgFoodItem: UIImageView!
    @IBOutlet weak var lblFoodName: UILabel!
    @IBOutlet weak var lblFoodAmount: UILabel!
    @IBOutlet weak var lblQty: UILabel!
    
    var delegate: CartItemDelegate!
    var indexPath: IndexPath!
    
    class var reuseIdentifier: String {
        return "FoodCellIdentifier"
    }
    
    class var nibName: String {
        return "CartItemViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onMinusClicked(_ sender: UIButton) {
        delegate.onCartItemMinusClick(at: indexPath)
    }
    
    @IBAction func onAddClicked(_ sender: UIButton) {
        delegate.onCartItemAddClick(at: indexPath)
    }
    
    func configureCell(cartItem: CartItem) {
        imgFoodItem.kf.setImage(with: URL(string: cartItem.itemImgRes))
        lblFoodName.text = cartItem.itemName
        lblFoodAmount.text = "\(cartItem.itemTotal.lkrString)"
        lblQty.text = "\(cartItem.itemCount)"
    }
}

protocol CartItemDelegate {
    func onCartItemAddClick(at indexPath: IndexPath)
    func onCartItemMinusClick(at indexPath: IndexPath)
}
