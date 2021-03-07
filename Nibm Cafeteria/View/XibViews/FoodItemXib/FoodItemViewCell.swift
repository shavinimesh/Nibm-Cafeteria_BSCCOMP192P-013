//
//  FoodItemViewCell.swift
//  Nibm Cafeteria
//
//  Created by Nimesh Lakshan on 2021-03-02.
//

import UIKit

class FoodItemViewCell: UITableViewCell {

    @IBOutlet weak var lblFoodInfo: UILabel!
    @IBOutlet weak var lblFoodName: UILabel!
    @IBOutlet weak var imgFoodItem: UIImageView!
    @IBOutlet weak var lblFoodPrice: UILabel!
    @IBOutlet weak var ViewContainerDiscount: UIView!
    @IBOutlet weak var lblDiscount: UILabel!
    
    
    class var reuseIdentifier: String {
        return "FoodCellIdentifier"
    }
    
    class var nibName: String {
        return "FoodItemViewCell"
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
        lblFoodInfo.text = foodItem.foodInfo
        lblFoodName.text = foodItem.foodName
        imgFoodItem.image = UIImage(named: foodItem.imgFood)
        lblFoodPrice.text = "RS. \(foodItem.foodPrice)"
        
        if foodItem.foodDiscount == 0
        {
            ViewContainerDiscount.isHidden = true
        }
        else
        {
            ViewContainerDiscount.isHidden = false
            lblDiscount.text = "\(foodItem.foodDiscount)% OFF"
        }
    }
    
}
