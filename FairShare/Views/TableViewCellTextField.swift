//
//  TableViewCellTextField.swift
//  FairShare
//
//  Created by Dustin Hsiang on 8/4/17.
//  Copyright © 2017 Dustin Hsiang. All rights reserved.
//

import UIKit

protocol TableViewCellTextFieldDelegate: NSObjectProtocol {
    
      func textField(_ textField: TableViewCellTextField, moveToTextFieldWithTag tag: Int)
    
}

class TableViewCellTextField: UITextField {
    
    weak var moveTextFieldDelegate: TableViewCellTextFieldDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addHideinputAccessoryView()
    }
    
    func addHideinputAccessoryView() {
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        toolbar.barStyle = UIBarStyle.default
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done,
                                         
                                         target: self, action: #selector(self.resignFirstResponder))
        
        toolbar.setItems([doneButton], animated: true)
        
        let flexibleSpaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let fixedSpaceButton = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        
        let nextButton = UIBarButtonItem(title: ">", style: .plain, target: self, action: #selector(self.nextAction))
        
        let previousButton = UIBarButtonItem(title: "<", style: .plain, target: self, action: #selector(self.prevAction))
        
        toolbar.setItems([doneButton, flexibleSpaceButton, previousButton, fixedSpaceButton, nextButton], animated: false)
        
        toolbar.isUserInteractionEnabled = true
        
        self.inputAccessoryView = toolbar
        
    }
    
    func nextAction() {
        
        let newTag: Int = tag + 1
        if (self.delegate?.responds(to: Selector(("textField:moveToTextFieldWithTag:"))))! {
            (delegate as! TableViewCellTextFieldDelegate).textField(self, moveToTextFieldWithTag: newTag)
        }
        else {
            
            endEditing(true)
            
        }
    }
    
    func prevAction() {
        
        let newTag: Int = tag - 1
        if (delegate?.responds(to: Selector(("textField:moveToTextFieldWithTag:"))))! {
            (delegate as! TableViewCellTextFieldDelegate).textField(self, moveToTextFieldWithTag: newTag)
            
        } else {
            
            endEditing(true)
            
        }
    }
    
}

    
//    var prevButton = UIBarButtonItem(title: "<", style: .plain, target: self, action: #selector(prevAction))
//    
//    var nextButton = UIBarButtonItem(title: ">", style: .plain, target: self, action: #selector(nextAction))
//    




    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */


