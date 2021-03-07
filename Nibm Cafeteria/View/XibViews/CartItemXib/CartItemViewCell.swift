//
//  CartItemViewCell.swift
//  Nibm Cafeteria
//
//  Created by Nimesh Lakshan on 2021-03-06.
//

import UIKit

class CartItemViewCell: UITableViewCell {
    @IBOutlet weak var imgFoodItem: UIImageView!
    @IBOutlet weak var lblFoodName: UILabel!
    @IBOutlet weak var lblFoodAmount: UILabel!
    @IBOutlet weak var btnRemoveQty: UIButton!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var btnAddQty: UIButton!
    
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
    
    func configCell(foodItem: FoodItem) {
        lblFoodName.text = foodItem.foodName
        imgFoodItem.image = UIImage(named: foodItem.imgFood)
        lblFoodAmount.text = "RS. \(foodItem.foodPrice)"
        
    }
    
}
