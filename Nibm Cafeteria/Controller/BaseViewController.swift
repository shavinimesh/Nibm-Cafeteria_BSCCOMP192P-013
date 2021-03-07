//
//  BaseViewController.swift
//  Nibm Cafeteria
//
//  Created by Nimesh Lakshan on 2021-03-07.
//

import UIKit
import Loaf

class BaseViewController: UIViewController, NetworkListener {
    
    var networkMonitor = NetworkMonitor.instance
    var popupAlerts = PopupAlerts.instance
    
    var firebaseOP = FirebaseOP.instance
    
    var progressHUD: ProgressHUD!
    
    let refreshControl = UIRefreshControl()
    
    var alertController: UIAlertController!

    override func viewDidLoad() {
        super.viewDidLoad()
        progressHUD = ProgressHUD(view: view)
        // Do any additional setup after loading the view.
    }
    
    func displayProgress() {
        progressHUD.displayProgressHUD()
    }
    
    func dismissProgress() {
        progressHUD.dismissProgressHUD()
    }
    
    func displayErrorMessage(message: String) {
        Loaf(message, state: .error, sender: self).show(.short)
    }
    
    func displaySuccessMessage(message: String, completion: (() -> Void)?) {
        Loaf(message, state: .success, sender: self).show(.short) {
            dismissal in
            if let completion  = completion {
                completion()
            }
        }
    }
    
    func displayInfoMessage(message: String) {
        Loaf(message, state: .info, sender: self).show(.short)
    }
    
    func displayWarningMessage(message: String) {
        Loaf(message, state: .warning, sender: self).show(.short)
    }
    
    func displayActionSheet(title: String, message: String, positiveTitle: String, negativeTitle: String, positiveHandler: @escaping (UIAlertAction) -> Void, negativeHandler: @escaping (UIAlertAction) -> Void) {
        if alertController == nil {
            alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        }
        alertController.title = title
        alertController.message = message
        alertController.addAction(UIAlertAction(title: positiveTitle, style: .default, handler: positiveHandler))
        alertController.addAction(UIAlertAction(title: negativeTitle, style: .destructive, handler: negativeHandler))
        self.present(alertController, animated: true, completion: nil)
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
