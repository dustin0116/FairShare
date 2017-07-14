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
    
    var itemCells = [ItemCell]()
    
    var priceAmounts = [Double]()
    
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
        items.append(Item(itemNumber: itemNumber))
        
        isCheckedArray.append(true)
        
        print(items.count)
        
        tableView.reloadData()
        
        let lastRowIndexPath = IndexPath(row: items.count-1, section: 0)
        
        tableView.scrollToRow(at: lastRowIndexPath, at: .none, animated: true)
        
    }
    
    func intializeItems() {
        
        for _ in 1...5 {
            
            itemNumber += 1
            items.append(Item(itemNumber: itemNumber))
            isCheckedArray.append(true)
            print(items.count)
            print(isCheckedArray.count)
        }
    }
    
    @IBAction func calculateButtonTapped(_ sender: UIButton) {
        
        priceAmounts.removeAll()
        
        for cell in itemCells {
            
            if let priceAmount = Double(cell.itemPriceTextField.text!) {
                
                priceAmounts.append(priceAmount)
                
                print(priceAmount)
                
            } else {
                
                let aC = UIAlertController(title: "Error", message: "Invalid text for item price.", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                aC.addAction(okButton)
                present(aC, animated: true, completion: nil)
                break
            }
        }
    }
}



//MARK: -
extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemTableViewCell", for: indexPath) as! ItemCell
        let item = items[indexPath.row]
        
        cell.itemTitleTextLabel.text = item.itemLabel
        cell.itemNumberLabel.text = String(indexPath.row + 1)
        
        itemCells.append(cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            itemCells.remove(at: indexPath.row)
            items.remove(at: indexPath.row)
            isCheckedArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
    }
}

extension HomeViewController: itemCheckList {
    
    func getInfo(for row: Int, to value: Bool) {
        
        isCheckedArray[row] = value
        
    }
}

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
