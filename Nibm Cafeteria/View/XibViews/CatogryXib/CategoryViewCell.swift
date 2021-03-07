//
//  CategopryViewCell.swift
//  Nibm Cafeteria
//
//  Created by Nimesh Lakshan on 2021-03-02.
//

import UIKit

class CategoryViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblCategory: UILabel!
    
    class var reuseIdentifier: String {
        return "CategoryCellIdentifier"
    }
    
    class var nibName: String {
        return "CategoryViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configCell(category: Catogery) {
        lblCategory.text = category.categoryName
        if category.isSelected
        {
            viewContainer.backgroundColor = UIColor(named: "orange")
            lblCategory.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        else
        {
            viewContainer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            lblCategory.textColor = UIColor(named: "dark_gray")
        }
    }
}
