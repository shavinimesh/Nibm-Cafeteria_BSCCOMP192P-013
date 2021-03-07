//
//  TextFieldUtils.swift
//  NIBMCafe
//
//  Created by Nimesh Lakshan on 2021-03-07.
//

import UIKit

extension UITextField {
    
    //Clear the textfield content
    func clearText(){
        self.text = ""
    }
    
    //Display the ERROR inside the textfield
    func displayInlineError(errorString: String){
        self.attributedPlaceholder = NSAttributedString(string: errorString, attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
    }
}
