//
//  OrderViewController.swift
//  Nibm Cafeteria
//
//  Created by Nimesh Lakshan on 2021-03-02.
//

import UIKit

class MyOrderViewController: BaseViewController {
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var tblOrderItems: UITableView!
    
    @IBOutlet weak var tblOrders: UITableView!
    @IBOutlet weak var segmentOrderType: UISegmentedControl!
    
    var fetchedOrders: [Order] = []
    var filteredOrders: [Order] = []
    
    let calendar = Calendar(identifier: .gregorian)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkMonitor.delegate = self
        firebaseOP.delegate = self
        tblOrders.register(UINib(nibName: MyOrderViewCell.nibName, bundle: nil), forCellReuseIdentifier: MyOrderViewCell.reuseIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        networkMonitor.delegate = self
        firebaseOP.delegate = self
        imgProfile.generateRoundImage()
        
        if #available(iOS 10.0, *) {
            tblOrders.refreshControl = refreshControl
        } else {
            tblOrders.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshOrderData), for: .valueChanged)
        
//        filteredOrders.removeAll()
////        filteredOrders.append(contentsOf: fetchedOrders)
////        tblOrders.reloadData()
        
        guard let email = SessionManager.getUserSesion()?.email else {
            return
        }
        displayProgress()
        firebaseOP.getAllOrders(email: email)
    }
    
    
    @IBAction func onOrderTypeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            filteredOrders.removeAll()
            filteredOrders.append(contentsOf: fetchedOrders)
            tblOrders.reloadData()
            return
        case 1:
            filteredOrders.removeAll()
            filteredOrders = fetchedOrders.filter { $0.orderStatus == OrderStatus.ORDER_PENDING || $0.orderStatus == OrderStatus.ORDER_READY }
            tblOrders.reloadData()
            return
        case 2:
            filteredOrders.removeAll()
            filteredOrders = fetchedOrders.filter { $0.orderStatus == OrderStatus.ORDER_COMPLETED }
            tblOrders.reloadData()
            return
        default:
            return
        }
    }
    
    @objc func refreshOrderData() {
        guard let email = SessionManager.getUserSesion()?.email else {
            return
        }
        firebaseOP.getAllOrders(email: email)
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

extension MyOrderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblOrders.dequeueReusableCell(withIdentifier: MyOrderViewCell.reuseIdentifier, for: indexPath) as! MyOrderViewCell
        cell.selectionStyle = .none
        cell.configureCell(order: filteredOrders[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(translationX: cell.contentView.frame.width, y: 0)
        UIView.animate(withDuration: 1.0, delay: 0.05 * Double(indexPath.row), usingSpringWithDamping: 0.4, initialSpringVelocity: 0.1,
                       options: .curveEaseIn, animations: {
                        cell.transform = CGAffineTransform(translationX: cell.contentView.frame.width, y: cell.contentView.frame.height)
                       })
    }
}

extension MyOrderViewController : FirebaseActions {
    func onAllOrdersLoaded(orderedList: [Order]) {
        refreshControl.endRefreshing()
        dismissProgress()
        fetchedOrders.removeAll()
        filteredOrders.removeAll()
        fetchedOrders.append(contentsOf: orderedList)
        filteredOrders.append(contentsOf: orderedList)
        tblOrders.reloadData()
        onOrderTypeChanged(self.segmentOrderType)
    }
    func onAllOrdersLoadFailed(error: String) {
        refreshControl.endRefreshing()
        dismissProgress()
        displayErrorMessage(message: error)
    }
}
