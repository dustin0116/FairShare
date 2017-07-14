//
//  HomeViewController.swift
//  FairShare
//
//  Created by Dustin Hsiang on 7/10/17.
//  Copyright © 2017 Dustin Hsiang. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var items = [Item]()
    
    var itemNumber = 0
    
    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet weak var tipPercentLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet weak var numberOfPeopleTextField: UITextField!
    @IBOutlet weak var taxAmountTextField: UITextField!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var scanBillButton: UIButton!
    
    var isSelected = true
    
    var globlaKeyboardSize: CGRect! = CGRect.zero
    
    var isCheckedArray = [Bool]()
    
    var activeField: UITextField?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.intializeItems()
        
        calculateButton.layer.cornerRadius = 6
        addItemButton.layer.cornerRadius = 6
        scanBillButton.layer.cornerRadius = 6
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        numberOfPeopleTextField.tag = 1
        taxAmountTextField.tag = 2
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) //This will hide the keyboard
    }
                                                                                                                                                            
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        {
            globlaKeyboardSize = keyboardSize
            
            if let temporaryActiveField = activeField
            {
                textFieldShouldBeginEditing(temporaryActiveField)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        {
            globlaKeyboardSize = keyboardSize
            
            if let temporaryActiveField = activeField
            {
                textFieldShouldEndEditing(temporaryActiveField)
            }
        }
    }
    
    @IBAction func tipPercentValueChanged(_ sender: UISlider) {
        
        let currentPercent = String(Int(tipSlider.value))
        
        tipPercentLabel.text = "Tip \(currentPercent)%:"
        
    }
    
    @IBAction func tipSliderDrag(_ sender: Any) {
        
        tipSlider.isContinuous = true
        
    }
    
    @IBAction func addItemButton(_ sender: UIButton) {
        
        itemNumber += 1
        
        items.append(Item.init(itemNumber: itemNumber))
        
        print(items.count)
        
        tableView.reloadData()
        
        let lastRowIndexPath = IndexPath(row: items.count-1, section: 0)
        
        tableView.scrollToRow(at: lastRowIndexPath, at: .none, animated: true)
        
    }
    
    func intializeItems() {
        
        for _ in 1...5 {
            
            itemNumber += 1
            items.append(Item.init(itemNumber: itemNumber))
            print(items.count)
            
        }
        
        for _ in 0...items.count-1 {
            self.isCheckedArray.append(true)
        }
        
    }
}
//
//    @IBAction func calculateButtonTapped(_ sender: UIButton) {
//        
//        if let itemPrice = Double(){
//            
//            var tipPercentage = Double(tipSlider.value/100)
//            
//        }
//        
//
//        
//    }
//}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemTableViewCell", for: indexPath) as! ItemCell
        let item = items[indexPath.row]
        
        cell.itemTitleTextLabel.text = item.itemLabel
        cell.itemNumberLabel.text = String(indexPath.row + 1)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            items.remove(at: indexPath.row)
            
            tableView.reloadData()
            
        }
    }
}

extension HomeViewController: itemCheckList {
    
    func getInfo(for row: Int, to value: Bool) {
        isCheckedArray[row] = value
    }
}
//
//extension HomeViewController: dataFromItemCell {
////    
////    func setItemPrice(title: Double) {
////        
////        itemPriceTextLabel.text = itemPrice
////        
////    }
////    
//    
//    
//}

extension HomeViewController: UITextFieldDelegate
{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        activeField = textField
        
        if textField.tag == 1 || textField.tag == 2 && globlaKeyboardSize.height != 0.0
        {
            if self.view.frame.origin.y == 0
            {
                self.view.frame.origin.y -= globlaKeyboardSize.height
            }
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        activeField = textField
        
        if textField.tag == 1 || textField.tag == 2 && globlaKeyboardSize.height != 0.0
        {
            if self.view.frame.origin.y != 0
            {
                self.view.frame.origin.y += globlaKeyboardSize.height
            }
        }
        
        return true
    }
}
