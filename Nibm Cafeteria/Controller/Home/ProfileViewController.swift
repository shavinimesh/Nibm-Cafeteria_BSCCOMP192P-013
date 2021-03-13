//
//  ProfileViewController.swift
//  Nibm Cafeteria
//
//  Created by Nimesh Lakshan on 2021-03-02.
//

import UIKit

class ProfileViewController: BaseViewController {

    @IBOutlet weak var tblOrderSummary: UITableView!
    
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblPhoneNo: UILabel!
    @IBOutlet weak var txtToDate: UITextField!
    @IBOutlet weak var txtFromDate: UITextField!
    
    var periodTotal: Double = 0
    
    let datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    
    var startDate: Date!
    var endDate: Date!
    
    var fetchedOrderList: [Order] = []
    var filteredOrders: [Order] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblOrderSummary.register(UINib(nibName: orderSummeryViewCell.nibName, bundle: nil), forCellReuseIdentifier: orderSummeryViewCell.reuseIdentifier)
        self.tblOrderSummary.estimatedRowHeight = 250
        self.tblOrderSummary.rowHeight = UITableView.automaticDimension
        networkMonitor.delegate = self
        firebaseOP.delegate = self
        datePicker.date = Date()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        networkMonitor.delegate = self
        firebaseOP.delegate = self
        
        if let user = SessionManager.getUserSesion() {
            lblUserName.text = user.userName
            lblPhoneNo.text = user.phoneNo
        }
        buildDatePicker()
        txtToDate.text = dateFormatter.string(from: Date())
        txtFromDate.text = dateFormatter.string(from: Date())
        
        fetchFromServer()
    }
    
    @IBAction func onEditClicked(_ sender: UIButton) {
        
    }
    
    func fetchFromServer() {
        if let email = SessionManager.getUserSesion()?.email {
            displayProgress()
            firebaseOP.getAllOrders(email: email)
        } else {
            NSLog("Unable to fetch user email")
        }
    }
    
    func refreshData() {
        filteredOrders.removeAll()
        let range = startDate...endDate
        for order in fetchedOrderList {
            if range.contains(order.orderDate) {
                filteredOrders.append(order)
            }
        }
        periodTotal = filteredOrders.lazy.map {$0.orderTotal}.reduce(0 , +)
        lblTotalAmount.text = periodTotal.lkrString
        tblOrderSummary.reloadData()
    }
    
    func buildDatePicker() {
        let pickerToolBar = UIToolbar()
        pickerToolBar.sizeToFit()
        
        let doneAction = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(onDatePicked))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(onPickerCancelled))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        pickerToolBar.setItems([doneAction, space, cancelButton], animated: true)
        txtToDate.inputAccessoryView = pickerToolBar
        txtFromDate.inputAccessoryView = pickerToolBar
        txtToDate.inputView = datePicker
        txtFromDate.inputView = datePicker
        datePicker.datePickerMode = .date
        dateFormatter.dateStyle = .medium
        
        if #available(iOS 13.4, *) {
           datePicker.preferredDatePickerStyle = .wheels
        }
    }
    
    @objc func onPickerCancelled() {
        self.view.endEditing(true)
    }
    
    @objc func onDatePicked() {
        if txtFromDate.isFirstResponder {
            if datePicker.date > endDate {
                txtToDate.text = dateFormatter.string(from: datePicker.date)
                endDate = datePicker.date
                return
            }
            txtFromDate.text = dateFormatter.string(from: datePicker.date)
            startDate = datePicker.date
        }
        if txtToDate.isFirstResponder {
            if datePicker.date < startDate {
                txtFromDate.text = dateFormatter.string(from: datePicker.date)
                startDate = datePicker.date
                return
            }
            txtToDate.text = dateFormatter.string(from: datePicker.date)
            endDate = datePicker.date
        }
        self.view.endEditing(true)
        refreshData()
    }
    
    @IBAction func OnSignOutPressed(_ sender: UIButton) {
        displayActionSheet(title: "Sign Out", message: "Are You sure You Want To Sign Out From The Application ?", positiveTitle: "Sign out", negativeTitle: "Cancel", positiveHandler: {
            action in
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
                SessionManager.clearUserSession()
                self.performSegue(withIdentifier: "profileToSplashScreen", sender: nil)
                
            }
        }, negativeHandler: {
            action in
        })
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

extension ProfileViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblOrderSummary.dequeueReusableCell(withIdentifier: orderSummeryViewCell.reuseIdentifier, for: indexPath) as! orderSummeryViewCell
        cell.selectionStyle = .none
        cell.configureCell(order: filteredOrders[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0, y : 0)
        UIView.animate(withDuration: 0.5, animations: {
            cell.transform = CGAffineTransform(scaleX: 1, y : 1)
        })
    }
}

extension ProfileViewController : FirebaseActions {
    func onAllOrdersLoaded(orderedList: [Order]) {
        dismissProgress()
        self.filteredOrders.removeAll()
        self.fetchedOrderList.removeAll()
        self.fetchedOrderList.append(contentsOf: orderedList)
        self.filteredOrders.append(contentsOf: orderedList)
        startDate = fetchedOrderList.min { $0.orderDate < $1.orderDate }?.orderDate
        endDate = fetchedOrderList.min { $0.orderDate > $1.orderDate }?.orderDate
        txtFromDate.text = dateFormatter.string(from: startDate)
        txtToDate.text = dateFormatter.string(from: endDate)
        refreshData()
    }
    func onAllOrdersLoadFailed(error: String) {
        dismissProgress()
        displayErrorMessage(message: error)
    }
}
