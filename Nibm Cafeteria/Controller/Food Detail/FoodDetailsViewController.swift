//
//  FoodDetailsViewController.swift
//  Nibm Cafeteria
//
//  Created by Nimesh Lakshan on 2021-03-02.
//

import UIKit
import Kingfisher

class FoodDetailsViewController: BaseViewController {
    
    @IBOutlet weak var ImgFood: UIImageView!
    @IBOutlet weak var lblFoodName: UILabel!
    @IBOutlet weak var lblFoodInfo: UILabel!
    @IBOutlet weak var lblItemQty: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblDiscountedAmount: UILabel!
    @IBOutlet weak var viewContainerDiscount: UIView!
    @IBOutlet weak var lblDiscountRate: UILabel!
    
    var foodItem: FoodItem!
    var selectedQty: Int = 1
    
    let realmDB = RealmDB.instance

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateVIew()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonPressedAddToCart(_ sender: Any) {
        let cartItem = CartItem()
        cartItem.itemName = foodItem.foodName
        cartItem.itemImgRes = foodItem.foodImgRes
        cartItem.discount = foodItem.discount
        cartItem.itemPrice = foodItem.foodPrice
        cartItem.itemCount = selectedQty
        
        realmDB.addToCart(cartItem: cartItem, callback: {
            result in
            if result {
                displaySuccessMessage(message: "Item added to cart", completion: {
                    self.dismiss(animated: true, completion: nil)
                })
            } else {
                displayErrorMessage(message: "Failed to add to cart")
            }
        })
    }
    
    @IBAction func AddQtyButtonPressed(_ sender: Any) {
        selectedQty += 1
        refreshView()
    }
    
    @IBAction func removeQtyButtonPressed(_ sender: Any) {
        if selectedQty <= 1 {
            return
        }
        
        selectedQty -= 1
        refreshView()
    }
    
    func refreshView() {
        lblItemQty.text = "\(selectedQty)"
        
        UIView.transition(with: lblTotalAmount, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.lblTotalAmount.text = "\(Double.getLKRString(amount: self.foodItem.foodPrice * Double(self.selectedQty)))"
        }, completion: nil)
        
        if foodItem.discount != 0 {
            UIView.transition(with: lblDiscountedAmount, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.lblDiscountedAmount.text = "\(Double.getLKRString(amount: self.foodItem.discountedPrice * Double(self.selectedQty)))"
            }, completion: nil)
        }
    }
    
    func updateVIew() {
        if foodItem.discount == 0 {
            lblTotalAmount.textColor = UIColor(named: "dark")
            viewContainerDiscount.isHidden = true
            lblDiscountRate.isHidden = true
            lblDiscountedAmount.isHidden = true
        } else {
            lblTotalAmount.textColor = UIColor(named: "dark_gray")
            viewContainerDiscount.isHidden = false
            lblDiscountRate.isHidden = false
            lblDiscountedAmount.isHidden = false
            lblDiscountedAmount.text = "\(foodItem.discountedPrice.lkrString)"
            lblDiscountRate.text = "\(foodItem.discount)% OFF"
        }
        
        ImgFood.kf.setImage(with: URL(string: foodItem.foodImgRes))
//        imgFood.image = UIImage(named: foodItem.foodImgRes)
        lblFoodName.text = foodItem.foodName
        lblFoodInfo.text = foodItem.foodDescription
        lblTotalAmount.text = "\(foodItem.foodPrice.lkrString)"
    }
}
