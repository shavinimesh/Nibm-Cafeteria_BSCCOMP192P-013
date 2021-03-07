//
//  RoundButton.swift
//  NIBMCafe
//
//  Created by Nimesh Lakshan on 2021-03-07.
//

import Foundation
import UIKit

extension UIButton {
    func generateRoundButton() {
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        self.clipsToBounds = true
    }
}
