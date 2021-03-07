//
//  FoodDetailsViewController.swift
//  Nibm Cafeteria
//
//  Created by Nimesh Lakshan on 2021-03-02.
//

import UIKit

class FoodDetailsViewController: UIViewController {
    
    @IBOutlet weak var ImgFood: UIImageView!
    @IBOutlet weak var lblFoodName: UILabel!
    @IBOutlet weak var lblFoodInfo: UILabel!
    @IBOutlet weak var lblItemQty: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblDiscountedAmount: UILabel!
    @IBOutlet weak var lblDiscountRate: UILabel!
 
    
    
    var foodItem: FoodItem!
    var selectedQty: Int = 1
    //var totalAmount: Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblFoodName.text = foodItem.foodName
        lblFoodInfo.text = foodItem.foodInfo
        lblTotalAmount.text = "\(foodItem.foodPrice)"
        lblDiscountedAmount.text = "\(foodItem.discountedPrice)"
        lblDiscountRate.text = "\(foodItem.foodDiscount) %OFF"
        //ImgFood.image = foodItem.imgFood
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonPressedAddToCart(_ sender: Any) {
        
        
    }
    
    @IBAction func AddQtyButtonPressed(_ sender: Any) {
        selectedQty += 1
        lblItemQty.text = "\(selectedQty)"
        lblTotalAmount.text = "\(foodItem.foodPrice * Double(selectedQty))"
        lblDiscountedAmount.text = "\(foodItem.discountedPrice * Double(selectedQty))"
        
    }
    
    @IBAction func removeQtyButtonPressed(_ sender: Any) {
        
        if selectedQty == 1 {
            return
        }
        selectedQty -= 1
        //totalAmount = foodItem.foodPrice / Double(selectedQty)
        lblItemQty.text = "\(selectedQty)"
        lblTotalAmount.text = "\(foodItem.foodPrice / Double(selectedQty))"
        lblDiscountedAmount.text = "\(foodItem.discountedPrice * Double(selectedQty))"
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
