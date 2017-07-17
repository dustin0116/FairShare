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
    
    func getInfo(cell: ItemCell)
    
}

class ItemCell: UITableViewCell {

    @IBOutlet weak var itemTitleTextLabel: UILabel!
    @IBOutlet weak var itemPriceTextField: UITextField!
    @IBOutlet weak var itemNumberLabel: UILabel!
    @IBOutlet weak var isCheckedButton: UIButton!
    
    var isChecked = false
    
    weak var delegate: ItemCheckList?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    
    @IBAction func itemCheckButtonTapped(_ sender: UIButton) {
        
        
        delegate?.getInfo(cell: self)
        
        isChecked = !isChecked
        
        if self.isChecked {
            sender.setImage(#imageLiteral(resourceName: "Select"), for: .normal)
        } else {
            sender.setImage(#imageLiteral(resourceName: "Reveal"), for: .normal)
        }
        
    }
    
    
    
    
    
    
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
