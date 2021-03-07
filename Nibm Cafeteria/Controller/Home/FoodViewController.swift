//
//  FoodViewController.swift
//  Nibm Cafeteria
//
//  Created by Nimesh Lakshan on 2021-03-02.
//

import UIKit

class FoodViewController: UIViewController {
    
    @IBOutlet weak var tblFoodItems: UITableView!
    @IBOutlet weak var collectionViewCategories: UICollectionView!
    
    var selectedIndex : Int = 0
    var selectedFoodItem : FoodItem!
    
    let foodItems : [FoodItem] = [
        FoodItem(imgFood: "breadWithCheese", foodName: "Bread With Cheese", foodInfo: "half tosted bread with cheese", foodPrice: 250.00, foodDiscount: 5),
        FoodItem(imgFood: "breadWithEggs", foodName: "Bread With Cheese", foodInfo: "Toasted bread with 2 eggs", foodPrice: 500.00, foodDiscount: 0),
        FoodItem(imgFood: "breadWithPeanutButter", foodName: "Bread with Peanut Butter", foodInfo: "Toasted Bread with peanut butter", foodPrice: 600.00, foodDiscount: 15),
        FoodItem(imgFood: "cheeseCake", foodName: "Cheese Cake", foodInfo: "Sweet Cheese Cake", foodPrice: 550.00, foodDiscount: 20),
        FoodItem(imgFood: "chocalate", foodName: "Chocolate", foodInfo: "Black Chocalate Bar", foodPrice: 250.00, foodDiscount: 0),
        FoodItem(imgFood: "coffee", foodName: "Black Coffee", foodInfo: "Black Coffee with cookie", foodPrice: 150.00, foodDiscount: 0),
        FoodItem(imgFood: "cornFlakes", foodName: "Creamy Corn Flakes", foodInfo: "Perfectly boiled corn flakes", foodPrice: 400.00, foodDiscount: 10)
    ]
    
    var categories : [Catogery] = [
        Catogery(categoryName: "All", isSelected: true),
        Catogery(categoryName: "Drinks", isSelected: false),
        Catogery(categoryName: "Pasta", isSelected: false),
        Catogery(categoryName: "Beverages", isSelected: false),
        Catogery(categoryName: "Deserts", isSelected: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        let nib = UINib(nibName: "FoodItemViewCell", bundle: nil)
        tblFoodItems.register(UINib(nibName: FoodItemViewCell.nibName, bundle: nil), forCellReuseIdentifier: FoodItemViewCell.reuseIdentifier)
        collectionViewCategories.register(UINib(nibName: CategoryViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: CategoryViewCell.reuseIdentifier)
        if let flowLayout = self.collectionViewCategories?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 100, height: 30)
        }
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FoodDetailsViewController" {
            let destVC = segue.destination as! FoodDetailsViewController
            destVC.foodItem = selectedFoodItem
        }
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

extension FoodViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblFoodItems.dequeueReusableCell(withIdentifier: FoodItemViewCell.reuseIdentifier, for: indexPath) as! FoodItemViewCell
        cell.selectionStyle = .none
        cell.configCell(foodItem: foodItems[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFoodItem = self.foodItems[indexPath.row]
        performSegue(withIdentifier: "FoodDetailsViewController", sender: nil)
    }
}


extension FoodViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewCategories.dequeueReusableCell(withReuseIdentifier: CategoryViewCell.reuseIdentifier, for: indexPath) as! CategoryViewCell
        cell.configCell(category: categories[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell: CategoryViewCell = Bundle.main.loadNibNamed(CategoryViewCell.nibName,
                                                                     owner: self,
                                                                     options: nil)?.first as? CategoryViewCell else {
            return CGSize.zero
        }
        cell.configCell(category: categories[indexPath.row])
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGSize(width: size.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        categories[selectedIndex].isSelected = false
        selectedIndex = indexPath.row
        categories[indexPath.row].isSelected = true
        
        UIView.transition(with: collectionViewCategories, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.collectionViewCategories.reloadData()
            self.collectionViewCategories.layoutIfNeeded()
            self.collectionViewCategories.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }, completion: nil)
    }
    
}
