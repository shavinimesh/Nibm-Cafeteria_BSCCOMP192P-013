//
//  UpdateProfileViewController.swift
//  Nibm Cafeteria
//
//  Created by Nimesh Lakshan on 2021-03-13.
//

import UIKit

class UpdateProfileViewController: BaseViewController {
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var imgProfile: UIImageView!
    
    let user = SessionManager.getUserSesion()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgProfile.generateRoundImage()
        networkMonitor.delegate = self
        firebaseOP.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        networkMonitor.delegate = self
        firebaseOP.delegate = self
        
        txtUserName.text = user?.userName
        txtPhoneNumber.text = user?.phoneNo
    }
    @IBAction func onBackPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onUpdateProfilePressed(_ sender: UIButton) {
        if !InputFieldValidator.isValidName(txtUserName.text ?? ""){
            txtUserName.clearText()
            txtUserName.displayInlineError(errorString: InputErrorCaptions.invalidName)
            return
        
        }
        if !InputFieldValidator.isValidMobileNo(txtPhoneNumber.text ?? ""){
            txtPhoneNumber.clearText()
            txtPhoneNumber.displayInlineError(errorString: InputErrorCaptions.invalidPhoneNo)
            return
            
        }
        
        guard var user = user else {
            NSLog("User Data Is Empty")
            displayErrorMessage(message: FieldErrorCaptions.updateUserFailed)
            return
        }
        if !networkMonitor.isReachable{
            self.displayErrorMessage(message: FieldErrorCaptions.noConnectionTitle)
            return
        }
        
        user.userName = txtUserName.text
        user.phoneNo = txtPhoneNumber.text
        displayProgress()
        firebaseOP.updateUser(user: user)
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

extension UpdateProfileViewController: FirebaseActions{
    func onUserDataUpdated(user: User?) {
        dismissProgress()
        SessionManager.saveUserSession(user!)
        displaySuccessMessage(message: "Successfully Updated profile", completion:{self.dismiss(animated: true, completion: nil)
        })
    }
    
    func onUserUpdateFailed(error: String) {
        dismissProgress()
        displayErrorMessage(message: error)

    }
    
}
