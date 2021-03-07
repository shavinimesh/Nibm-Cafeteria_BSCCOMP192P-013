//
//  CartViewController.swift
//  Nibm Cafeteria
//
//  Created by Nimesh Lakshan on 2021-03-06.
//

import UIKit

class CartViewController: UIViewController {
    @IBOutlet weak var tblCartItem: UITableView!
    
    var selectedIndex : Int = 0
    
    let foodItems : [FoodItem] = [
        FoodItem(imgFood: "breadWithCheese", foodName: "Bread With Cheese", foodInfo: "half tosted bread with cheese", foodPrice: 250.00, foodDiscount: 5),
        FoodItem(imgFood: "breadWithEggs", foodName: "Bread With Cheese", foodInfo: "Toasted bread with 2 eggs", foodPrice: 500.00, foodDiscount: 0),
        FoodItem(imgFood: "breadWithPeanutButter", foodName: "Bread with Peanut Butter", foodInfo: "Toasted Bread with peanut butter", foodPrice: 600.00, foodDiscount: 15),
        FoodItem(imgFood: "cheeseCake", foodName: "Cheese Cake", foodInfo: "Sweet Cheese Cake", foodPrice: 550.00, foodDiscount: 20),
        FoodItem(imgFood: "chocalate", foodName: "Chocolate", foodInfo: "Black Chocalate Bar", foodPrice: 250.00, foodDiscount: 0),
        FoodItem(imgFood: "coffee", foodName: "Black Coffee", foodInfo: "Black Coffee with cookie", foodPrice: 150.00, foodDiscount: 0),
        FoodItem(imgFood: "cornFlakes", foodName: "Creamy Corn Flakes", foodInfo: "Perfectly boiled corn flakes", foodPrice: 400.00, foodDiscount: 10)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblCartItem.register(UINib(nibName: CartItemViewCell.nibName, bundle: nil), forCellReuseIdentifier: CartItemViewCell.reuseIdentifier)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
//UITableView Protocols

extension CartViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblCartItem.dequeueReusableCell(withIdentifier: CartItemViewCell.reuseIdentifier, for: indexPath) as! CartItemViewCell
        cell.selectionStyle = .none
        cell.configCell(foodItem: foodItems[indexPath.row])
        return cell
    }
}
