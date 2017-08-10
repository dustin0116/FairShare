//
//  ItemCell.swift
//  FairShare
//
//  Created by Dustin Hsiang on 7/10/17.
//  Copyright © 2017 Dustin Hsiang. All rights reserved.
//
import Foundation
import UIKit


protocol ItemCheckList: class {
    
    func getInfo(row: Int, cell: ItemCell)
    func addPriceToArray(row: Int, text: String)
    
    
}

class ItemCell: UITableViewCell {

    @IBOutlet weak var itemTitleTextLabel: UILabel!
    @IBOutlet weak var itemPriceTextField: UITextField!
    @IBOutlet var isCheckedButton: UIButton!
    @IBOutlet weak var itemNumberLabel: UILabel!
    
    var item : Item?
    
    var isChecked = false
    
    var row = 0
    
    weak var delegate: ItemCheckList?
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        
        itemPriceTextField.text = nil
        super.prepareForReuse()

        
    }
    
    @IBAction func itemCheckButtonTapped(_ sender: UIButton) {
        
        isChecked = !isChecked
        
        delegate?.getInfo(row: row, cell: self)
        
        if self.isChecked {
            sender.setImage(#imageLiteral(resourceName: "Select"), for: .normal)
            item?.isChecked = true
        } else {
            sender.setImage(#imageLiteral(resourceName: "Reveal"), for: .normal)
            item?.isChecked = false
        }
    }
    
    @IBAction func itemPriceTextFieldEndEdit(_ sender: UITextField) {
        
        delegate?.addPriceToArray(row: row, text: itemPriceTextField.text!)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
