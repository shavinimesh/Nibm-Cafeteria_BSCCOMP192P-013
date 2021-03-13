//
//  ChangePasswordViewController.swift
//  Nibm Cafeteria
//
//  Created by Nimesh Lakshan on 2021-03-13.
//

import UIKit

class ChangePasswordViewController: BaseViewController {
    @IBOutlet weak var txtCurrentPassword: UITextField!
    @IBOutlet weak var txtNewPassWord: UITextField!
    @IBOutlet weak var txtReEnterPassWord: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseOP.delegate = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onChangePasswordPressed(_ sender: UIButton) {
        
        
        if !InputFieldValidator.isValidPassword(pass: txtCurrentPassword.text ?? "", minLength: 6, maxLength: 20){
            txtCurrentPassword.clearText()
            txtCurrentPassword.displayInlineError(errorString: InputErrorCaptions.invalidPassword)
            return
        }
        
        if !InputFieldValidator.isValidPassword(pass: txtNewPassWord.text ?? "", minLength: 6, maxLength: 20){
            txtNewPassWord.clearText()
            txtNewPassWord.displayInlineError(errorString: InputErrorCaptions.invalidPassword)
            return
        }
        
        if !InputFieldValidator.isValidPassword(pass: txtReEnterPassWord.text ?? "", minLength: 6, maxLength: 20){
            txtReEnterPassWord.clearText()
            txtReEnterPassWord.displayInlineError(errorString: InputErrorCaptions.invalidPassword)
            return
        }
        
        if txtNewPassWord.text ?? " " != txtReEnterPassWord.text ?? "" {
            txtNewPassWord.clearText()
            txtReEnterPassWord.clearText()
            txtReEnterPassWord.displayInlineError(errorString: InputErrorCaptions.passwordNotMatched)
            txtNewPassWord.displayInlineError(errorString: InputErrorCaptions.passwordNotMatched)
            return
        }
        if !networkMonitor.isReachable{
            self.displayErrorMessage(message: FieldErrorCaptions.noConnectionTitle)
            return
        }
        
        guard let email = SessionManager.getUserSesion()?.email else {
            NSLog("User mail is empty")
            displayErrorMessage(message: FieldErrorCaptions.updatePasswordFailed)
            return
        }
        displayProgress()
        firebaseOP.updateUserPassword(email: email, newPassword: txtNewPassWord.text!, existingPassword: txtCurrentPassword.text!)
    }
    
    @IBAction func onBackPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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

extension ChangePasswordViewController : FirebaseActions
{
    func onPasswordChanged() {
        dismissProgress()
        displaySuccessMessage(message: "Password changed Successfully", completion: {
            self.dismiss(animated: true, completion: nil)
        })
    }
    func onPasswordChangeFailedWithError(error: String) {
        dismissProgress()
        displayErrorMessage(message: error)
    }
}
