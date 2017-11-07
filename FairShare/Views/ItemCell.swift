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
    // Protocols to gain access from HomeViewController.
    func getInfo(row: Int, cell: ItemCell)
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
        // Reuses cells while setting text field as empty so that it won't reuse previous text field values.
        super.prepareForReuse()
        self.itemPriceTextField.text = nil
    }
    
    @IBAction func itemCheckButtonTapped(_ sender: UIButton) {
        // Sets check button function.
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
