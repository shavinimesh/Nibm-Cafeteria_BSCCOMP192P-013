//
//  CartViewController.swift
//  Nibm Cafeteria
//
//  Created by Nimesh Lakshan on 2021-03-06.
//

import UIKit

class CartViewController: BaseViewController {
    @IBOutlet weak var tblCartItem: UITableView!
    @IBOutlet weak var txtTotal: UILabel!
    @IBOutlet weak var lblItems: UILabel!
    
    var totalBill: Double = 0;
    
    let realmDB = RealmDB.instance
    
    var cartItems: [CartItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblCartItem.register(UINib(nibName: CartItemViewCell.nibName, bundle: nil), forCellReuseIdentifier: CartItemViewCell.reuseIdentifier)
        networkMonitor.delegate = self
        firebaseOP.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshCartInfo()
        networkMonitor.delegate = self
        firebaseOP.delegate = self
    }
    
    func refreshCartInfo() {
        cartItems.removeAll()
        cartItems.append(contentsOf: realmDB.getCartItems())
        lblItems.text = "\(cartItems.count) Items"
        totalBill = cartItems.lazy.map {$0.itemTotal}.reduce(0 , +)
        txtTotal.text = "RS. \(totalBill)"
    }
    
    @IBAction func onCheckoutClicked(_ sender: UIButton) {
        
        if cartItems.count == 0 {
            displayErrorMessage(message: "Cart is empty")
            return
        }
        
        displayOrderConfirmAlert()
    }
    
    func displayOrderConfirmAlert() {
        displayActionSheet(title: "Confirm Purchase",
                           message: "You are about to make a purchase or \(totalBill.lkrString), Confirm ?",
                           positiveTitle: "Yes",
                           negativeTitle: "Cancel",
                           positiveHandler: {
                            action in
                            self.confirmAndPurchase()
                           },
                           negativeHandler: {
                            action in
                            self.dismiss(animated: true, completion: nil)
                           })
    }
    
    func confirmAndPurchase() {
            guard let email = SessionManager.getUserSesion()?.email, let name = SessionManager.getUserSesion()?.userName else {
                NSLog("The email is empty")
                displayErrorMessage(message: FieldErrorCaptions.orderPlacingError)
                return
            }
            
            var orderItems: [OrderItem] = []
            for item in cartItems {
                orderItems.append(
                    OrderItem(
                        foodItem: FoodItem(foodName: item.itemName,
                                           foodDescription: item.description,
                                           foodPrice: item.discountedPrice,
                                           discount: item.discount,
                                           foodImgRes: item.itemImgRes,
                                           isActive: true),
                        qty: item.itemCount)
                )
            }
            
            displayProgress()
            firebaseOP.placeFoodOrder(order: Order(
                                        orderID: "",
                                        orderStatusCode: OrderStatusInt.ORDER_PENDING,
                                        orderStatusString: "Pending",
                                        orderDate: Date(),
                                        itemCount: cartItems.count,
                                        orderTotal: totalBill,
                                        orderItems: orderItems,
                                        customername: name),
                                      email: email, customerName: name)
        }
}

extension CartViewController: CartItemDelegate {
    func onCartItemAddClick(at indexPath: IndexPath) {
        //        self.cartItems[indexPath.row].itemCount += 1
        realmDB.updateItemQTY(cartItem: self.cartItems[indexPath.row], increased: true, callback: {
            result in
            if result {
                refreshCartInfo()
                tblCartItem.reloadRows(at: [indexPath], with: .automatic)
            } else {
                displayErrorMessage(message: "Could not update cart item")
            }
        })
    }
    
    func onCartItemMinusClick(at indexPath: IndexPath) {
        if self.cartItems[indexPath.row].itemCount == 1 {
            return
        }
        
        realmDB.updateItemQTY(cartItem: self.cartItems[indexPath.row], increased: false, callback: {
            result in
            if result {
                refreshCartInfo()
                tblCartItem.reloadRows(at: [indexPath], with: .automatic)
            } else {
                displayErrorMessage(message: "Could not update cart item")
            }
        })
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblCartItem.dequeueReusableCell(withIdentifier: CartItemViewCell.reuseIdentifier, for: indexPath) as! CartItemViewCell
        cell.selectionStyle = .none
        cell.indexPath = indexPath
        cell.delegate = self
        cell.configureCell(cartItem: cartItems[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            realmDB.deleteFromCart(cartItem: cartItems[indexPath.row], callback: {
                result in
                if result {
                    //                    tableView.deleteRows(at: [indexPath], with: .fade)
                    refreshCartInfo()
                    tblCartItem.reloadData()
                } else {
                    displayErrorMessage(message: "Could not remove item")
                }
            })
        }
    }
}

extension CartViewController : FirebaseActions {
    func onOrderPlaced() {
        dismissProgress()
        displaySuccessMessage(message: "Order placed successfully", completion: {
            self.dismiss(animated: true, completion: nil)
        })
        realmDB.removeAllFromCart(callback: {
            result in
            if result {
                NSLog("Items cleared")
            } else {
                NSLog("Unable to clear items")
            }
        })
        refreshCartInfo()
        tblCartItem.reloadData()
    }
    func onOrderPlaceFailedWithError(error: String) {
        dismissProgress()
        displayErrorMessage(message: error)
    }
}
